//
//  ChangePassword.swift
//  Source-App
//
//  Created by iroid on 07/05/21.
//

import UIKit

class ChangePasswordScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var savePassword: UIButton!
    
    @IBOutlet weak var forgotYourPasswordButton: UIButton!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forgotYourPasswordButton.gradientButton("Forgot your password?", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)
        self.enableContinueButton(isEnable: false)
        self.setUpTextFieldChangeEvent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if  !self.checkTextFieldValueNill(textField: self.oldPasswordTextField) && !self.checkTextFieldValueNill(textField: self.newPasswordTextField) && !self.checkTextFieldValueNill(textField: self.retypePasswordTextField) &&
            Utility.isValidPassword(Input: oldPasswordTextField.text ?? "") &&
                Utility.isValidPassword(Input: newPasswordTextField.text ?? "") &&
                self.newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.retypePasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    func setUpTextFieldChangeEvent(){
        self.oldPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.newPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.retypePasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if  !self.checkTextFieldValueNill(textField: self.oldPasswordTextField) && !self.checkTextFieldValueNill(textField: self.newPasswordTextField) && !self.checkTextFieldValueNill(textField: self.retypePasswordTextField) &&
            Utility.isValidPassword(Input: oldPasswordTextField.text ?? "") &&
                Utility.isValidPassword(Input: newPasswordTextField.text ?? "") &&
                self.newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.retypePasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }

    func enableContinueButton(isEnable: Bool){
        self.savePassword.removeGradient(selectedGradientView: self.savePassword)
        isEnable == true ?  self.savePassword.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.savePassword.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
//        self.savePassword.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        self.savePassword.isUserInteractionEnabled = isEnable
        
    }
    
    func checkTextFieldValueNill(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
    
    //MARK: - ACTION
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHideAndShowCurrentPassword(_ sender: UIButton) {
        self.oldPasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onHideAndShowNewPassword(_ sender: UIButton) {
        self.newPasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onHideAndShowConfirmPassword(_ sender: UIButton) {
        self.retypePasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onSavePassword(_ sender: UIButton) {
        self.doChangePassword()
    }
    
    @IBAction func onForgotPassword(_ sender: UIButton) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ResetPasswordScreen") as! ResetPasswordScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
}
extension ChangePasswordScreen{
    //MARK: - Change Password
    func doChangePassword(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = ChangePasswordSettingRequest(current_password: oldPasswordTextField.text?.trimmingCharacters(in: .whitespaces), password: newPasswordTextField.text?.trimmingCharacters(in: .whitespaces), password_confirmation: retypePasswordTextField.text?.trimmingCharacters(in: .whitespaces))
            ProfileService.shared.changePassword(parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                
                self.navigationController?.popViewController(animated: true)
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
