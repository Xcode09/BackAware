//
//  VerifyPhoneNumber.swift
//  BackAware
//
//  Created by Muhammad Ali on 02/05/2021.
//

import UIKit
import FlagPhoneNumber
class VerifyPhoneNumber: UIViewController {
    
    @IBOutlet weak private var numberField : FPNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Enter Your Phone Number"
    }
    
    fileprivate func sendOTPCode(_ numberWithOutSpacing: String) {
        FirebaseDataService.instance.verifyPhoneNumber(with: numberWithOutSpacing) {[weak self](result) in
            DispatchQueue.main.async {
                [weak self] in
                guard let this = self else  {return}
                switch result{
                case .success(let id):
                    let vc = OTPVC(nibName: "OTPVC", bundle: nil)
                    vc.id = id
                    vc.number = numberWithOutSpacing
                    self?.navigationItem.title = ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let er):
                    Toast.showToast(superView: self?.view ?? UIView(), message: er.localizedDescription)
                }
            }
            
        }
    }
    
    @IBAction private func didTappedVerfiyBtn(_ sender:UIButton){
        guard let phoneNumber = numberField.getFormattedPhoneNumber(format: FPNFormat.International),
            numberField.hasText == true
        else{
            Toast.showToast(superView: self.view, message: "Please enter your phone number")
            return
            
        }
        let numberWithOutSpacing = phoneNumber.replacingOccurrences(of: " ", with: "")
        FirebaseDataService.instance.checkUserSession(withPath: numberWithOutSpacing, complicationHandler: {
            [weak self](result) in
            guard let self = self else {return}
            switch result{
            case .success(let uid):
                // Go to Tab Bar
                currentUserId = uid
                FirebaseDataService.instance.configureReference()
                UserDefaults.standard.setValue(numberWithOutSpacing, forKey: "login")
                UserDefaults.standard.synchronize()
                mainWindow.rootViewController = TabBarVC()
                mainWindow.makeKeyAndVisible()
                break
            case .failure:
                // Go to Authentication Screen
                self.sendOTPCode(numberWithOutSpacing)
            }
        })
        
        
    }
}
