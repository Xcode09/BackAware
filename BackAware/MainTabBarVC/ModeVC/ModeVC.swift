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
    var peripherals:[CBPeripheral] = []
    var manager:CBCentralManager? = nil
    var parentView:UIViewController? = nil
    @IBOutlet weak var tableView:UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        manager?.delegate = self
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iosbrain.centralQueueName", attributes: .concurrent)
        // STEP 2: create a central to scan for, connect to,
        // manage, and collect data from peripherals
        manager = CBCentralManager(delegate: self, queue: centralQueue)
        scanBLEDevices()
    }
    
    
    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        manager?.scanForPeripherals(withServices: nil)
        
        //stop scanning after 3 seconds
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        //            self.stopScanForBLEDevices()
        //        }
    }
    func stopScanForBLEDevices() {
        manager?.stopScan()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]
        
        manager?.connect(peripheral, options: nil)
    }
    
    
}

extension ModeVC:CBCentralManagerDelegate,CBPeripheralDelegate{
    // MARK: - CBCentralManagerDelegate Methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        //bluetoothOffLabel.alpha = 1.0
        case .resetting:
            print("Bluetooth status is RESETTING")
        //bluetoothOffLabel.alpha = 1.0
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        //bluetoothOffLabel.alpha = 1.0
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        //bluetoothOffLabel.alpha = 1.0
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        //bluetoothOffLabel.alpha = 1.0
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            
            DispatchQueue.main.async { () -> Void in
                //                self.bluetoothOffLabel.alpha = 0.0
                //                self.connectingActivityIndicator.startAnimating()
            }
            
            // STEP 3.2: scan for peripherals that we're interested in
            manager?.scanForPeripherals(withServices:nil)
            
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
    
    //    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : AnyObject], rssi RSSI: NSNumber) {
    //
    //        if(!peripherals.contains(peripheral)) {
    //            peripherals.append(peripheral)
    //        }
    //
    //        self.tableView.reloadData()
    //    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //pass reference to connected peripheral to parent view
        //            parentView?.mainPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        //set the manager's delegate view to parent so it can call relevant disconnect methods
        //        manager?.delegate = self
        
        print("Connected to " +  peripheral.name!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
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
        print(characteristic)
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
        
        
//        for characteristic in service.characteristics! {
//            print(characteristic)
//
//            if characteristic.uuid == writeUUID {
//
//                // STEP 11: subscribe to a single notification
//                // for characteristic of interest;
//                // "When you call this method to read
//                // the value of a characteristic, the peripheral
//                // calls ... peripheral:didUpdateValueForCharacteristic:error:
//                //
//                // Read    Mandatory
//                //
//
//                peripheral.setNotifyValue(true, for: characteristic)
//                peripheral.readValue(for: characteristic)
//                //peripheral.setNotifyValue(true, for: characteristic)
//
//            }
//            if characteristic.uuid == readUUID {
//
//                // STEP 11: subscribe to a single notification
//                // for characteristic of interest;
//                // "When you call this method to read
//                // the value of a characteristic, the peripheral
//                // calls ... peripheral:didUpdateValueForCharacteristic:error:
//                //
//                // Read    Mandatory
//                //
//                //peripheral.readValue(for: characteristic)
//                peripheral.setNotifyValue(true, for: characteristic)
//                peripheral.readValue(for: characteristic)
//
//            }
//
//
//        } // END for
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        
        if characteristic.uuid == readUUID {
            
            // STEP 13: we generally have to decode BLE
            // data into human readable format
            let heartRate = deriveBeatsPerMinute(using: characteristic)
            
            print(heartRate)
            
            DispatchQueue.main.async { () -> Void in
                
                UIView.animate(withDuration: 1.0, animations: {
//                    self.beatsPerMinuteLabel.alpha = 1.0
//                    self.beatsPerMinuteLabel.text = String(heartRate)
                }, completion: { (true) in
                    //self.beatsPerMinuteLabel.alpha = 0.0
                })
                
            } // END DispatchQueue.main.async...
 
        }
        // END if characteristic.uuid ==..
    }
    
    
    func deriveBeatsPerMinute(using heartRateMeasurementCharacteristic: CBCharacteristic) -> Int {
        
        guard let heartRateValue = heartRateMeasurementCharacteristic.value else { return -00 }
        // convert to an array of unsigned 8-bit integers
        let buffer = [UInt8](heartRateValue)
 
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
            return -1
        }
        
    }
}
//4AC8A682-9736-4E5D-932B-E9B31405049C
//0972EF8C-7613-4075-AD52-756F33D4DA91
