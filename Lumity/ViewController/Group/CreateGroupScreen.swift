//
//  CreateGroupScreen.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class CreateGroupScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var groupMemberCollectionView: UICollectionView!
    @IBOutlet weak var groupProfileImage: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupBioTextView: UITextView!
    @IBOutlet weak var groupColletionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var publicPrivateSwich: UISwitch!
    @IBOutlet weak var addMemberView: UIView!
    
    // MARK: - VARIABLE DECLARE
    var imageData: Data?
    var selectedUserArray: [UserInterestList] = []
    var isPublicPrivate = 1
    var onCreateGtoupeClick : (() -> Void)?

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.groupMemberCollectionView.delegate = self
        self.groupMemberCollectionView.dataSource = self
        self.groupMemberCollectionView.register(UINib(nibName: "SelectMemberCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SelectMemberCell")
        
        let layout = UserProfileTagsFlowLayout()
        layout.scrollDirection = .vertical
        self.groupMemberCollectionView.collectionViewLayout = layout
        
       
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddMore(_ sender: Any) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "InviteGroupMemberScreen") as! InviteGroupMemberScreen
        vc.selectedUserArray = self.selectedUserArray
        vc.onInviteClick = { [weak self ] inviteUsers in
            self?.addMemberView.isHidden = inviteUsers.count == 0 ? true:false
            self?.selectedUserArray = inviteUsers
            self?.groupMemberCollectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onAddGroupImage(_ sender: Any) {
        self.photoSelectOption()
    }
    
    
    @IBAction func onCreateGroup(_ sender: UIButton) {
        if self.groupNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            Utility.showAlert(vc: self, message: "Please enter group name")
            return
        }
        self.createGroupAPI()
    }
    
    
    @IBAction func onPublicPrivateSwich(_ sender: UISwitch) {
        self.isPublicPrivate = sender.isOn ? 0:1
    }
    
    //MARK: - Photo Selection Alert
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
//MARK: COLLECTIONVIEW DELEGATE & DATASOURCE
extension CreateGroupScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUserArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.groupMemberCollectionView.dequeueReusableCell(withReuseIdentifier: "SelectMemberCell", for: indexPath) as! SelectMemberCell
        cell.item = selectedUserArray[indexPath.row]
        cell.onRemoveClick = { [weak self ]  in
            self?.selectedUserArray.remove(at: indexPath.row)
            self?.addMemberView.isHidden = self?.selectedUserArray.count == 0 ? true:false

            self?.groupMemberCollectionView.reloadData()
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 120, height: 30)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.groupMemberCollectionView{
            if self.selectedUserArray.count > 0{
                let item = self.selectedUserArray[indexPath.row]
                let fullName = "\(item.first_name ?? "") \(item.last_name ?? "")"
                return CGSize(width: Utility.labelWidth(height: 28, font:  UIFont(name: "calibri", size: 13)!, text: fullName)+70, height: 28)
               }else{
                   return CGSize()
               }
           }
           return CGSize()
       }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.resizeCollectionViewSize()
            }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 6
          }
          
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
              return 4
          }
          
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
              return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          }
    
    func resizeCollectionViewSize(){
            DispatchQueue.main.async {
                self.groupColletionViewHeight.constant = self.groupMemberCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    
}

//MARK: - ImagePicker Delegate
extension CreateGroupScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageData = nil
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.groupProfileImage.image = image
            self.imageData = image.png(isOpaque: false)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - API Calling
extension CreateGroupScreen{
    func createGroupAPI(){
        self.view.endEditing(true)
        let idArray = selectedUserArray.map { $0.user_id ?? 0}
        let ids = idArray.map { String($0) }.joined(separator: ",")
        
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  CreateGroupRequest(group_id: nil, name: self.groupNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), bio: self.groupBioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), user_ids: ids, is_public: "\(isPublicPrivate)")
            GroupService.shared.createGroup(parameters: data.toJSON(), imageData: self.imageData) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                //                if let data = response{
                self?.onCreateGtoupeClick?()
                self?.navigationController?.popViewController(animated: true)
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
