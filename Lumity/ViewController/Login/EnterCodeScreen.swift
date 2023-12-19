//
//  EnterCodeScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit

class EnterCodeScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var confirmationCodeTextField: UITextField!
    var forgotEmail = ""
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkValidation() -> String?{
         if confirmationCodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter code"
        }
        return nil
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: false)
   }
   
   @IBAction func onEnter(_ sender: Any) {
       if let error = self.checkValidation(){
           Utility.showAlert(vc: self, message: error)
       }else{
           self.resetPasswordAPI()
       }
   }
}
//MARK: - API
extension EnterCodeScreen{
    //MARK:- Reset Password  API
    func resetPasswordAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  OtpVerifyRequest(email: forgotEmail, otp: self.confirmationCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            LoginService.shared.verifyEmail(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
//                if let res = response{
                    print(response.toJSON())
                let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "NewPasswordScreen") as! NewPasswordScreen
                vc.forgotEmail = self?.forgotEmail ?? ""
                self?.navigationController?.pushViewController(vc, animated: false)
//                }
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
