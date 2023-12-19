//
//  LoginPhoneScreen.swift
//  Source-App
//
//  Created by Nikunj on 14/08/21.
//

import UIKit
import GCCountryPicker

class LoginPhoneScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeLbel: UILabel!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", "US"))
        self.setResetLabel()
        // Do any additional setup after loading the view.
    }
    
    func setResetLabel(){
        let string = "Forgot password? Reset"
        let attributedString = NSMutableAttributedString(string: string)
        let loginRange = (string as NSString).range(of: "Reset")
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 19)!,NSAttributedString.Key.foregroundColor : UIColor.black], range: loginRange)
        self.resetLabel.attributedText = attributedString
        self.resetLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resetScreen)))
        self.resetLabel.isUserInteractionEnabled = true
    }
    
    @objc func resetScreen(){
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ResetPasswordScreen") as! ResetPasswordScreen
        vc.isFromPhoneNumber = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkValidation() -> String?{
        if self.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter phone"
//        }else if !emailTextField.text.isEmailValid(){
//            Utility.showAlert(vc: self, message: "Please enter valid email address")
        }else if self.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 8{
            return "Please enter valid phone number"
        }else if self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count  == 0{
            return "Please enter password"
        }else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count < 8{
            return "Incorrect password. Please try again."
        }
        return nil
    }
   
    //MARK: - ACTIONS
    @IBAction func onLogin(_ sender: Any) {
        if let error = self.checkValidation(){
            Utility.showAlert(vc: self, message: error)
        }else{
            self.loginAPI()
        }
    }
    
    @IBAction func onHideAndShowPassword(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onPhoneCode(_ sender: Any) {
        let countryPickerViewController = GCCountryPickerViewController(displayMode: .withCallingCodes)
        
        countryPickerViewController.delegate = self
        countryPickerViewController.navigationItem.title = "Countries"
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - GCCountryPicker Delegate & DataSource
extension LoginPhoneScreen: GCCountryPickerDelegate{
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
         self.dismiss(animated: true, completion: nil)
     }
     
     func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
         self.codeLbel.text = country.callingCode
         countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", country.countryCode))
         self.dismiss(animated: true, completion: nil)
     }
}
extension LoginPhoneScreen{
    //MARK:- Login API
    func loginAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  LoginRequest(country_code: self.codeLbel.text, email: self.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            LoginService.shared.login(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response{
                    print(res.toJSON())
                    Utility.saveUserData(data: res.toJSON())
                    appDelegate.connectSocket()
                    if let res = response{
                        if (res.is_login_first_time ?? false){
                            let control = STORYBOARD.login.instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileScreen
                            self?.navigationController?.pushViewController(control, animated: true)
                        }else if res.interest_type == 0{
                            let control = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
                            self?.navigationController?.pushViewController(control, animated: true)
                        }else{
                            appDelegate.registerForPush()
                            Utility.setTabRoot()
                        }
                    }
//                    self?.callRegisterForPushAPI()
//                    Utility.setTabRoot()
                }
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
}
