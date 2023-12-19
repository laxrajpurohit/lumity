//
//  ExploreUserListScreen.swift
//  Source-App
//
//  Created by Nikunj on 17/04/21.
//

import UIKit

class ExploreUserListScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLE DECLARE
    var itemArray: [UserInterestList] = []
    var pageNum = 1
    var hasMorePage: Bool = false
    var meta: Meta?
    var searchText: String?
    var superVC: TabBarScreen?
    
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
        if self.itemArray.isEmpty{
            self.getCommunityListData(str: nil)
        }else{
            self.hasMorePage = true
        }
        self.searchTextField.text = self.searchText
    }
    
    @objc func textChangeSearch(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            self.getCommunityListData(str: nil)
        }else{
            self.pageNum = 1
            self.itemArray = []
            self.getCommunityListData(str: text.trimmingCharacters(in: .whitespacesAndNewlines))
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
                        print("called")
                        self.hasMorePage = false
                        self.pageNum += 1
                        getCommunityListData(str: searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                    }
                }
            }
        }
    }
    
    func getCommunityListData(str: String?){
        if Utility.isInternetAvailable(){
           // Utility.showIndicator()
            let url = userInterestListURL + "\(pageNum)"
            let data = SearchCommunityRequest(explore: "1",username: str, page: "\(pageNum)")
            LoginService.shared.getUserInterestList(parameters: data.toJSON(), url: url) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                
//                [UserInterestList]?
                self?.hasMorePage = true
                if let res = response.userInterestListResponse{
//                    self?.itemArray = data
                    if self?.pageNum == 1{
                        self?.itemArray = res
                        self?.tableView.reloadData()
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
        self.tableView.insertRows(at: indexPath, with: .bottom)
    }
    
    func addJoinUser(userId: Int,status: Int,currantIndex:Int){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
//                self?.changeJoinStatus(userId: userId,status: status,currantIndex:currantIndex)
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
    
    func changeJoinStatus(userId: Int,status: Int,currantIndex:Int){
        self.itemArray[currantIndex].join_status = status
        self.tableView.reloadRows(at: [IndexPath(row: currantIndex, section: 0)], with: .none)
//        if let index = self.itemArray.firstIndex(where: {$0.user_id == userId}){
//            self.itemArray[index].join_status = status
//            self.tableView.reloadData()
//        }
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension ExploreUserListScreen : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunityCell
        cell.item = self.itemArray[indexPath.row]
        cell.onJoin = { [weak self] in
            let status = self?.itemArray[indexPath.row].join_status == 0 ? 1 : 0
            self?.addJoinUser(userId: self?.itemArray[indexPath.row].user_id ?? 0,status: status,currantIndex: indexPath.row)
            self?.itemArray[indexPath.row].join_status = status
            self?.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray.indices.contains(indexPath.row){
            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
            vc.userId = self.itemArray[indexPath.row].user_id
            vc.superVC = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK: - TEXTFIELD DELEGATE
extension ExploreUserListScreen: UITextFieldDelegate{
    
    
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

