//
//  ModeVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 11/04/2021.
//

import UIKit
import CoreBluetooth
import DLRadioButton
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
    private var centralBLEDeviceName = "Unknown Device"
    private lazy var selectedIndexPath : IndexPath = IndexPath()
//    private lazy var deSelectedIndexPath : IndexPath = IndexPath()
    private var isSelectTag = 0
    private var _peripheral : CBPeripheral?
    private var _characteristics: [CBCharacteristic]?
    @IBOutlet weak private var gymRadioBox:UIButton!{
        didSet{
            if let isTrue = UserDefaults.standard.value(forKey: "\(gymRadioBox.tag)") as? String,isTrue == "true"{
                gymRadioBox.setImage(checkedImage, for: .normal)
            }else{
                gymRadioBox.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    @IBOutlet weak private var poorPostionlabel:UILabel!
    @IBOutlet private var officeRadioRox:UIButton!{
        didSet{
            if let isTrue = UserDefaults.standard.value(forKey: "\(officeRadioRox.tag)") as? String,isTrue == "true"{
                officeRadioRox.setImage(checkedImage, for: .normal)
            }else{
                officeRadioRox.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    @IBOutlet weak var timePicker:UITextField!{
        didSet{
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            
            if let tr = UserDefaults.standard.value(forKey: "1") as? String,tr == "true"
            {
                timePicker.isEnabled = true
                timePicker.textColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
                poorPostionlabel.textColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
                
            }else{
                
                timePicker.isEnabled = false
                timePicker.textColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1).withAlphaComponent(0.2)
                poorPostionlabel.textColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1).withAlphaComponent(0.2)
            }
            
            
            timePicker.inputView = picker
        }
    }
    @IBOutlet weak var tableView:UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
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
        
        
//        officeRadioBox.addTarget(self, action: #selector(setConfigurationOfficeMode(sender:)), for: .touchUpInside)
        
//        gymRadioBox.isTapped = {
//            [weak self] (done) in
//            if done{
//                self?.officeRadioBox.isChecked = false
////                self?.poorPostionlabel.textColor = AppColors.lightTextColor
////                self?.timePicker.isEnabled = true
////                self?.timePicker.textColor = AppColors.lightTextColor
////                self?.timePicker.resignFirstResponder()
//            }
//            else
//            {
//
////                self?.timePicker.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
////                self?.poorPostionlabel.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
////                self?.timePicker.isEnabled = false
////                self?.timePicker.resignFirstResponder()
//            }
//
//        }
        
//        officeRadioBox.isTapped = {
//            [weak self] (done) in
//            if done{
//                self?.gymRadioBox.isChecked = false
//                self?.poorPostionlabel.textColor = AppColors.lightTextColor
//                self?.timePicker.isEnabled = true
//                self?.timePicker.textColor = AppColors.lightTextColor
//                self?.timePicker.resignFirstResponder()
//            }
//            else
//            {
//                self?.timePicker.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
//                self?.poorPostionlabel.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
//                self?.timePicker.isEnabled = false
//                self?.timePicker.resignFirstResponder()
//            }
//        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setData), userInfo:nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Mode"
        if let tr = UserDefaults.standard.value(forKey: "0") as? String,tr == "true",let value = UserDefaults.standard.value(forKey: "notify") as? Int
        {
            timePicker.text = "\(value) min"
        }
    }
    
    
    
    @IBAction private func startScanTapped(_ sender:UIButton){
        scanBLEDevices()
    }
    
    @IBAction private func disconnectScanTapped(_ sender:UIButton){
        peripherals.forEach { (peripheral) in
            manager?.cancelPeripheralConnection(peripheral)
        }
        isConnected = false
        connectedDevices = 0
        peripherals.removeAll()
        selectedIndexPath = IndexPath()
        tableView.reloadData()
        
    }
    
    @IBAction private func calibrationBtnTapped(_ sender:UIButton){
        let vc = CalibrationSettings(nibName: "CalibrationSettings", bundle: nil)
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func setConfigurationGymMode(_ sender:UIButton)
    {
        
         officeRadioRox.setImage(uncheckedImage, for: .normal)
         gymRadioBox.setImage(checkedImage, for: .normal)
        self.timePicker.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
        self.poorPostionlabel.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
        self.timePicker.isEnabled = false
        self.timePicker.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: "0")
        UserDefaults.standard.removeObject(forKey: "1")
        UserDefaults.standard.set("true", forKey: "\(sender.tag)")
        UserDefaults.standard.synchronize()
        guard connectedDevices > 0 else {
            Toast.showToast(superView: self.view, message:noConnectedDevice)
            return
            
        }
        // Flag value is at after forthComma
        let dataString = "\(upperLimit),\(lowerLimit),1,0,6"
        if let charas = _characteristics,let per = _peripheral,let data = dataString.data(using: .utf8)
        {
            for characteristic in charas{
                if characteristic.uuid == writeUUID{
                    per.writeValue(data, for: characteristic, type: .withResponse)
                }
            }
            
        }
        
//        isSelectTag = s
//        if isSelectTag != 0 {
//           officeRadioRox.setImage(uncheckedImage, for: .normal)
//            gymRadioBox.setImage(checkedImage, for: .selected)
//
//        }else{
//            gymRadioBox.setImage(uncheckedImage, for: .normal)
//
//        }
      
    }
    @IBAction private func setConfigurationOfficeMode(sender:UIButton){
        gymRadioBox.setImage(uncheckedImage, for: .normal)
        officeRadioRox.setImage(checkedImage, for: .normal)
        self.poorPostionlabel.textColor = AppColors.lightTextColor
        self.timePicker.isEnabled = true
        self.timePicker.textColor = AppColors.lightTextColor
        self.timePicker.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: "0")
        UserDefaults.standard.removeObject(forKey: "1")
        UserDefaults.standard.set("true", forKey: "\(sender.tag)")
        UserDefaults.standard.synchronize()
        guard connectedDevices > 0 else {
            Toast.showToast(superView: self.view, message:noConnectedDevice)
            return
            
        }
        let dataString = "\(upperLimit),\(lowerLimit),1,0,5"
        if let charas = _characteristics,let per = _peripheral,let data = dataString.data(using: .utf8)
        {
            for characteristic in charas{
                if characteristic.uuid == writeUUID{
                    per.writeValue(data, for: characteristic, type: .withResponse)
                }
            }
            
        }
      
        
        
//        if isSelectTag == 0 {
//            gymRadioBox.setImage(uncheckedImage, for: .normal)
//            sender.setImage(checkedImage, for: .selected)
//        }else{
//            sender.setImage(uncheckedImage, for: .normal)
//        }
//        if sender.isSelected{
//            //self?.gymRadioBox.isChecked = false
//            self.gymRadioBox.setImage(uncheckedImage, for: .normal)
//            self.poorPostionlabel.textColor = AppColors.lightTextColor
//            self.timePicker.isEnabled = true
//            self.timePicker.textColor = AppColors.lightTextColor
//            self.timePicker.resignFirstResponder()
//        }
//        else
//        {
//            self.timePicker.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
//            self.poorPostionlabel.textColor = AppColors.lightTextColor.withAlphaComponent(0.2)
//            self.timePicker.isEnabled = false
//            self.timePicker.resignFirstResponder()
//        }
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
//        manager?.scanForPeripherals(withServices: [serviceId], options: nil)
        
        //stop scanning after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
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
        timePicker.resignFirstResponder()
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
        cell.tag = indexPath.row
        cell.bleNameLabel.text = "\(centralBLEDeviceName)"
        cell.bleAddressLabel.text = peripheral.identifier.uuidString
        if selectedIndexPath == indexPath {
            cell.detailLabel.text = "Connected"
            let selectPeripheral = peripherals[selectedIndexPath.row]
            manager?.connect(selectPeripheral, options: nil)
        }else{
            cell.detailLabel.text = "Disconnected"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            manager?.scanForPeripherals(withServices:nil)
            
        @unknown default:
            print("")
        } // END switch
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
//        debugPrint(peripheral)
//        debugPrint(advertisementData)
//        if(!peripherals.contains(peripheral)) {
//            connectedDevices += 1
//            peripherals.append(peripheral)
//        }
        if let localName = advertisementData["kCBAdvDataLocalName"] as? String,localName == bleDeviceName
        {
            connectedDevices += 1
            centralBLEDeviceName = advertisementData["kCBAdvDataLocalName"] as! String
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
        DispatchQueue.global(qos: .background).async {
            peripheral.discoverServices(nil)
        }
        manager?.delegate = self
//        DispatchQueue.main.async {
//            [weak self] in
//            self?.isConnected = true
//            self?.tableView.reloadData()
//        }
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
        
        if error != nil {
            DispatchQueue.main.async {
                
                Toast.showToast(superView: self.view, message: error?.localizedDescription ?? "Error")
            }
        }else{
            DispatchQueue.main.async {
                Toast.showToast(superView: self.view, message:"Successfully Write Value")
            }
        }
        
        
    }
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        _peripheral = peripheral
        _characteristics = characteristics
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                //print("DDDD",characteristic.value)
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
            
            print("Sensor Value",sensorValue)
            
            
            
        }
        if characteristic.uuid == writeUUID{
            print("Data is writed")
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
        
        guard let heartRateValue = heartRateMeasurementCharacteristic.value else { return 0 }
        // convert to an array of unsigned 8-bit integers
        print("VALUES",heartRateValue)
        
        let buffer = [UInt8](heartRateValue)
        
        let firstBitValue = buffer[0] & 0x01
          if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(buffer[1] << 6) + Int(buffer[2])
          } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(buffer[2]) << 5) //(Int(buffer[1]) << 8) + Int(buffer[2])
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
    var didTappedConnectDevice:((SettingCell)->Void)?
    let bleNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = AppColors.labelColor
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    let bleAddressLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = AppColors.labelColor
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.6
        lbl.textAlignment = .left
        return lbl
    }()
    
    let detailLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = AppColors.connectStatus
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = true
//        lbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapConnect)))
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bleNameLabel)
        addSubview(bleAddressLabel)
        addSubview(detailLabel)
        let container = UIStackView(arrangedSubviews: [bleNameLabel,bleAddressLabel])
        container.axis = .vertical
        container.distribution = .fillProportionally
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [container,UIView(),detailLabel])
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
    
    @objc private func didTapConnect(){
        didTappedConnectDevice?(self)
    }
    
}
//if isConnected{
//    cell.bleNameLabel.text = "\(peripheral.name ?? "Unknown Device")"
//    cell.bleAddressLabel.text = ""
//    cell.detailLabel.text = "Connected"
//}
