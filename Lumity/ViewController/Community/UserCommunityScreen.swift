//
//  UserCommunityScreen.swift
//  Source-App
//
//  Created by Nikunj on 07/05/21.`
//

import UIKit

class UserCommunityScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var inspireBySelectedView: dateSportView!
//    @IBOutlet weak var inspiringSelectedView: dateSportView!
//    @IBOutlet weak var inspiredByLabel: UILabel!
//    @IBOutlet weak var inspiringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTypeSegment: UISegmentedControl!
    
    
    @IBOutlet weak var inspiringView: UIView!
    @IBOutlet weak var inspiredByView: UIView!
    
    @IBOutlet weak var inspiringLabel: UILabel!
    @IBOutlet weak var inspiredByLabel: UILabel!
    
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var itemArray: [UserInterestList] = []
    var type: Int = 2
    var searchText: String?
    var userId: Int?
    var superVC: TabBarScreen?

    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        let segAttributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Calibri-Bold", size: 18)!
        ]

        self.postTypeSegment.setTitleTextAttributes(segAttributes as? [NSAttributedString.Key : Any], for: .selected)
        
        let segNormalAttributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.4),
            NSAttributedString.Key.font: UIFont(name: "Calibri", size: 18)!
        ]

        self.postTypeSegment.setTitleTextAttributes(segNormalAttributes as? [NSAttributedString.Key : Any], for: .normal)
        
        self.postTypeSegment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)

        
        self.tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        self.getCommunityListData(page: self.page)
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
    
    //MARK: - ACTIONS
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
                        self.getCommunityListData(page: self.page)
                    }
                }
            }
        }
    }
    
    func getCommunityListData(page: Int){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = UserCommunityRequest(user_id: self.userId,type: self.type, search: self.searchText, page: page, group_id: nil)
            ProfileService.shared.userCommunity(parameters: data.toJSON(), page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.userInterestListResponse{
                    if self?.page == 1{
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

    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if self.postTypeSegment.selectedSegmentIndex == 0 {
            print("Select 0")
            self.type = 2
            self.page = 1
            self.getCommunityListData(page: self.page)
        } else if self.postTypeSegment.selectedSegmentIndex == 1 {
            print("Select 1")
            self.type = 1
            self.page = 1
            self.getCommunityListData(page: self.page)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onInspiring(_ sender: UIButton) {
        self.inspiringView.isHidden = false
        self.inspiredByView.isHidden = true
        
        self.inspiringLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.inspiredByLabel.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        
        self.type = 2
        self.page = 1
        self.getCommunityListData(page: self.page)
    }
    

    @IBAction func onInspiredBy(_ sender: UIButton) {
        self.inspiringView.isHidden = true
        self.inspiredByView.isHidden = false
        
        self.inspiringLabel.textColor =  #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        self.inspiredByLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.type = 1
        self.page = 1
        self.getCommunityListData(page: self.page)
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension UserCommunityScreen : UITableViewDelegate, UITableViewDataSource{
    
    
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
extension UserCommunityScreen: UITextFieldDelegate{
    
    
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
