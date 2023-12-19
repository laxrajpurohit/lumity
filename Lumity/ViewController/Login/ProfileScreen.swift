//
//  ProfileScreen.swift
//  Source-App
//
//  Created by Nikunj on 26/03/21.
//

import UIKit

class ProfileScreen: UIViewController {
 
    //MARK: - OUTLET
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var continueButtonView: dateSportView!
    @IBOutlet weak var continueButton: UIButton!
    
    var imageData: Data?
    var obj: SignUpRequest?
    var inviteCode = ""
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bioTextView.placeholder = "Share a bit about yourself. What do you enjoy? What moves you?"
        self.enableContinueButton(isEnable: true)
        // Do any additional setup after loading the view.
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
    
    func registerAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = SignUpRequest(first_name: self.obj?.first_name, headline: self.headlineTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), url: self.urlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), last_name: self.obj?.last_name, bio: self.bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), email: self.obj?.email,country_code: self.obj?.country_code,phone_no: self.obj?.phone_no, password: self.obj?.password, password_confirmation: self.obj?.password_confirmation,provider_id: self.obj?.provider_id, provider_type: self.obj?.provider_type, invite_code: inviteCode)
            print(data.toJSON())
            LoginService.shared.registerUser(parameters: data.toJSON(), imageData: self.imageData) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let data = response{
                    Utility.saveUserData(data: data.toJSON())
                    self?.callRegisterForPushAPIAndSocket()
                    self?.goFurther()
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
    
    func callRegisterForPushAPIAndSocket(){
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.connectSocket()
        appDelegate?.registerForPush()
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinue(_ sender: Any) {
        self.registerAPI()
    }
    
    @IBAction func onSkip(_ sender: Any) {
        self.registerAPI()
    }
    func goFurther(){
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityGuidelinesScreen") as! CommunityGuidelinesScreen
       self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onProfile(_ sender: UIButton) {
        self.photoSelectOption()
    }
}
//MARK: - ImagePicker Delegate
extension ProfileScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageData = nil
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.profileImageView.image = image
            self.imageData = image.png(isOpaque: false)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    func png(isOpaque: Bool = true) -> Data? { flattened(isOpaque: isOpaque).jpegData(compressionQuality: 0.2) }
    func flattened(isOpaque: Bool = true) -> UIImage {
        if imageOrientation == .up { return self }
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in draw(at: .zero) }
    }
}
