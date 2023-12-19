//
//  CommunityScreen.swift
//  Source-App
//
//  Created by Nikunj on 26/03/21.
//

import UIKit

class CommunityScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var skipButton: UIButton!
    
    var itemArray: [UserInterestList] = []
    var pageNum = 1
    var hasMorePage: Bool = false
    var meta: Meta?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        self.getCommunityListData(str: nil)
        self.searchTextField.clearButtonMode = .always
        // Do any additional setup after loading the view.
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
            Utility.showIndicator()
            let url = userInterestListURL + "\(pageNum)"
            let data = SearchCommunityRequest(explore: nil,username: str, page: "\(pageNum)")
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
    
    func addJoinUser(userId: Int,status: Int){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                self?.skipButton.setTitle("Next", for: .normal)
//                self?.skipButton.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5333333333, blue: 1, alpha: 1)
                self?.skipButton.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.5333333333, blue: 1, alpha: 1), for: .normal)
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
    
    //MARK: - ACTIONS
    @IBAction func onSkip(_ sender: Any) {
//        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LocationPermissionScreen") as! LocationPermissionScreen
//        self.navigationController?.pushViewController(vc, animated: true)
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "NotificationPermissionScreen") as! NotificationPermissionScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension CommunityScreen : UITableViewDelegate, UITableViewDataSource{
    
    
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
}
//MARK: - TEXTFIELD DELEGATE
extension CommunityScreen: UITextFieldDelegate{
    
    
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
