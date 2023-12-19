//
//  OTPScreen.swift
//  Source-App
//
//  Created by Nikunj on 14/08/21.
//

import UIKit
import FirebaseAuth

class OTPScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var otpTextField5: UITextField!
    @IBOutlet weak var otpTextField6: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var resendCodeButton: UIButton!
    
    var mobileNumber: String?
    var countryCode: String?
    var timer = Timer()
    var secondsRemaining = 60
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDetail()
        self.timerStart()
    }
    
    func initialDetail(){
        otpTextField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func otpSend(){
        
        let mobileNumberr = "\(countryCode ?? "")" + " " + "\(mobileNumber ?? "")"
        if Utility.isInternetAvailable(){
            if let mobileNo = self.mobileNumber{
                PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumberr, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        //                        print(error.localizedDescription)
                        //                        self.setResendOTPText()
                        if error.localizedDescription == "TOO_SHORT"{
                            Utility.showAlert(vc: self, message: "Invalid Mobile Number")
                        }else{
                            Utility.showAlert(vc: self, message: error.localizedDescription)
                        }
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                }
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
        
        //        self.otpTimerLabel.text = "Having trouble? Request a new OTP in 00:30"
    }
    
    func timerStart(){
        self.resendCodeButton.isHidden = true
        self.timerLabel.isHidden = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                self.setOTPSecondText(second: self.secondsRemaining)
                self.secondsRemaining -= 1
            } else {
                self.timerLabel.isHidden = true
                self.timer.invalidate()
                self.setResendOTPText()
            }
        }
    }
    
    
    func setResendOTPText(){
        self.secondsRemaining = 60
        self.resendCodeButton.isHidden = false
    }
    
    func setOTPSecondText(second: Int){
        var seconds: String = "\(second)"
        if (1...9).contains(self.secondsRemaining){
            seconds = "0"+seconds
        }
        let string = "Having trouble? Request a new OTP in 00:\(seconds)"
        self.timerLabel.text = string
        
    }
    
    func goFurther(){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "NewPasswordScreen") as! NewPasswordScreen
        control.phone = self.mobileNumber
        control.countryCode = self.countryCode
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    //MARK:- Reset Password  API
    func resetPasswordAPI(){
        self.view.endEditing(true)
      
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  ForgotPasswordEmailRequest(email: self.mobileNumber,country_code:countryCode)
            LoginService.shared.resetPasswordSendEmail(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.timerStart()
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:- Reset Password  API
    func userOtpVerifyAPI(){
        self.view.endEditing(true)
        let verificationCode = "\(self.otpTextField1.text!)\(self.otpTextField2.text!)\(self.otpTextField3.text!)\(self.otpTextField4.text!)\(self.otpTextField5.text!)\(self.otpTextField6.text!)"
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  phoneOTPVerifyRequest(email: self.mobileNumber,country_code:countryCode, otp: verificationCode)
            LoginService.shared.verifyPhoneNumber(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.goFurther()
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResend(_ sender: UIButton) {
//        self.otpSend()
        self.resetPasswordAPI()
        
    }
    @IBAction func onNext(_ sender: UIButton) {
        self.userOtpVerifyAPI()
    }
}

//MARK: - Check OTP
extension OTPScreen{
   
    func checkOTP(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let verificationCode = "\(self.otpTextField1.text!)\(self.otpTextField2.text!)\(self.otpTextField3.text!)\(self.otpTextField4.text!)\(self.otpTextField5.text!)\(self.otpTextField6.text!)"
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID ?? "",
                verificationCode: verificationCode)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { (authResult, error) in
                
                if let error = error {
                    let authError = error as NSError
                    if ( authError.code == AuthErrorCode.secondFactorRequired.rawValue){
                        
                        // The user is a multi-factor user. Second factor challenge is required.
                        let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                        var displayNameString = ""
                        for tmpFactorInfo in (resolver.hints) {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                        }
                        
                    } else {
                        Utility.hideIndicator()
                        Utility.showAlert(vc: self, message: error.localizedDescription)
                        return
                    }
                    Utility.hideIndicator()
                    Utility.showAlert(vc: self, message: error.localizedDescription)
                    return
                }else{
                    
                    let currentUser = FirebaseAuth.Auth.auth().currentUser
                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        if let error = error {
                            Utility.hideIndicator()
                            Utility.showAlert(vc: self, message: error.localizedDescription)
                            return
                        }
                        print("Success")
                        //                        print("idToken =========>\(idToken)")
                        //                        self.loginAPI(idToken: idToken ?? "", phoneNumber: self.mobileNumber ?? "")
                        Utility.hideIndicator()
                        self.goFurther()
                    }
                }
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
//MARK: - TEXTFIELDS  DELEGATES
extension OTPScreen: UITextFieldDelegate{
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case self.otpTextField1:
                self.otpTextField2.becomeFirstResponder()
            case self.otpTextField2:
                self.otpTextField3.becomeFirstResponder()
            case self.otpTextField3:
                self.otpTextField4.becomeFirstResponder()
            case self.otpTextField4:
//                self.otpTextField5.becomeFirstResponder()
//            case self.otpTextField5:
//                self.otpTextField6.becomeFirstResponder()
//            case self.otpTextField6:
//                self.setLoginBtn()
                return
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case self.otpTextField1:
                self.otpTextField1.becomeFirstResponder()
            case self.otpTextField2:
                self.otpTextField1.becomeFirstResponder()
            case self.otpTextField3:
                self.otpTextField2.becomeFirstResponder()
            case self.otpTextField4:
                self.otpTextField3.becomeFirstResponder()
//            case self.otpTextField5:
//                self.otpTextField4.becomeFirstResponder()
//            case self.otpTextField6:
//                self.otpTextField5.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
   
}
