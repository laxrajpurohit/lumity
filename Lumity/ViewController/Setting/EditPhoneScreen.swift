//
//  EditPhoneScreen.swift
//  Source-App
//
//  Created by iroid on 15/08/21.
//

import UIKit
import GCCountryPicker

class EditPhoneScreen: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailsYourLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var primaryEmailLabel: UILabel!
    @IBOutlet weak var emailDetailLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var primaryLabelTopConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDetail()
    }
    
    func initialDetail(){
//        self.editButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        self.phoneNumberTextField.text = Utility.getUserData()?.phone_no
        self.countryLabel.text = Utility.getUserData()?.country_code ?? "+1"
        
        self.countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", Utility.getCountryPhoneCode(String(Utility.getUserData()?.country_code?.dropFirst() ?? "1"))))
//        self.setupCallingCode()
    }
    
//    private func setupCallingCode() {
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String, let code = GCCountry(countryCode:countryCode)?.callingCode {
//            countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", Utility.getUserData()?.country_code ?? ""))
//        }
//    }
 
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCode(_ sender: Any) {
        let countryPickerViewController = GCCountryPickerViewController(displayMode: .withCallingCodes)
        
        countryPickerViewController.delegate = self
        countryPickerViewController.navigationItem.title = "Countries"
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onEditEmailAddress(_ sender: UIButton) {
        
        if !sender.isSelected{
            sender.isSelected = true
            self.emailsYourLabel.text = "Add New Phone Number"
            self.emailView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
            self.primaryEmailLabel.text = "New Primary Number"
            self.emailDetailLabel.text = "This will be the new number we use to communicate with you"
            self.phoneNumberTextField.text = ""
            self.editButton.setTitle("Save changes", for: .normal)
            self.phoneNumberTextField.isUserInteractionEnabled = true
            self.countryButton.isUserInteractionEnabled = true
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
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            Utility.showAlert(vc: self, message: "Please enter phone number")
            return
        }else if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 8{
            Utility.showAlert(vc: self, message: "Please enter valide phone number")
            return
        }else{
//            if Utility.getUserData()?.phone_no != phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces){
                self.showEmailChangeOption()
//            }else{
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    func showEmailChangeOption() {
        let alert = UIAlertController(title: "Are you sure you want to change your phone number?", message: "This will be the new number used to sign into the app and the number in which we contact you.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.doChangePhoneNumber()
                                      }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- GCCountryPicker Delegate & DataSource
extension EditPhoneScreen: GCCountryPickerDelegate{
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
        self.countryLabel.text = country.callingCode
        countryImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", country.countryCode))
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EditPhoneScreen{
//MARK:- Change Phone number
func doChangePhoneNumber(){
    self.view.endEditing(true)
    if Utility.isInternetAvailable(){
                    Utility.showIndicator()
        let parameter = ChangePhoneNumberRequest(country_code: countryLabel.text, phone_no: phoneNumberTextField.text)
        ProfileService.shared.changePhoneNumber(parameters: parameter.toJSON()) { (statusCode, response) in
                            Utility.hideIndicator()
            let data = Utility.getUserData()
            data?.phone_no = self.phoneNumberTextField.text ?? ""
            data?.country_code = self.countryLabel.text ?? ""
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
