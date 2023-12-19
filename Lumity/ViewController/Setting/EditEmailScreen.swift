//
//  EditEmailScreen.swift
//  Source-App
//
//  Created by iroid on 07/05/21.
//

import UIKit

class EditEmailScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailsYourLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var primaryEmailLabel: UILabel!
    @IBOutlet weak var emailDetailLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editEmailBGView: UIView!
    
    @IBOutlet weak var primaryLabelTopConstant: NSLayoutConstraint!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDetail()
    }
    
    func initialDetail(){
        
//        self.editEmailBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        emailTextField.text = Utility.getUserData()?.email
    }
    
    
    func showEmailChangeOption() {
        let alert = UIAlertController(title: "Are you sure you want to change your email address?", message: "This will be the new email used to sign into the app and the email in which we contact you.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.doChangeEmail()
                                      }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditEmailAddress(_ sender: UIButton) {
        
        if !sender.isSelected{
            sender.isSelected = true
            self.emailsYourLabel.text = "Add New Email Address"
            self.emailView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
            self.primaryEmailLabel.text = "New Primary Email"
            self.emailDetailLabel.text = "This will be the new email we use to communicate with you"
            self.emailTextField.text = ""
            self.editButton.setTitle("Save changes", for: .normal)
            self.emailTextField.isUserInteractionEnabled = true
            self.primaryLabelTopConstant.constant = 8
            return
        }else{
            //            sender.isSelected = false
            //            self.emailsYourLabel.text = "Emails you’ve added"
            //            self.emailView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            //            self.primaryEmailLabel.text = "Primary email"
            //            self.emailDetailLabel.text = "Your primary email is the one we use to communicate with you."
            //            self.editButton.setTitle("Edit email address", for: .normal)
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            Utility.showAlert(vc: self, message: "Please enter email")
            return
        }else if !emailTextField.text.isEmailValid(){
            Utility.showAlert(vc: self, message: "Please enter valid email address")
            return
        }else{
            if Utility.getUserData()?.email != emailTextField.text?.trimmingCharacters(in: .whitespaces){
                self.showEmailChangeOption()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
extension EditEmailScreen{
    //MARK: - Change Email id
    func doChangeEmail(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = ChangeEmailRequest(email: emailTextField.text)
            ProfileService.shared.changeEmail(parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                let data = Utility.getUserData()
                data?.email = self.emailTextField.text ?? ""
                Utility.saveUserData(data: (data?.toJSON())!)
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
