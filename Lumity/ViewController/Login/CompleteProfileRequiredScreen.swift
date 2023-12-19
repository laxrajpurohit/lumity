//
//  CompleteProfileRequiredScreen.swift
//  Source-App
//
//  Created by Nikunj on 17/04/21.
//

import UIKit
import GCCountryPicker

class CompleteProfileRequiredScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var passwordStrengtMainView: UIView!
    @IBOutlet weak var collectionMainView: dateSportView!
    @IBOutlet weak var passwordStrengthImageView: UIImageView!
    @IBOutlet weak var passwordStrengthCollectionVIew: UICollectionView!
    @IBOutlet weak var passwordProgress: UIProgressView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var continueButtonView: dateSportView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    //  @IBOutlet weak var weakPasswordTitleLabel: UILabel!
    
    @IBOutlet weak var passwordStrengthViewBottom: NSLayoutConstraint!
    @IBOutlet weak var weakPasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var weakPasswordBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weakPasswordViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var phoneMainView: dateSportView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emaiLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    
    var imageData: Data?
    var itemArray: [PasswordStrengthRequest]  = []
    var isPhone: Bool = false
    var inviteCode = ""
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideAllPasswordView()
        self.enableContinueButton(isEnable: false)
        self.setUpTextFieldChangeEvent()
//        self.passwordProgress.layer.cornerRadius = 3
        self.passwordProgress.transform = self.passwordProgress.transform.scaledBy(x: 1, y: 9)
        self.passwordProgress.clipsToBounds = true
        self.passwordStrengthCollectionVIew.register(UINib(nibName: "PasswordStrengthCell", bundle: nil), forCellWithReuseIdentifier: "PasswordStrengthCell")
        self.passwordStrengthCollectionVIew.delegate = self
        self.passwordStrengthCollectionVIew.dataSource = self
        self.setPasswordArray()
        self.displayPhone()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isPhone{
            if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lastNameTextField) &&  !self.checkTextFieldValueNill(textField: self.phoneTextField) && phoneTextField.text?.count ?? 0 > 8  && !self.checkTextFieldValueNill(textField: self.passwordTextField) && !self.checkTextFieldValueNill(textField: self.confirmPasswordTextField) && self.passwordProgress.progress == 1.0 && self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                self.enableContinueButton(isEnable: true)
            }else{
                self.enableContinueButton(isEnable: false)
            }
            
        }else{
            if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lastNameTextField) &&  !self.checkTextFieldValueNill(textField: self.emailTextField) && emailTextField.text.isEmailValid() && !self.checkTextFieldValueNill(textField: self.passwordTextField) && !self.checkTextFieldValueNill(textField: self.confirmPasswordTextField) && self.passwordProgress.progress == 1.0 && self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                self.enableContinueButton(isEnable: true)
            }else{
                self.enableContinueButton(isEnable: false)
            }
            
        }
    }
    
    func displayPhone(){
        self.codeImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", "US"))
        self.emaiLabel.isHidden = self.isPhone
        self.phoneLabel.isHidden = !isPhone
        self.phoneMainView.isHidden = !isPhone
    }
    
    func setPasswordArray(){
        self.itemArray.append(PasswordStrengthRequest(complete: false, text: "Min. 8 characters"))
        self.itemArray.append(PasswordStrengthRequest(complete: false, text: "At least one Uppercase"))
        self.itemArray.append(PasswordStrengthRequest(complete: false, text: "At least one lowercase"))
//        self.itemArray.append(PasswordStrengthRequest(complete: false, text: "One special character (!@$)"))
        self.itemArray.append(PasswordStrengthRequest(complete: false, text: "At least one number"))
    }
    
    func setUpTextFieldChangeEvent(){
        self.firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if isPhone{
            if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lastNameTextField) &&  !self.checkTextFieldValueNill(textField: self.phoneTextField) && phoneTextField.text?.count ?? 0 > 8  && !self.checkTextFieldValueNill(textField: self.passwordTextField) && !self.checkTextFieldValueNill(textField: self.confirmPasswordTextField) && self.passwordProgress.progress == 1.0 && self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                self.enableContinueButton(isEnable: true)
            }else{
                self.enableContinueButton(isEnable: false)
            }
            if textField == self.passwordTextField{
                self.displayWeakPasswordView()
            }
        }else{
            if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lastNameTextField) &&  !self.checkTextFieldValueNill(textField: self.emailTextField) && emailTextField.text.isEmailValid() && !self.checkTextFieldValueNill(textField: self.passwordTextField) && !self.checkTextFieldValueNill(textField: self.confirmPasswordTextField) && self.passwordProgress.progress == 1.0 && self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                self.enableContinueButton(isEnable: true)
            }else{
                self.enableContinueButton(isEnable: false)
            }
            if textField == self.passwordTextField{
                self.displayWeakPasswordView()
            }
        }
       
        
        self.passwordProgress.progressTintColor = self.checkPasswordValiadtionProgress() == 1.0 ? Utility.getUIcolorfromHex(hex: "00B107") : Utility.getUIcolorfromHex(hex: "FF5555")
        
       
        
        self.passwordProgress.setProgress(self.checkPasswordValiadtionProgress(), animated: true)
        self.setCollectionView()
        self.passwordStrengthImageView.image = self.passwordProgress.progress == 1.0 ? UIImage(named: "ic_strong_password") : UIImage(named: "ic_weak_password")
        //self.weakPasswordTitleLabel.textColor = self.passwordProgress.progress == 1.0 ? #colorLiteral(red: 0, green: 0.8509803922, blue: 0.03137254902, alpha: 1) : #colorLiteral(red: 1, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
//        self.collectionMainView.isHidden =  self.passwordProgress.progress == 1.0 ? true : false
        //self.weakPasswordTitleLabel.text = self.passwordProgress.progress == 1.0 ? "Strong Password" : "Weak Password"
        
    }
    
    //MARK:- MANAGE COLLECTIONVIEW
    func setCollectionView(){
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 8{
            self.itemArray[0].complete = true
        }else{
            self.itemArray[0].complete = false
        }
        if self.checkAtLeastOneUpparCase(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            self.itemArray[1].complete = true
        }else{
            self.itemArray[1].complete = false
        }
        if self.checkAtLeatOneLowerCase(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            self.itemArray[2].complete = true
        }else{
            self.itemArray[2].complete = false
        }
//        if self.checkAtLeastSpecialCharacter(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
//            self.itemArray[3].complete = true
//        }else{
//            self.itemArray[3].complete = false
//        }
        if self.doStringContainsNumber(_string: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            self.itemArray[3].complete = true
        }else{
            self.itemArray[3].complete = false
        }
        self.passwordStrengthCollectionVIew.reloadData()
    }
    
    //MARK:- PASSWORD PROGRESS
    func checkPasswordValiadtionProgress() -> Float{
        var value: Int = 0
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 2{
            value += 1//0.05
        }
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 4{
            value += 1//0.05
        }
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 6{
            value += 1//0.05
        }
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 7{
            value += 1//0.05
        }
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) >= 8{
            value += 1//0.04
        }
        if self.checkAtLeastOneUpparCase(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            value += 1//0.33//0.19
        }
        if self.checkAtLeatOneLowerCase(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            value += 2//0.33//0.19
        }
//        if self.checkAtLeastSpecialCharacter(str: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
//            value += 0.19
//        }
        if self.doStringContainsNumber(_string: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            value += 2//0.20
        }
        return Float(Double(value)/10)
    }
    
    //MARK:- VALIDATIONS
    func doStringContainsNumber( _string : String) -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        return containsNumber
    }
    
    func checkAtLeastOneUpparCase(str: String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: str)
        return capitalresult
    }
    
    func checkAtLeatOneLowerCase(str: String) -> Bool{
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: str)
        return capitalresult
    }
    
    func checkAtLeastSpecialCharacter(str: String) -> Bool{
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let capitalresult = texttest.evaluate(with: str)
        return capitalresult
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
    
    //MARK: - ACTIONS
    @IBAction func onCode(_ sender: Any) {
        let countryPickerViewController = GCCountryPickerViewController(displayMode: .withCallingCodes)
        
        countryPickerViewController.delegate = self
        countryPickerViewController.navigationItem.title = "Countries"
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onHideAndShowPassword(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onHideAndShowConfirmPassword(_ sender: UIButton) {
        self.confirmPasswordTextField.isSecureTextEntry = sender.isSelected == true ? true:false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onPasswordInfo(_ sender: Any) {
        self.collectionMainView.isHidden = !self.collectionMainView.isHidden
        self.passwordStrengthViewHeight.constant = self.collectionMainView.isHidden ? 0 : 140
        self.weakPasswordBottomConstraint.constant = self.collectionMainView.isHidden ? 0 : 15
    }

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
    
    func checkEmailExistOrNot(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = EmailExistRequest(country_code: self.isPhone ? self.codeLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil,email: self.isPhone ? self.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) : self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            LoginService.shared.checkEmailIdExistsOrNot(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let strongSelf = self else {
                    return
                }
                if response.success ?? false{
                    let data = SignUpRequest(first_name: self?.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), headline: nil, url: nil, last_name: self?.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), bio: nil, email: strongSelf.isPhone ? nil : self?.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),country_code: strongSelf.isPhone ? self?.codeLabel.text : nil,phone_no: strongSelf.isPhone ? self?.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) : nil, password: self?.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), password_confirmation: self?.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), provider_id: nil, provider_type: nil, invite_code: self?.inviteCode ?? "")
                    let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileScreen
                    vc.obj = data
                    vc.inviteCode = self?.inviteCode ?? ""
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
        }else if self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter password"
        }else if !Utility.isPasswordValid(self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            return "Min. 8 characters, 1 uppercase, 1 lowercase, 1 #, and 1 special character"
        }else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter confirm password"
        }else if passwordTextField.text != confirmPasswordTextField.text{
            return "Password and confirm password don’t match"
        }
        return nil
    }
    
    func hideAllPasswordView(){
//        self.weakPasswordTopConstraint.constant = 0
//        self.weakPasswordBottomConstraint.constant = 0
        self.passwordStrengthViewHeight.constant = 0
//        self.passwordStrengthViewBottom.constant = 0
//        self.weakPasswordViewHeight.constant = 28
        self.weakPasswordTopConstraint.constant = 10
       // self.passwordStrengtMainView.isHidden = false
    }
    
    func displayWeakPasswordView(){
        self.weakPasswordTopConstraint.constant = 15
//        self.weakPasswordViewHeight.constant = 28
       // self.passwordStrengtMainView.isHidden = false
    }
}
//MARK: - COLLECIONVIEW DELEGATE & DATASOURCE
extension CompleteProfileRequiredScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.passwordStrengthCollectionVIew.dequeueReusableCell(withReuseIdentifier: "PasswordStrengthCell", for: indexPath) as! PasswordStrengthCell
        cell.item = self.itemArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionMainView.frame.width, height: 30)
    }
    
}
//MARK: - GCCountryPicker Delegate & DataSource
extension CompleteProfileRequiredScreen: GCCountryPickerDelegate{
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
         self.dismiss(animated: true, completion: nil)
     }
     
    func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
        self.codeLabel.text = country.callingCode
        self.codeImageView.image = UIImage(named: String(format: "CountryPicker.bundle/%@", country.countryCode))
        self.dismiss(animated: true, completion: nil)
    }
}
