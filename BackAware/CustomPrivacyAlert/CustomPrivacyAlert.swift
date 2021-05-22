//
//  CustomPrivacyAlert.swift
//  BackAware
//
//  Created by Muhammad Ali on 22/05/2021.
//

import UIKit
protocol CustomPrivacyAlertDelegate{
    func didTappedYes()
    func didTappedNo()
    
}
class CustomPrivacyAlert: UIViewController {
    
    @IBOutlet weak var textView:UITextView!
    var delegate:CustomPrivacyAlertDelegate?
    private let link = "https://www.hackingwithswift.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
        
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let string1 = NSMutableAttributedString(string: "Our Privacy policy is below click our ",attributes: [NSAttributedString.Key.foregroundColor:AppColors.labelColor!,NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.font:font])
        let attributedString = NSAttributedString(string: "privacy policy ",attributes: [NSAttributedString.Key.link:link,NSAttributedString.Key.foregroundColor:AppColors.labelColor!,NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.font:font])
        let string2 = NSAttributedString(string: "to get more information.",attributes: [NSAttributedString.Key.foregroundColor:AppColors.labelColor!,NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.font:font])
        string1.append(attributedString)
        string1.append(string2)
        textView.textAlignment = .center
        self.textView.linkTextAttributes = [
            .foregroundColor: AppColors.labelColor!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.attributedText = string1
    }
    
    
    @IBAction private func tappedYes(_ sender:UIButton){
        delegate?.didTappedYes()
    }
    @IBAction private func tappedNo(_ sender:UIButton){
        delegate?.didTappedNo()
    }
    
}
