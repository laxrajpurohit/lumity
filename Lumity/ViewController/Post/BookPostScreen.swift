//
//  BookPostScreen.swift
//  Source-App
//
//  Created by Nikunj on 11/04/21.
//

import UIKit

class BookPostScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var continueButtonBGView: dateSportView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    var superVC: UIViewController?
    var myLibraryObj: MyLibraryListResponse?
    var postWise: PostWise?
    var postObj: PostReponse?
    
    var shareImage: UIImage?
    var fromShare: Bool = false
    var groupId:Int?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.checkAllRequiredValue()
    }

    func initializeDetails(){
        self.setUpTextFieldChangeEvent()
        self.checkAllRequiredValue()
        self.setEditPost()
        if let img = self.shareImage{
            self.thumbnailImageView.image = img
        }
        
    }
    
    func setEditPost(){
        if let data = self.postObj{
            self.titleTextField.text = data.title
            self.authorTextField.text = data.author
            Utility.setImage(data.media ?? "", imageView: self.thumbnailImageView)
            self.checkAllRequiredValue()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setUpTextFieldChangeEvent(){
        self.titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.authorTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.checkAllRequiredValue()
    }
    
    func checkAllRequiredValue() {
        if !self.checkTextFieldValueNill(textField: self.titleTextField) &&  !self.checkTextFieldValueNill(textField: self.authorTextField) && self.thumbnailImageView.image != nil{
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    func enableContinueButton(isEnable: Bool){
        self.continueButtonBGView.removeGradient(selectedGradientView: self.continueButtonBGView)
        isEnable == true ?  self.continueButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.continueButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
//        self.continueButtonBGView.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        self.continueButton.isUserInteractionEnabled = isEnable

    }
    
    func checkTextFieldValueNill(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
    
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSelectImage(_ sender: Any) {
        self.view.endEditing(true)
        self.photoSelectOption()
    }
    @IBAction func onPreviewPhoto(_ sender: UIButton) {
        if let image = thumbnailImageView.image{
            let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
            confirmAlertController.image = image
            confirmAlertController.modalPresentationStyle = .overFullScreen
            self.present(confirmAlertController, animated: true, completion: nil)
        }
       
    }
    @IBAction func onContinue(_ sender: Any) {
        let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PostEnterDetailScreen") as! PostEnterDetailScreen
        vc.postType = .book
        vc.superVC = self
        if let homeVC = self.superVC as? HomeScreen{
            vc.completeAddNewPostDelegate = homeVC
        }else if let intrestPostScreen = self.superVC as? ExploreSelectedIntrestedScreen{
            vc.completeAddNewPostDelegate = intrestPostScreen
        }else if let profileTabScreen = self.superVC as? ProfileTabbarScreen{
            vc.completeAddNewPostDelegate = profileTabScreen
        }else if let playListPostVC = self.superVC as? PlayListDetailScreen{
            vc.completeAddNewPostDelegate = playListPostVC
        }else if let completedVC = self.superVC as? SaveForLaterPostScreen{
            vc.completeAddNewPostDelegate = completedVC
        }else if let groupDetailVC = self.superVC as? GroupDetailScreen{
            vc.completeAddNewPostDelegate = groupDetailVC
        }
        vc.myLibraryObj = self.myLibraryObj
        vc.postWise = self.postWise
        vc.postObj = self.postObj
        vc.fromShare = self.fromShare
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
//
//    func openGallery(){
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
//        self.present(imagePicker,animated: true,completion: nil)
//    }
    
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
            imagePicker.allowsEditing = false
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
//MARK: - ImagePicker Delegate
extension BookPostScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.thumbnailImageView.image = image//            self.selectTakeButton.setTitle("Change", for: .normal)
        }
        self.checkAllRequiredValue()
        picker.dismiss(animated: true, completion: nil)
    }
}

