//
//  EditProfileScreen.swift
//  Source-App
//
//  Created by Nikunj on 06/05/21.
//

import UIKit

class EditProfileScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonMainView: dateSportView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var lasNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var bioPlaceHolder: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    // MARK: - VARIABLE DECLARE
    var imageData: Data?
    var itemArray: [String] = []
    var intrestArray: [InterestsListData] = []
    var onEdit: (() -> Void)?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.bioTextView.delegate = self
        self.getUserData()
        self.setUpTextFieldChangeEvent()
    }
    
    func setUpTextFieldChangeEvent(){
        self.firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.lasNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !self.checkTextFieldValueNill(textField: self.firstNameTextField) &&  !self.checkTextFieldValueNill(textField: self.lasNameTextField){
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
  
    func getUserData(){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            ProfileService.shared.getUserDetail(userId: Utility.getUserData()?.user_id ?? 0) { [weak self] (statusCode, response) in
                self?.setUserData(userData: response)
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
    
    func setUserData(userData: LoginResponse?){
        if let data = userData{
            Utility.setImage(data.profile_pic ?? "", imageView: self.userImageView)
            self.firstNameTextField.text = data.first_name
            self.lasNameTextField.text = data.last_name
            self.headlineTextField.text = data.headline
            self.bioTextView.text = data.bio
            self.linkTextField.text = data.url
            self.bioPlaceHolder.isHidden = self.bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            
            if let interests = userData?.interest{
                if interests != ""{
                    self.itemArray = interests.components(separatedBy: ",")
                    for i in self.itemArray{
                        let data = InterestsListData(interest_id: nil, name: i)
                        self.intrestArray.append(data)
                    }
                }
            }
            self.enableContinueButton(isEnable: true)
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func onEditIntrests(_ sender: Any) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileIntrestScreen") as! ProfileIntrestScreen
        vc.selectedTagIntrestedArray = self.intrestArray
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.editProfileAPI()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditImage(_ sender: Any) {
        self.photoSelectOption()
    }
    
    func enableContinueButton(isEnable: Bool){
        
//        self.saveButtonMainView.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
//        self.saveButton.isUserInteractionEnabled = isEnable
        
        self.saveButtonMainView.removeGradient(selectedGradientView: self.saveButtonMainView)
        isEnable == true ?  self.saveButtonMainView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.saveButtonMainView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        self.saveButton.isUserInteractionEnabled = isEnable
    }
    
    func checkTextFieldValueNill(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
    
    //MARK:- EDIT PROFILE API
    func editProfileAPI(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            var arr: String = ""
            if !self.intrestArray.allSatisfy({$0.interest_id == nil}){
                arr = self.intrestArray.map { String($0.interest_id ?? 0) }.joined(separator: ",")
            }
            let data = UpdateProfileRequest(first_name: self.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), last_name: self.lasNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), headline: self.headlineTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), url: self.linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), bio: self.bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines),interest_id: arr == "" ? nil : arr)
            ProfileService.shared.editUserProfile(parameters: data.toJSON(), imageData: self.imageData) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                let auth = Utility.getUserData()?.auth
                if let data = response{
                    data.auth = auth
                    Utility.saveUserData(data: data.toJSON())
                    self?.onEdit?()
                    self?.navigationController?.popViewController(animated: true)
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
    
    //MARK:- Photo Selection Alert
    func photoSelectOption(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the actions
        let takePhoto = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryPhoto = UIAlertAction(title: "Choose from Library", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(takePhoto)
        alertController.addAction(galleryPhoto)
        alertController.addAction(cancelAction)
        
        //   Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera(){
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false//false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.openGallery()
        }
    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker,animated: true,completion: nil)
    }
    
}
//MARK: - TEXTVIEW DELEGATE
extension EditProfileScreen: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.bioPlaceHolder.isHidden = textView.text.count > 0
    }
}
//MARK: - ImagePicker Delegate
extension EditProfileScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageData = nil
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.userImageView.image = image
            self.imageData = image.png(isOpaque: false)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - SELECT INTREST DELEGATE
extension EditProfileScreen: SelectedIntrestDelegate{
    func getIntrestData(data: [InterestsListData]) {
        self.intrestArray = data
    }
}
