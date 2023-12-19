//
//  MyGroupListScreen.swift
//  Lumity
//
//  Created by iMac on 10/11/22.
//

import UIKit

class MyGroupListScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var groupListTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var groupArray: [GroupListData] = []
    var type: String = "0,1"
    var searchText: String?
    var selectedIndexGroupId = -1
    let refreshControl = UIRefreshControl()

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.groupListTableView.delegate = self
        self.groupListTableView.dataSource = self
        self.groupListTableView.register(UINib(nibName: "GroupListCell", bundle: Bundle.main), forCellReuseIdentifier: "GroupListCell")
        
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        
        self.groupListTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.pullRefreshHomeList(_:)), for: .valueChanged)
        
        self.getGroupListData(page: page)
    }
    
    @objc func pullRefreshHomeList(_ sender: Any){
        self.page = 1
        self.getGroupListData(page: page)
    }
    
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }

    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupDetailScreen") as! GroupDetailScreen
        vc.groupId = selectedIndexGroupId
//        vc.onUpdateGroupListCell = { [weak self]  obj in
//            self?.groupArray[indexPath.row] = obj
//            self?.groupListTableView.reloadRows(at: [indexPath], with: .none)
//        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "CreateGroupScreen") as! CreateGroupScreen
        vc.onCreateGtoupeClick = { [weak self ]  in
            self?.page = 1
            self?.getGroupListData(page: self?.page ?? 1)
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
                    if self.groupArray.count != metaTotal{
                        print("called")
                        self.hasMorePage = false
                        self.page += 1
                        self.getGroupListData(page: self.page)
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
            self.getGroupListData(page: self.page)
        }else{
            self.searchText = text
            self.page = 1
            self.groupArray = []
            self.getGroupListData(page: self.page)
        }
    }
    
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension MyGroupListScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupListTableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListCell
        cell.item = groupArray[indexPath.row]
        if selectedIndexGroupId == self.groupArray[indexPath.row].groupId{
            cell.sendPostSelectedImageView.image = UIImage(named: "chat_selected_icon")
        }else{
            cell.sendPostSelectedImageView.image = UIImage(named: "chat_unsend_icon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendButton.isUserInteractionEnabled = true
        self.sendButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.selectedIndexGroupId = self.groupArray[indexPath.row].groupId ?? 0
        self.groupListTableView.reloadData()
    }
    
}

//MARK: - API Calling
extension MyGroupListScreen{
        func getGroupListData(page: Int){
            if Utility.isInternetAvailable(){
                //            Utility.showIndicator()
                let data = GroupListRequest(is_public: self.type, search: self.searchText)
                GroupService.shared.groupList(parameters: data.toJSON(), page: page) { [weak self] (statusCode, response) in
                    Utility.hideIndicator()
                    self?.hasMorePage = true
                    if let res = response.groupListData{
                        if self?.page == 1{
                            self?.groupArray = res
                            self?.groupListTableView.reloadData()
                        }else{
                            self?.appendPostDataTableView(data: res)
                        }
                    }
                    self?.stopPulling()
                    if self?.groupArray.count == 0{
                        self?.notFoundLabel.isHidden = false
                    }else{
                        self?.notFoundLabel.isHidden = true
                    }
                    
                    if let meta = response.meta{
                        self?.meta = meta
                    }
                } failure: { [weak self] (error) in
                    guard let stronSelf = self else { return }
                    self?.stopPulling()
                    Utility.hideIndicator()
                    Utility.showAlert(vc: stronSelf, message: error)
                }
            }else{
                self.stopPulling()
                Utility.hideIndicator()
                Utility.showNoInternetConnectionAlertDialog(vc: self)
            }
        }
        
        func appendPostDataTableView(data: [GroupListData]){
            var indexPath : [IndexPath] = []
            for i in self.groupArray.count..<self.groupArray.count+data.count{
                indexPath.append(IndexPath(row: i, section: 0))
            }
            self.groupArray.append(contentsOf: data)
            self.groupListTableView.insertRows(at: indexPath, with: .bottom)
        }
    }
//MARK:- TEXTFIELD DELEGATE
extension MyGroupListScreen: UITextFieldDelegate{
    
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
//MARK: - GROUP DELETE
extension MyGroupListScreen: DeleteGroupDelegate{
    func deleteGroup(){
        self.page = 1
        self.getGroupListData(page: page)
    }
}
