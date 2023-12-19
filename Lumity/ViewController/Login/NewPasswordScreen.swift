//
//  NewPasswordScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit

class NewPasswordScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var forgotEmail = ""
    var phone: String?
    var countryCode: String?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkValidation() -> String?{
         if newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter password"
        }else if !Utility.isValidPassword(Input: newPasswordTextField.text ?? ""){
            return "Please enter valid password"
        }else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter confirm password"
        }else if newPasswordTextField.text != confirmPasswordTextField.text{
            return "The two passwords do not match"
        }
        return nil
    }

    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func onReset(_ sender: Any) {
        if let error = self.checkValidation(){
            Utility.showAlert(vc: self, message: error)
        }else{
            self.resetPasswordAPI()
        }
    }
    
    @IBAction func onHideAndShowPassword(_ sender: UIButton) {
        self.newPasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onConfirmHideAndShowPassword(_ sender: UIButton) {
        self.confirmPasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
}
//MARK: - New Password API
extension NewPasswordScreen{
    func resetPasswordAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  ChangePasswordRequest(email: forgotEmail == "" ? phone:forgotEmail, password: self.newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), password_confirmation: self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), country_code: countryCode)
            LoginService.shared.resetPassword(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                print(response.toJSON())
                let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ResetPasswordSuccessScreen") as! ResetPasswordSuccessScreen
                self?.navigationController?.pushViewController(vc, animated: false)
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
