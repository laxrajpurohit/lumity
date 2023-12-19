//
//  ResetPasswordScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit
import GCCountryPicker

class ResetPasswordScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countryNumberLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var phoneView: UIView!
    
    var isFromPhoneNumber = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialDetail()
    }
    
    func intialDetail(){
        self.flagImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", "US"))
        self.setupCallingCode()
        
        if isFromPhoneNumber{
            emailLabel.text = "Phone Number"
        }else{
            self.phoneView.isHidden = true
        }
    }
    
    private func setupCallingCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String, let code = GCCountry(countryCode:countryCode)?.callingCode {
            countryNumberLabel.text = code
            flagImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", countryCode))
        }
    }
    
    func checkValidation() -> String?{
        if isFromPhoneNumber{
            if self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
                return "Please enter phone number"
            }else if self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 8 {
                return "Please enter valid phone number"
            }
        }else{
            if self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
                return "Please enter email"
            }else if !emailTextField.text.isEmailValid(){
                Utility.showAlert(vc: self, message: "Please enter valid email address")
            }
        }
        
        return nil
    }
    
    func goFurtherScreen(){
        if isFromPhoneNumber{
            let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "OTPScreen") as! OTPScreen
            vc.mobileNumber = self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            vc.countryCode = countryNumberLabel.text ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "EnterCodeScreen") as! EnterCodeScreen
            vc.forgotEmail = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func onNext(_ sender: Any) {
        if let error = self.checkValidation(){
            Utility.showAlert(vc: self, message: error)
        }else{
//            if isFromPhoneNumber{
//                let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "OTPScreen") as! OTPScreen
//                vc.mobileNumber = self.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//                vc.countryCode = countryNumberLabel.text ?? ""
//                self.navigationController?.pushViewController(vc, animated: false)
//            }else{
//
//            }
            self.resetPasswordAPI()
        }
    }
    
    @IBAction func onCode(_ sender: Any) {
        let countryPickerViewController = GCCountryPickerViewController(displayMode: .withCallingCodes)
        
        countryPickerViewController.delegate = self
        countryPickerViewController.navigationItem.title = "Countries"
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - Reset Password  API
extension ResetPasswordScreen{
    func resetPasswordAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  ForgotPasswordEmailRequest(email: self.emailTextField.text == "" ? phoneNumberTextField.text:self.emailTextField.text,country_code:self.emailTextField.text == "" ? countryNumberLabel.text:nil)
            LoginService.shared.resetPasswordSendEmail(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.goFurtherScreen()
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
//MARK: - GCCountryPicker Delegate & DataSource
extension ResetPasswordScreen: GCCountryPickerDelegate{
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
         self.dismiss(animated: true, completion: nil)
     }
     
     func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
         self.countryNumberLabel.text = country.callingCode
         flagImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", country.countryCode))
         self.dismiss(animated: true, completion: nil)
     }
}
