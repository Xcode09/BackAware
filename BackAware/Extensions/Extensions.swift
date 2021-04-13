//
//  Extensions.swift
//  BackAware
//
//  Created by Muhammad Ali on 13/04/2021.
//

import UIKit
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checkbox")!
    let uncheckedImage = UIImage(named: "uncheckbox")!
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}


struct TimeAndDateHelper {
    static func getDate(date:Date=Date())->String{
        let currentDateTime = date
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateFormat = APP_DATE_FORMATE
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
}
