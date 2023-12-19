//
//  MessageSuggectionUserScreen.swift
//  Source-App
//
//  Created by iroid on 06/06/21.
//

import UIKit

class MessageSuggectionUserScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var messageSuggectionUserTableView: UITableView!
    @IBOutlet weak var chatButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var itemArray: [UserInterestList] = []
    var type: Int = 1
    var searchText: String?
    var userId: Int?
    var superVC: TabBarScreen?
    var postItemDataDetailData:PostReponse?
    var selectedIndexUserId = -1
    var postType = 0
    var isFromMessageScreen = false
    var myLibraryListResponse:MyLibraryListResponse?
   var  messageNavigationType = 0
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.messageSuggectionUserTableView.register(UINib(nibName: "UserListMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListMessageTableViewCell")

        self.messageSuggectionUserTableView.delegate = self
        self.messageSuggectionUserTableView.dataSource = self
        self.messageSuggectionUserTableView.tableFooterView = UIView()
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        self.chatButton.setTitle(isFromMessageScreen == true ? "Chat":"Send", for: .normal)
        
        userId = Utility.getCurrentUserId()
        if !(postItemDataDetailData?.reshare ?? false){
            if postItemDataDetailData?.post_type == PostType.book.rawValue{
                postType = 3
            }else if postItemDataDetailData?.post_type == PostType.podcast.rawValue{
                postType = 4
            }else if postItemDataDetailData?.post_type == PostType.video.rawValue{
                postType = 5
            }else if postItemDataDetailData?.post_type == PostType.artical.rawValue{
                postType = 6
            }else if postItemDataDetailData?.post_type == PostType.reShare.rawValue{
                postType = 7
            }
        }else{
            postType = 7
        }
        
       
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
    
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChat(_ sender: UIButton) {
        
        //       let data = itemArray.filter({ $0.user_id == selectedIndexUserId }).first
        if  !isFromMessageScreen{
            var parameter = [String:Any]()
            
            if postType == 8{
                parameter = ["message": "",
                             "senderId":Utility.getCurrentUserId(),
                             "receiverId":self.selectedIndexUserId,
                             "type":postType,
                             "post_type_id":"",
                             "mylibraryId":myLibraryListResponse?.id ?? 0
                ] as [String:Any]
            }else{
                parameter = ["message":postItemDataDetailData?.media ?? "",
                             "senderId":Utility.getCurrentUserId(),
                             "receiverId":self.selectedIndexUserId,
                             "type":postType,
                             "post_type_id":postItemDataDetailData?.id ?? 0] as [String:Any]
            }
            
            if SocketHelper.shared.checkConnection() {
                SocketHelper.Events.sendMessage.emit(params: parameter)
            }else{
                Utility.showNoInternetConnectionAlertDialog(vc: self)
            }
        }
        
        let vc =  STORYBOARD.message.instantiateViewController(withIdentifier: "ChatDetailScreen") as! ChatDetailScreen
        vc.receiverId = self.selectedIndexUserId
        vc.isFromSuggested = true
        vc.messageNavigationType = messageNavigationType
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
                        self?.messageSuggectionUserTableView.reloadData()
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
        self.messageSuggectionUserTableView.insertRows(at: indexPath, with: .bottom)
    }
    

}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension MessageSuggectionUserScreen : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.messageSuggectionUserTableView.dequeueReusableCell(withIdentifier: "UserListMessageTableViewCell", for: indexPath) as! UserListMessageTableViewCell
        cell.item = self.itemArray[indexPath.row]
        if selectedIndexUserId == self.itemArray[indexPath.row].user_id{
            cell.sendMessageSelectedImageView.image = UIImage(named: "chat_selected_icon")
        }else{
            cell.sendMessageSelectedImageView.image = UIImage(named: "chat_unsend_icon")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.itemArray.count > 0{
        self.chatButton.isUserInteractionEnabled = true
        self.chatButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.selectedIndexUserId = self.itemArray[indexPath.row].user_id ?? 0
        self.messageSuggectionUserTableView.reloadData()
        }
    }
}
//MARK: - TEXTFIELD DELEGATE
extension MessageSuggectionUserScreen: UITextFieldDelegate{
   
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
