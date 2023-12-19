//
//  InviteGroupMemberScreen.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class InviteGroupMemberScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var itemArray: [UserInterestList] = []
    var type: Int = 1
    var searchText: String?
    var selectedUserArray: [UserInterestList] = []
    var onInviteClick : (([UserInterestList]) -> Void)?
    var onRefreshMemberCount : ((Int) -> Void)?
    var groupId: Int? = nil
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
    }
    
    func initializeDetails(){
        self.doneButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        self.memberTableView.register(UINib(nibName: "UserListMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListMessageTableViewCell")
        self.getCommunityListData(page: page)
    }

    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onDone(_ sender: UIButton) {
        if self.groupId == nil{
            self.onInviteClick?(selectedUserArray)
            self.navigationController?.popViewController(animated: true)
        }else{
            let idArray = self.selectedUserArray.map { $0.user_id ?? 0}
            let ids = idArray.map { String($0) }.joined(separator: ",")
            if ids != ""{
                self.doJoinAPI(ids: ids)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
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
                        self.hasMorePage = false
                        self.page += 1
                        self.getCommunityListData(page: self.page)
                    }
                }
            }
        }
    }
    
    @objc func textChangeSearch(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.searchText = nil
            self.page = 1
            self.getCommunityListData(page: self.page)
        }else{
            self.searchText = text
            self.page = 1
            self.itemArray = []
            self.getCommunityListData(page: self.page)
        }
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension InviteGroupMemberScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.memberTableView.dequeueReusableCell(withIdentifier: "UserListMessageTableViewCell", for: indexPath) as! UserListMessageTableViewCell
        cell.item = self.itemArray[indexPath.row]
        if self.selectedUserArray.contains(where: { $0.user_id == self.itemArray[indexPath.row].user_id ?? 0} ){
            cell.sendMessageSelectedImageView.image = UIImage(named: "chat_selected_icon")
        }else{
            cell.sendMessageSelectedImageView.image = UIImage(named: "chat_unsend_icon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let userObject = self.itemArray[indexPath.row] else {
//            return
//        }
//
         let userObject = self.itemArray[indexPath.row]
        
        if let index = self.selectedUserArray.firstIndex(where: {$0.user_id == userObject.user_id}){
            self.selectedUserArray.remove(at: index)
        }else{
            self.selectedUserArray.append(userObject)
        }
        self.memberTableView.reloadData()
    }
}
//MARK: - APICall
extension InviteGroupMemberScreen{
    func getCommunityListData(page: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            
            let data = UserCommunityRequest(user_id: self.groupId == nil ? Utility.getCurrentUserId():nil , type: self.groupId == nil ? 1:nil , search: self.searchText, page: page, group_id: groupId)
            ProfileService.shared.userCommunity(parameters: data.toJSON(), page: page,isFromGroup:self.groupId == nil ?
                                                false:true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.userInterestListResponse{
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
    
    
    
    
    
    //MARK: - DO JOIN API
    func doJoinAPI(ids:String){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            
            //            Utility.showIndicator()
            let parameter = JoinGroupRequest(group_id: "\(groupId ?? 0)", user_id: ids)
            GroupService.shared.doJoinGroup(parameters: parameter.toJSON()) { (statusCode, response) in
                if let res = response.memberCountData{
                    self.onRefreshMemberCount?(res.groupMembersCount ?? 0)
                    print(res.groupMembersCount ?? 0)
                }
                //                Utility.hideIndicator()
//                self.onInviteClick?(selectedUserArray)
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
//MARK: - TEXTFIELD DELEGATE
extension InviteGroupMemberScreen: UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.textChangeSearch(_:)),object: textField)
            self.perform(#selector(textChangeSearch),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.textChangeSearch(_:)),object: textField)
            self.perform(#selector(textChangeSearch),with: textField,afterDelay: 0.5)
        return true
    }
}
