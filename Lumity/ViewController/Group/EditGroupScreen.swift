//
//  EditGroupScreen.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class EditGroupScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var groupBioTextView: UITextView!
    
    @IBOutlet weak var memberTableView: UITableView!
    
    @IBOutlet weak var groupProfileImageView: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var publicPrivateSwich: UISwitch!

    // MARK: - VARIABLE DECLARE
    var itemArray: [UserInterestList] = []
    var groupDetailData:GroupListData?
    var groupId:Int = 0
    var imageData: Data?
    var onEditGroupClick : ((GroupListData) -> Void)?
    var isPublicPrivate = 1
    var deleteGroupDelegate: DeleteGroupDelegate?
    
    
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.doneButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        self.memberTableView.register(UINib(nibName: "ManageMemberCell", bundle: Bundle.main), forCellReuseIdentifier: "ManageMemberCell")
        
        self.getGroupDetailData(groupId: self.groupId)
    }
   
    
    func setUpdata(groupData:GroupListData){
        self.groupNameTextField.text = groupData.name
        self.groupBioTextView.text = groupData.bio
        self.publicPrivateSwich.isOn =  groupData.isPublic == 1 ? false:true
        self.isPublicPrivate = groupData.isPublic ?? 1
        Utility.setImage(groupData.profile, imageView: self.groupProfileImageView)
//        if let groupMembers = groupData.groupMembers{
//            self.itemArray = groupMembers
//            self.memberTableView.reloadData()
//        }
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onInvite(_ sender: Any) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "InviteGroupMemberScreen") as! InviteGroupMemberScreen
        vc.selectedUserArray = self.itemArray
        vc.groupId = self.groupId
        vc.onRefreshMemberCount = { [weak self ] memberCount in
//            self?.itemArray = inviteUsers
//            self?.onEditGroupClick?(data)
//            self?.memberTableView.reloadData()
            self?.groupDetailData?.groupMembersCount = memberCount

            
            self?.onEditGroupClick?((self?.groupDetailData)!)
            
            self?.page = 1
            self?.getGroupUsersListData()

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onDeleteGroup(_ sender: Any) {
        self.deleteGroup()
    }
    
    @IBAction func onAddGroupImage(_ sender: Any) {
        self.photoSelectOption()
    }
    
    @IBAction func onPublicPrivateSwich(_ sender: UISwitch) {
        self.isPublicPrivate = sender.isOn ? 0:1
    }
    @IBAction func onEditGroup(_ sender: UIButton) {
        if self.groupNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            Utility.showAlert(vc: self, message: "Please enter group name")
            return
        }
        self.editGroupAPI()
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
    
    func deleteGroup() {
        let alert = UIAlertController(title: "Are you sure you want to delete this group?", message: "Once the group is deleted, all information shared within the group will also be deleted", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //Delete action
            self.removeAndDeleteGroup(groupId: self.groupId, userId: Utility.getCurrentUserId())
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: scroll method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            if self.hasMorePage{
                if let metaTotal = self.meta?.total{
                    if self.itemArray.count != metaTotal{
                        print("called")
                        self.hasMorePage = false
                        self.page += 1
                        self.getGroupUsersListData()
                    }
                }
            }
        }
    }
    
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension EditGroupScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.memberTableView.dequeueReusableCell(withIdentifier: "ManageMemberCell", for: indexPath) as! ManageMemberCell
        cell.item = self.itemArray[indexPath.row]
        cell.onRemoveClick = { [weak self ]  in
            self?.removeAndDeleteGroup(groupId: self?.groupId ?? 0, userId:self?.itemArray[indexPath.row].user_id ?? 0 )
            self?.itemArray.remove(at: indexPath.row)
            self?.memberTableView.reloadData()
        }
        return cell
    }
    
    
}

//MARK: - ImagePicker Delegate
extension EditGroupScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageData = nil
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.groupProfileImageView.image = image
            self.imageData = image.png(isOpaque: false)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - API Calling
extension EditGroupScreen{
    
    func getGroupDetailData(groupId: Int){
        if Utility.isInternetAvailable(){
            GroupService.shared.groupDetail(url:groupDetailURL+"\(groupId)") { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response?.groupDetailData{
                    self?.setUpdata(groupData: res)
                }
                self?.getGroupUsersListData()
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
    
    func getGroupUsersListData(){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = GroupUserListRequest(group_id: "\(groupId)", page: "\(page)")
            GroupService.shared.groupUserList(parameters: data.toJSON(), page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.groupUserList{
                    if self?.page == 1{
                        self?.itemArray = res
                        self?.memberTableView.reloadData()
                    }else{
                        self?.appendPostDataTableView(data: res)
                    }
                }

                if let meta = response.meta{
                    self?.meta = meta
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
    
    func appendPostDataTableView(data: [UserInterestList]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.memberTableView.insertRows(at: indexPath, with: .bottom)
    }
    
    func editGroupAPI(){
        self.view.endEditing(true)
        let idArray = self.itemArray.map { $0.user_id ?? 0}
        let ids = idArray.map { String($0) }.joined(separator: ",")
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data =  CreateGroupRequest(group_id: "\(groupId)", name: self.groupNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), bio: self.groupBioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), user_ids: ids, is_public: "\(self.isPublicPrivate)")
            GroupService.shared.createGroup(parameters: data.toJSON(), imageData: self.imageData) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let data = response?.groupDetailData{
                    
                    self?.onEditGroupClick?(data)
                }
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
    

    func removeAndDeleteGroup(groupId: Int,userId: Int){
        if Utility.isInternetAvailable(){
            GroupService.shared.removeUserFromGroup(url:removeUserFromGroupURL+"\(groupId)/" + "\(userId)") { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if userId == Utility.getCurrentUserId(){
                    for controller in (self?.navigationController!.viewControllers)! as Array {
                            if controller is GroupListScreen {
                                self?.deleteGroupDelegate?.deleteGroup()
                                self?.navigationController!.popToViewController(controller, animated: true)
                                break
                        }
                    }
                    
                    
//                    self?.navigationController?.popViewController(animated: true)
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
    
}
