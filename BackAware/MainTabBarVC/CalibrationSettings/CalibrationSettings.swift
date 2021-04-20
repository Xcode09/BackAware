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
        
        FirebaseDataService.instance.getData(eventType: .childChanged) { [weak self]  (sensorValue) in
            self?.sensorDataLb.text = "\(sensorValue)"
        }
        for i in 0..<3400{
            limitArr.append("\(i)")
        }
        upperLimitPicker.reloadAllComponents()
        lowerLimitPicker.reloadAllComponents()
        
        navigationItem.title = "Calibration Settings"
    }
    
    @IBAction private func calibrateTapped(_ sender:UIButton){
        if pickerUpperLimit != "" && pickerLowerLimit != ""
        {
            let para : [String:Any] =  ["Flex1Limit":Int(pickerUpperLimit) ?? 0,"Flex2Limit":Int(pickerLowerLimit) ?? 0,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
        }
    }
    @IBAction private func normalCalibrateTapped(_ sender:UIButton){
        if sensorDataLb.text != "0" {
            let upperLimit = Int(sensorDataLb.text ?? "") ?? 0 + 200
            let lowerLimit = Int(sensorDataLb.text ?? "") ?? 0 - 150
            let para : [String:Any] =  ["Flex1Limit":upperLimit,"Flex2Limit":lowerLimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: para)
        }
        
    }
    @IBAction private func hardCalibrateTapped(_ sender:UIButton){
        if sensorDataLb.text != "0" {
            let upperLimit = Int(sensorDataLb.text ?? "") ?? 0 + 115
            let lowerLimit = Int(sensorDataLb.text ?? "") ?? 0 - 75
            let para : [String:Any] =  ["Flex1Limit":upperLimit,"Flex2Limit":lowerLimit,"Time":TimeAndDateHelper.getDate()]
            FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value:para)
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
