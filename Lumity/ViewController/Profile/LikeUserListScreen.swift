//
//  LikeUserListScreen.swift
//  Source-App
//
//  Created by iroid on 11/04/21.
//

import UIKit

class LikeUserListScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLE DECLARE
    var itemArray: [UserInterestList] = []
    var postId = 0
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var isFromCommentLike:Bool = false
    var superVC: TabBarScreen?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getLikeListAPI(postId: postId)
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        guard let text = textField.text else {
//            return
//        }
//        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
//            self.getCommunityListData(str: nil)
//        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
//                self?.getCommunityListData(str: text.trimmingCharacters(in: .whitespacesAndNewlines))
//            })
//        }
//    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                        getLikeListAPI(postId: postId)
                    }
                }
            }
        }
    }
    
    //MARK: - GET LIKE USER API
    func getLikeListAPI(postId:Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            PostService.shared.likeUserList(parameters: isFromCommentLike == true ? getCommentLikeList(comment_id: postId, page: page).toJSON():getLikeList(post_id: postId, page: page).toJSON(), url: isFromCommentLike == true ? commentLikeListUrl+"\(page)":likeUserListURL+"\(page)") { (statusCode, response) in
//                Utility.hideIndicator()
                
                self.hasMorePage = true
                if let data = response.userInterestListResponse{
                    if self.page == 1{
                        self.itemArray = data
                        self.tableView.reloadData()
                    }else{
                        self.appendPostDataTableView(data: data)
                    }
                }
                if let meta = response.meta{
                    self.meta = meta
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
    
    func appendPostDataTableView(data: [UserInterestList]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.tableView.insertRows(at: indexPath, with: .bottom)
    }
    
    func changeJoinStatus(userId: Int,status: Int){
        if let index = self.itemArray.firstIndex(where: {$0.user_id == userId}){
            self.itemArray[index].join_status = status
            self.tableView.reloadData()
        }
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension LikeUserListScreen : UITableViewDelegate, UITableViewDataSource{
    
    
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
