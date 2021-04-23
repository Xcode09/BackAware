//
//  ModeVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit
import CoreBluetooth
class ModeVC: UIViewController {
    private var serviceId = CBUUID(string:"AB0828B1-198E-4351-B779-901FA0E0371E")
    private var characteristicUUID = CBUUID(string: "4AC8A682-9736-4E5D-932B-E9B31405049C")
    private var readUUID = CBUUID(string: "0972EF8C-7613-4075-AD52-756F33D4DA91")
    private var writeUUID = CBUUID(string: "4AC8A682-9736-4E5D-932B-E9B31405049C")
    private var peripherals:[CBPeripheral] = []
    private var manager:CBCentralManager? = nil
    var parentView:UIViewController? = nil
    private var sensorValue = 0
    private var secondsArr = [Int]()
    private var defualtColor : UIColor?
    private var isConnected = false
    @IBOutlet weak private var poorPostionCheckBox:CheckBox!
    @IBOutlet weak private var poorPostionlabel:UILabel!
    @IBOutlet weak private var microBreakCheckBox:CheckBox!
    @IBOutlet weak var timePicker:UITextField!{
        didSet{
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            if let tr = UserDefaults.standard.value(forKey: "0") as? String,tr == "true"
            {
                timePicker.isEnabled = true
            }else{
                timePicker.isEnabled = false
            }
            
            
            timePicker.inputView = picker
        }
    }
    @IBOutlet weak var tableView:UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = AppColors.tableViewColor
            tableView.register(SettingCell.self, forCellReuseIdentifier: "cell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.bgColor
        // Do any additional setup after loading the view.
        manager?.delegate = self
        
        
        for i in 0..<59{
            secondsArr.append(i)
        }
        
        poorPostionCheckBox.isTapped = {
            [weak self] (done) in
            if done{
                self?.poorPostionlabel.textColor = self?.defualtColor
                self?.timePicker.isEnabled = true
                self?.timePicker.resignFirstResponder()
            }
            else
            {
                self?.defualtColor = self?.poorPostionlabel.textColor
                self?.poorPostionlabel.textColor = .lightGray
                self?.timePicker.isEnabled = false
                self?.timePicker.resignFirstResponder()
            }
            
        }
        
        microBreakCheckBox.isTapped = {
            [weak self] (done) in
            if done{
                self?.showAlert()
            }
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setData), userInfo:nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Mode"
    }
    
    
    
    @IBAction private func startScanTapped(_ sender:UIButton){
        scanBLEDevices()
    }
    
    @IBAction private func disconnectScanTapped(_ sender:UIButton){
        peripherals.forEach { (peripheral) in
            manager?.cancelPeripheralConnection(peripheral)
        }
        isConnected = false
        peripherals.removeAll()
        tableView.reloadData()
        
    }
    
    @IBAction private func calibrationBtnTapped(_ sender:UIButton){
        let vc = CalibrationSettings(nibName: "CalibrationSettings", bundle: nil)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        Toast.showToast(superView: self.view, message: "Scanning Start..")
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iosbrain.centralQueueName", attributes: .concurrent)
        // STEP 2: create a central to scan for, connect to,
        // manage, and collect data from peripherals
        manager = CBCentralManager(delegate: self, queue: centralQueue)
        manager?.scanForPeripherals(withServices: nil)
        
        //stop scanning after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopScanForBLEDevices()
        }
    }
    func stopScanForBLEDevices() {
        manager?.stopScan()
        Toast.showToast(superView: self.view, message: "Finished Scanning")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
        self.view.endEditing(true)
    }
}

extension ModeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        cell.backgroundColor = AppColors.tableViewColor
        let peripheral = peripherals[indexPath.row]
        if isConnected{
            cell.bleNameLabel.text = peripheral.name ?? "Unknwon Device"
            cell.detailLabel.text = "Connected"
        }else{
            cell.bleNameLabel.text = "\(peripheral.name ?? "Unknown Device")"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]
        
        manager?.connect(peripheral, options: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "You enabled microbreaks notification", message: "A microbreak is any short break you take from your work during the day.This could be anything from standing up to stretch to chatting with a coworker for 2 mintues or even going to grab a coffee.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

extension ModeVC:CBCentralManagerDelegate,CBPeripheralDelegate{
    // MARK: - CBCentralManagerDelegate Methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        //            Toast.showToast(superView: self.view, message: "Bluetooth status is UNKNOWN")
        //bluetoothOffLabel.alpha = 1.0
        case .resetting:
            print("Bluetooth status is RESETTING")
        //            Toast.showToast(superView: self.view, message: "Bluetooth status is RESETTING")
        //bluetoothOffLabel.alpha = 1.0
        case .unsupported:
            DispatchQueue.main.async { () -> Void in
                print("Bluetooth status is UNSUPPORTED")
                //                Toast.showToast(superView: self.view, message: "Bluetooth status is UNSUPPORTED")
            }
            
        //bluetoothOffLabel.alpha = 1.0
        case .unauthorized:
            DispatchQueue.main.async { () -> Void in
                print("Bluetooth status is UNAUTHORIZED")
                //                Toast.showToast(superView: self.view, message: "Bluetooth status is UNAUTHORIZED")
            }
            
        //bluetoothOffLabel.alpha = 1.0
        case .poweredOff:
            DispatchQueue.main.async { () -> Void in
                //                Toast.showToast(superView: self.view, message: "Bluetooth status is POWERED OFF")
                print("Bluetooth status is POWERED OFF")
            }
            
        //bluetoothOffLabel.alpha = 1.0
        case .poweredOn:
            
            print("Bluetooth status is POWERED ON")
            
            DispatchQueue.main.async { () -> Void in
                
                //                Toast.showToast(superView: self.view, message: "Bluetooth status is POWERED ON")
            }
            
            // STEP 3.2: scan for peripherals that we're interested in
            manager?.scanForPeripherals(withServices:nil)
            
        @unknown default:
            print("")
        } // END switch
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        //self.tableView.reloadData()
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //pass reference to connected peripheral to parent view
        //            parentView?.mainPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        //set the manager's delegate view to parent so it can call relevant disconnect methods
        //        manager?.delegate = self
        DispatchQueue.main.async {
            [weak self] in
            self?.isConnected = true
            self?.tableView.reloadData()
        }
        print("Connected to " +  peripheral.name!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            
            Toast.showToast(superView: self.view, message: error?.localizedDescription ?? "Error")
        }
        
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            print(service.uuid)
            
            if service.uuid == serviceId {
                
                print("Service: \(service)")
                
                // STEP 9: look for characteristics of interest
                // within services of interest
                peripheral.discoverServices([serviceId])
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        DispatchQueue.main.async {
            
            Toast.showToast(superView: self.view, message: error?.localizedDescription ?? "Error")
        }
    }
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        
        if characteristic.uuid == readUUID {
            
            // STEP 13: we generally have to decode BLE
            // data into human readable format
            sensorValue = deriveBeatsPerMinute(using: characteristic)
            
            print(sensorValue)
            
            
            
        }
        // END if characteristic.uuid ==..
    }
    
    @objc private func setData(){
        if sensorValue != 0 {
            let dic = ["Data1":sensorValue,"Data2":"","Time":TimeAndDateHelper.getDate()] as [String : Any]
            FirebaseDataService.instance.setData(value: dic)
        }
        
    }
    
    func deriveBeatsPerMinute(using heartRateMeasurementCharacteristic: CBCharacteristic) -> Int {
        
        guard let heartRateValue = heartRateMeasurementCharacteristic.value else { return -00 }
        // convert to an array of unsigned 8-bit integers
        print("VALUES",heartRateValue)
        
        let buffer = [UInt8](heartRateValue)
        
        print("Buffer",buffer)
        
        // UInt8: "An 8-bit unsigned integer value type."
        
        // the first byte (8 bits) in the buffer is flags
        // (meta data governing the rest of the packet);
        // if the least significant bit (LSB) is 0,
        // the heart rate (bpm) is UInt8, if LSB is 1, BPM is UInt16
        if ((buffer[0] & 0x01) == 0) {
            // second byte: "Heart Rate Value Format is set to UINT8."
            print("BPM is UInt8")
            // write heart rate to HKHealthStore
            // healthKitInterface.writeHeartRateData(heartRate: Int(buffer[1]))
            return Int(buffer[1])
        } else { // I've never seen this use case, so I'll
            // leave it to theoroticians to argue
            // 2nd and 3rd bytes: "Heart Rate Value Format is set to UINT16."
            print("BPM is UInt16")
            return 0
        }
        
    }
}
extension ModeVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return secondsArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(secondsArr[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timePicker.text = "\(secondsArr[row]) min"
        
        UserDefaults.standard.set(secondsArr[row], forKey: "notify")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: notifyNotification, object: self)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            [weak self] in
            self?.timePicker.resignFirstResponder()
        }
        
    }
    
    
}


class SettingCell:UITableViewCell{
    let bleNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = AppColors.labelColor
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    let detailLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .green
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bleNameLabel)
        addSubview(detailLabel)
        
        let stack = UIStackView(arrangedSubviews: [bleNameLabel,UIView(),detailLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing =  5
        addSubview(stack)
        
        detailLabel.frame.size.width = self.frame.width/3
        stack.topAnchor.constraint(equalTo: self.topAnchor,constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
//        detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        detailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 8).isActive = true
//
//        detailLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 8).isActive = true
//
//        detailLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
