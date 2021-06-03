//
//  OTPVC.swift
//  BackAware
//
//  Created by Muhammad Ali on 02/05/2021.
//

import UIKit
import OTPFieldView
class OTPVC: UIViewController {
    
    @IBOutlet weak private var labelI:UILabel!
    @IBOutlet weak private var otpTextFieldView:OTPFieldView!
    var id = ""
    private var verificationCode = ""
    var number = ""
    private var counter = 0.10
    private var timer : Timer?
    @IBOutlet weak private var continueBtn:UIButton!
    @IBOutlet weak private var resendCodeIn:UILabel!{
        didSet{
            resendCodeIn.isUserInteractionEnabled = false
            resendCodeIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCode)))
        }
    }
    private let labelColor = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Verify Phone Number"
        
        // Do any additional setup after loading the view.
        continueBtn.backgroundColor = labelColor
        continueBtn.isEnabled = false
        setupOtpView()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "timer"), object: self, queue: .main) {[weak self](_) in
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self](timer) in
                guard let this = self,
                      this.counter >= 0.01
                else {
                    self?.counter = 0.10
                    self?.resendCodeIn.text = "Resend Code"
                    self?.resendCodeIn.isUserInteractionEnabled = true
                    self?.continueBtn.isEnabled = false
                    timer.invalidate()
                    return
                }
                let attributedTe1 = NSMutableAttributedString()
                attributedTe1.append("Resend Code in".getAttributedString(alignment: .center, color: this.labelColor))
                this.counter -= 0.01
                let roundNumber = Double(round(1000*this.counter)/1000)
                let strin = "\(roundNumber)"
                attributedTe1.append(" ".getAttributedString(alignment: .center, color: this.labelColor))
                attributedTe1.append(strin.getAttributedString(alignment: .center, color: this.labelColor))
                this.resendCodeIn.attributedText = attributedTe1
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self](timer) in
            guard let this = self,
                  this.counter >= 0.01
            else {
                self?.counter = 0.10
                self?.resendCodeIn.text = "Resend Code"
                self?.resendCodeIn.isUserInteractionEnabled = true
                self?.continueBtn.isEnabled = false
                timer.invalidate()
                return
            }
            let attributedTe1 = NSMutableAttributedString()
            attributedTe1.append("Resend Code in".getAttributedString(alignment: .center, color: this.labelColor))
            this.counter -= 0.01
            let roundNumber = Double(round(1000*this.counter)/1000)
            let strin = "\(roundNumber)"
            attributedTe1.append(" ".getAttributedString(alignment: .center, color: this.labelColor))
            attributedTe1.append(strin.getAttributedString(alignment: .center, color: this.labelColor))
            this.resendCodeIn.attributedText = attributedTe1
        }
        
    }
    
    
    func setupOtpView(){
        let attributedTe = NSMutableAttributedString()
        attributedTe.append("Enter the 6-digit code that we sent to".getAttributedString(alignment: .left, color: AppColors.labelColor ?? UIColor()))
        
        attributedTe.append("\n".getAttributedString())
        attributedTe.append(number.getAttributedString(alignment: .left, color:UIColor.blue.withAlphaComponent(0.6)))
        labelI.attributedText = attributedTe
        
        self.otpTextFieldView.fieldsCount = 6
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = AppColors.labelColor ?? UIColor()
        self.otpTextFieldView.filledBorderColor = AppColors.labelColor ?? UIColor()
        self.otpTextFieldView.cursorColor = AppColors.labelColor ?? UIColor()
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 8
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        //        self.otpTextFieldView.isContentTypeOneTimeCode =
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    
    @IBAction private func verifyOtp(_ sender:UIButton){
        guard verificationCode != "" else {return}
        Toast.showActivity(superView: self.view)
        FirebaseDataService.instance.verifyOTP(with: id, verificationCode: verificationCode) { (result) in
            DispatchQueue.main.async {
                [weak self] in
                guard let this = self
                      else {return}
                switch result{
                case .success(let uid):
                    currentUserId = uid
                    UserDefaults.standard.setValue(this.number, forKey: "login")
                    UserDefaults.standard.synchronize()
                    FirebaseDataService.instance.configureReference()
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                        [weak self] in
                        guard let self = self else {return}
                        FirebaseDataService.instance.storeUserDevice(path: self.number, value: ["login":true])
                        FirebaseDataService.instance.setData(path: FirebaseDbPaths.calibrate, value: ["Flex1Limit":0,"Flex2Limit":0, "Time": TimeAndDateHelper.getDate()])
                        FirebaseDataService.instance.setData(path: FirebaseDbPaths.sensorData, value: ["Data1":0,"Data2":0, "Time": TimeAndDateHelper.getDate()])
                        FirebaseDataService.instance.setData(path: FirebaseDbPaths.statistics, value: ["good":0,"poorExtension":0, "poorFlex":0,"Time": TimeAndDateHelper.getDate()])
                        FirebaseDataService.instance.setData(path: FirebaseDbPaths.trainingTest, value: ["good":0,"poorExt":0, "poorflex":0])
                        DispatchQueue.main.asyncAfter(deadline: .now()+12) {
                            [weak self] in
                            guard let self =  self else {return}
                            Toast.dismissActivity(superView: self.view)
                            let scene = UIApplication.shared.connectedScenes.first
                            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate),let window = sd.window
                            {
                                window.rootViewController = TabBarVC()
                                window.makeKeyAndVisible()
                            }
                        }
                    }
                case .failure(let er):
                    Toast.dismissActivity(superView: this.view)
                    Toast.showToast(superView: this.view, message: er.localizedDescription)
                }
            }
            
        }
    }
    
    @objc private func resendCode(){
        FirebaseDataService.instance.verifyPhoneNumber(with: number) {[weak self](result) in
            DispatchQueue.main.async {
                [weak self] in
                guard let this = self else  {return}
                switch result{
                case .success:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timer"), object: self)
                    Toast.showToast(superView: this.view, message:"Code Sent")
                    break
                case .failure(let er):
                    Toast.showToast(superView: this.view, message: er.localizedDescription)
                    break
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension OTPVC:OTPFieldViewDelegate{
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        // some
        
        return true
    }
    
    func enteredOTP(otp: String) {
        // some
        verificationCode = otp
        
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        // some
        if hasEnteredAll == true{
            continueBtn.backgroundColor = .black
            continueBtn.isEnabled = true
            return true
        }else{
            continueBtn.isEnabled = false
            return false
        }
        
    }
    
    
    
}
