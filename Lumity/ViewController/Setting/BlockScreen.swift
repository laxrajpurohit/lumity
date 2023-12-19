//
//  BlockScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit

class BlockScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var blockTabelView: UITableView!
    @IBOutlet weak var blockUserListView: UIView!
    @IBOutlet weak var youAreCurrentlyBlockingLabel: UILabel!
    
    var blockUserList:[BlockUserResponse] = []
    var page: Int = 1
    var meta: Meta?
    var hasMorePage:Bool = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDetail()
    }
    
    func initialDetail(){
        self.blockTabelView.register(UINib(nibName: "BlockTableViewCell", bundle: nil), forCellReuseIdentifier: "BlockTableViewCell")
        self.blockTabelView.tableFooterView = UIView()
        self.blockUserList(pageNum: 1)
        
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
                    if self.blockUserList.count != metaTotal{
                        print("called")
                        self.hasMorePage = false
                        self.page += 1
                        self.blockUserList(pageNum: self.page)
                    }
                }
            }
        }
    }
    
    
    func blockSuccessAlert(data:BlockUserResponse) {
        let alert = UIAlertController(title: "\(data.first_name ?? "") \(data.last_name ?? "") unblocked", message: "You can block them from their profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            //                    print("You've pressed cancel")
            if self.blockUserList.count == 0{
                self.blockUserListView.isHidden = true
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension BlockScreen:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockTableViewCell", for: indexPath) as! BlockTableViewCell
        cell.data = blockUserList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reshareVC = STORYBOARD.setting.instantiateViewController(withIdentifier: "BlockConfirmationAlertScreen") as! BlockConfirmationAlertScreen
        
        reshareVC.modalPresentationStyle = .overFullScreen
        reshareVC.blockUserData = blockUserList[indexPath.row]
        reshareVC.onUnBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.addJoinUser(userId: self?.blockUserList[indexPath.row].user_id ?? 0, status: 2, blockUserData: (self?.blockUserList[indexPath.row])!)
            self?.blockUserList.remove(at: indexPath.row)
            self?.blockTabelView.reloadData()
            self?.youAreCurrentlyBlockingLabel.text = self?.blockUserList.count == 1 ? "You’re currently blocking 1 person.":"You’re currently blocking \(self?.blockUserList.count ?? 0) people."
           // self?.youAreCurrentlyBlockingLabel.text =
        }
        self.present(reshareVC, animated: false, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension BlockScreen{
    //MARK: - update Notification Preferences
    func blockUserList(pageNum:Int){
        
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let url = blockUserListURL + "\(pageNum)"
            let parameter = BlockUserListRequest(page: pageNum)
            ProfileService.shared.blockUserList(url: url, parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                self.hasMorePage = true
                if let res = response.blockUserResponse{
                    if self.page == 1{
                        self.blockUserList = res
                        if self.blockUserList.count == 0{
                            self.blockUserListView.isHidden = true
                            return
                        }
                        self.blockTabelView.reloadData()
                    }else{
                        self.appendPostDataTableView(data: res)
                    }
                }
                if let metaResponse = response.meta{
                    self.meta = metaResponse
                    self.youAreCurrentlyBlockingLabel.text = metaResponse.total == 1 ? "You’re currently blocking 1 person.":"You’re currently blocking \(metaResponse.total ?? 0) people."
//                    self.youAreCurrentlyBlockingLabel.text = "You’re currently blocking \(metaResponse.total ?? 0) people"
                }
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func addJoinUser(userId: Int,status: Int,blockUserData:BlockUserResponse){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.blockSuccessAlert(data: blockUserData)
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
    
    func appendPostDataTableView(data: [BlockUserResponse]){
        var indexPath : [IndexPath] = []
        
        for i in self.blockUserList.count..<self.blockUserList.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.blockUserList.append(contentsOf: data)
        self.blockTabelView.insertRows(at: indexPath, with: .bottom)
    }
    
}
