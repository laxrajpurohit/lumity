//
//  GroupUserListScreen.swift
//  Lumity
//
//  Created by iMac on 04/11/22.
//

import UIKit

class GroupUserListScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLE DECLARE
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var itemArray: [UserInterestList] = []
    var searchText: String?
    var superVC: TabBarScreen?
    var groupId:Int? = nil

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        self.getGroupUsersListData()
    }
    
    
    @objc func textChangeSearch(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.searchText = nil
            self.page = 1
            self.getGroupUsersListData()
        }else{
            self.searchText = text
            self.page = 1
            self.itemArray = []
            self.getGroupUsersListData()
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension GroupUserListScreen : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunityCell
        cell.item = self.itemArray[indexPath.row]
        cell.onJoin = { [weak self] in
            let status = self?.itemArray[indexPath.row].join_status == 0 ? 1 : 0
            self?.addJoinUser(userId: self?.itemArray[indexPath.row].user_id ?? 0,status: status)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
        vc.userId = self.itemArray[indexPath.row].user_id
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TEXTFIELD DELEGATE
extension GroupUserListScreen: UITextFieldDelegate{
    
    
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

 // MARK: - API CALL
extension GroupUserListScreen{
    func getGroupUsersListData(){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = GroupUserListRequest(group_id: "\(groupId ?? 0)", page: "\(page)")
            GroupService.shared.groupUserList(parameters: data.toJSON(), page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.groupUserList{
                    if self?.page == 1{
                        self?.itemArray = res
                        self?.tableView.reloadData()
                    }else{
                        self?.appendUserDataTableView(data: res)
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
    
    func appendUserDataTableView(data: [UserInterestList]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.tableView.insertRows(at: indexPath, with: .bottom)
    }
    
    
    func addJoinUser(userId: Int,status: Int){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.changeJoinStatus(userId: userId,status: status)
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
    
    func changeJoinStatus(userId: Int,status: Int){
        if let index = self.itemArray.firstIndex(where: {$0.user_id == userId}){
            self.itemArray[index].join_status = status
            self.tableView.reloadData()
        }
    }
}
