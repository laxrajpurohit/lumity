//
//  CompleteProfileRequiredSocialScreen.swift
//  Source-App
//
//  Created by iroid on 01/05/21.
//

import UIKit

class CompleteProfileRequiredSocialScreen: UIViewController {

  //MARK: - OUTLET
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButtonView: dateSportView!
    @IBOutlet weak var continueButton: UIButton!
    
    var signUpObj : SignUpRequest?
    var isFromSocial = false
    var loginResponse: LoginResponse?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextFieldChangeEvent()
        self.enableContinueButton(isEnable: false)
        setData()
    }
    
    func setData(){
        firstNameTextField.text = loginResponse?.first_name
        lastNameTextField.text = loginResponse?.last_name
        emailTextField.text = loginResponse?.email
        
        if firstNameTextField.text != "", lastNameTextField.text != "", emailTextField.text != ""{
            self.enableContinueButton(isEnable: true)
        }
    }
    
    func setUpTextFieldChangeEvent(){
        self.firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
     
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lastNameTextField) &&  !self.checkTextFieldValueNill(textField: self.emailTextField) && emailTextField.text.isEmailValid() {
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }

    func enableContinueButton(isEnable: Bool){
        self.continueButtonView.removeGradient(selectedGradientView: self.continueButtonView)
        isEnable == true ?  self.continueButtonView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.continueButtonView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
//        self.continueButtonView.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        self.continueButton.isUserInteractionEnabled = isEnable
    }
    
    func checkTextFieldValueNill(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }

    func checkEmailExistOrNot(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = EmailExistRequest(country_code: nil,email: emailTextField.text ?? "")
            LoginService.shared.checkEmailIdExistsOrNot(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if response.success ?? false{
                    let data = SignUpRequest(first_name: self?.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), headline: nil, url: nil, last_name: self?.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), bio: nil, email: self?.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),country_code: nil,phone_no: nil, password: nil, password_confirmation: nil,provider_id:self?.signUpObj?.provider_id, provider_type: self?.signUpObj?.provider_type, invite_code: "")
                    let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileScreen
                    vc.obj = data
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    Utility.showAlert(vc: self!, message: response.message ?? "")
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
    func goFurther(){
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityGuidelinesScreen") as! CommunityGuidelinesScreen
       self.navigationController?.pushViewController(control, animated: true)
    }
        
    func checkValidation() -> String?{

        if self.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter first name"
        }else if self.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter last name"
        }
        else if self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter email"
        }else if !emailTextField.text.isEmailValid(){
            Utility.showAlert(vc: self, message: "Please enter valid email address")
        }
        return nil
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinue(_ sender: Any) {
//        if let error = self.checkValidation(){
//            Utility.showAlert(vc: self, message: error)
//        }else{
            checkEmailExistOrNot()
//        }
    }
}
