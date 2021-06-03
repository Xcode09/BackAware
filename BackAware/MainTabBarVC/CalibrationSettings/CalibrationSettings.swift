//
//  CalibrationSettings.swift
//  BackAware
//
//  Created by Muhammad Ali on 13/04/2021.
//

import UIKit
class CalibrationSettings: UIViewController {

    @IBOutlet private weak var sensorDataLb:UILabel!
    @IBOutlet private weak var upperLimitPicker:UIPickerView!{
        didSet{
            upperLimitPicker.delegate = self
            upperLimitPicker.dataSource = self
            upperLimitPicker.tag = 0
        }
    }
    @IBOutlet private weak var lowerLimitPicker:UIPickerView!{
        didSet{
            lowerLimitPicker.delegate = self
            lowerLimitPicker.dataSource = self
            lowerLimitPicker.tag = 1
        }
    }
    //private var calibrationObj = CalibrationViewModel()
    
    private var limitArr = [String]()
    private var pickerUpperLimit = ""
    private var pickerLowerLimit = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        for i in 0..<3400{
            limitArr.append("\(i)")
        }
        upperLimitPicker.reloadAllComponents()
        lowerLimitPicker.reloadAllComponents()
        
        navigationItem.title = "Calibration Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let upperIndex = limitArr.firstIndex(of: "\(upperLimit)") ?? 0
        pickerUpperLimit = "\(upperLimit)"
        let lowerIndex = limitArr.firstIndex(of: "\(lowerLimit)") ?? 0
        pickerLowerLimit = "\(lowerLimit)"
        upperLimitPicker.selectRow(upperIndex, inComponent: 0, animated: true)
        lowerLimitPicker.selectRow(lowerIndex, inComponent: 0, animated: true)
    }
    
    @IBAction private func showLiveDataTapped(_ sender:UIButton){
        FirebaseDataService.instance.getData(eventType: .value) { [weak self]  (sensorValue) in
            guard let this = self else {return}
            guard sensorValue > 0 else {
                Toast.showToast(superView: this.view
                                , message: "No sensor data found")
                return
            }
            this.sensorDataLb.text = "\(sensorValue)"
        }
        
        FirebaseDataService.instance.getData(eventType: .childChanged) { [weak self]  (sensorValue) in
            guard let this = self else {return}
            guard sensorValue > 0 else {
                Toast.showToast(superView: this.view
                                , message: "No sensor data found")
                return
            }
            this.sensorDataLb.text = "\(sensorValue)"
        }
    }
    
    @IBAction private func calibrateTapped(_ sender:UIButton){
        guard Int(pickerUpperLimit) ?? 0 > Int(pickerLowerLimit) ?? 0 else {
            Toast.showToast(superView: self.view, message: "Upper Limit should be getter than lower limit")
            return
        }
        if pickerUpperLimit != "" && pickerLowerLimit != ""
        {
            let para : [String:Any] =  ["Flex1Limit":Int(pickerUpperLimit) ?? 0,"Flex2Limit":Int(pickerLowerLimit) ?? 0,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
            Toast.showToast(superView: self.view, message: "Calibration Setup Successfully")
        }
    }
    @IBAction private func normalCalibrateTapped(_ sender:UIButton){
        if sensorDataLb.text != "0" {
            let upperLimit = Int(sensorDataLb.text ?? "") ?? 0 + 200
            let lowerLimit = Int(sensorDataLb.text ?? "") ?? 0 - 150
            guard upperLimit > lowerLimit else {
                Toast.showToast(superView: self.view, message: "Upper Limit should be getter than lower limit")
                return
            }
            
            let para : [String:Any] =  ["Flex1Limit":upperLimit,"Flex2Limit":lowerLimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
            Toast.showToast(superView: self.view, message: "Normal Calibration Setup Successfully")
        }else{
            Toast.showToast(superView: self.view, message: "No sensor data")
        }
        
    }
    @IBAction private func hardCalibrateTapped(_ sender:UIButton){
        if sensorDataLb.text != "0" {
            let upperLimit = Int(sensorDataLb.text ?? "") ?? 0 + 115
            let lowerLimit = Int(sensorDataLb.text ?? "") ?? 0 - 75
            guard upperLimit > lowerLimit else {
                Toast.showToast(superView: self.view, message: "Upper Limit should be getter than lower limit")
                return
            }
            let para : [String:Any] =  ["Flex1Limit":upperLimit,"Flex2Limit":lowerLimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value:para)
            Toast.showToast(superView: self.view, message: "Hard Calibration Setup Successfully")
        }else{
            Toast.showToast(superView: self.view, message: "No sensor data")
        }
    }

}

extension CalibrationSettings:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return limitArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return limitArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            pickerUpperLimit = limitArr[row]
        }else{
            pickerLowerLimit = limitArr[row]
        }
    }
    
    
}
