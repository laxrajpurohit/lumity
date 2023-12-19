//
//  EnterInviteCodeScreen.swift
//  Source-App
//
//  Created by Nikunj on 14/08/21.
//

import UIKit
import DropDown
import GCCountryPicker

class EnterInviteCodeScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var joinWaitListLabel: UILabel!
    @IBOutlet weak var inviteCodeTexField: UITextField!
    
    @IBOutlet weak var countryImageView: UIImageView!
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var joinTypeLabel: UILabel!
    
    @IBOutlet weak var phoneView: dateSportView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailSuperView: dateSportView!
    
    @IBOutlet weak var emailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneViewHeight: NSLayoutConstraint!

    @IBOutlet weak var phoneViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        intialDetail()
    }
    
    func intialDetail(){
        self.countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", "US"))
        self.displayEmailView(isHide: true)
    }
    
    
    func displayPhoneView(isHide: Bool){
        self.phoneView.isHidden = isHide
        self.phoneViewHeight.constant = isHide ? 0 : 45
        self.phoneViewTop.constant = isHide ? 0 : 15
    }
    
    func displayEmailView(isHide: Bool){
        self.emailView.isHidden = isHide
        self.emailViewHeight.constant = isHide ? 0 : 60
    }
    
    //MARK: - ACTIONS
    @IBAction func onDropDown(_ sender: Any) {
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = self.phoneView.isHidden ? self.emailSuperView : self.phoneView // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Phone", "Email"]
        
        dropDown.show()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.joinTypeLabel.text = item
            if index == 0{
                self?.displayPhoneView(isHide: false)
                self?.displayEmailView(isHide: true)
            }else{
                self?.displayPhoneView(isHide: true)
                self?.displayEmailView(isHide: false)
            }
            dropDown.hide()
          print("Selected item: \(item) at index: \(index)")
        }
        

        // Will set a custom width instead of the anchor view width
        dropDown.width = screenWidth - 40
    }
    
    @IBAction func onPhoneCode(_ sender: Any) {
        let countryPickerViewController = GCCountryPickerViewController(displayMode: .withCallingCodes)
        
        countryPickerViewController.delegate = self
        countryPickerViewController.navigationItem.title = "Countries"
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onJoin(_ sender: Any) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "JoinWaitListScreen") as! JoinWaitListScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        if self.phoneView.isHidden{
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                Utility.showAlert(vc: self, message: "Please enter email")
                return
            }else if !emailTextField.text.isEmailValid(){
                Utility.showAlert(vc: self, message: "Please enter valid email address")
                return
            }
        }else{
            if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                Utility.showAlert(vc: self, message: "Please enter phone number")
                return
            }else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 8{
                Utility.showAlert(vc: self, message: "Please enter valid phone number")
                return
            }
        }
        
        if inviteCodeTexField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            Utility.showAlert(vc: self, message: "Please enter invite code")
            return
        }
        
        inviteCodeAPI()
    }
}
//MARK: - GCCountryPicker Delegate & DataSource
extension EnterInviteCodeScreen: GCCountryPickerDelegate{
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
         self.dismiss(animated: true, completion: nil)
     }
     
     func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
         self.codeLabel.text = country.callingCode
         countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", country.countryCode))
         self.dismiss(animated: true, completion: nil)
     }
}

//MARK: - API Calling
extension EnterInviteCodeScreen{
    
    func inviteCodeAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = VerifyInviteCodeRequest(country_code:self.phoneView.isHidden == true ? nil:codeLabel.text, invite_code: inviteCodeTexField.text, emailphone:self.phoneView.isHidden == true ? emailTextField.text:phoneNumberTextField.text)
            LoginService.shared.verifyInviteCodeRequest(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpScreen
                vc.inviteCode = self?.inviteCodeTexField.text ?? ""
                     self?.navigationController?.pushViewController(vc, animated: true)
//                self?.showSuccessAlert()
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


