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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FirebaseDataService.instance.getData { [weak self]  (sensorValue) in
            self?.sensorDataLb.text = "\(sensorValue)"
        }
        
        for i in 0..<3400{
            limitArr.append("\(i)")
        }
        upperLimitPicker.reloadAllComponents()
        lowerLimitPicker.reloadAllComponents()
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
        print(limitArr[row])
    }
    
    
}
