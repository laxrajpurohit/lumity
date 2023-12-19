//
//  MessageListScreen.swift
//  Source-App
//
//  Created by iroid on 17/05/21.
//

import UIKit

class MessageListScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var messageUserTableView: UITableView!
    @IBOutlet weak var searchSomeOneTextField: UITextField!
    
    // MARK: - VARIABLE DECLARE
    var chatUserList:[ChatListData] = []
    var refreshControl = UIRefreshControl()
    var page = 1
    var metaData:Meta?
    var hasMorePage: Bool = false
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchSomeOneTextField.clearButtonMode = .always
        self.navigationController?.navigationBar.isHidden = true
        initialDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //chatUserList = []
        page = 1
        getChat(page: 1)
    }
    
    
    func initialDetail(){
        messageUserTableView.register(UINib(nibName: "ChatUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatUserTableViewCell")
        messageUserTableView.tableFooterView = UIView()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        messageUserTableView.addSubview(refreshControl)
 
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        searchSomeOneTextField.text = ""
        //chatUserList = []
        page = 1
        getChat(page: page)
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNewMessage(_ sender: UIButton) {
        let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
        vc.isFromMessageScreen = true
        vc.messageNavigationType =  MessageNavigationType.newUserScreen.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showChatDeleteAlert(indexPath:Int) {
        let alert = UIAlertController(title: APPLICATION_NAME, message: "Are you sure you want to delete chat?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
              //Cancel Action
            self.deleteChat(id:self.chatUserList[indexPath].user?.user_id ?? 0)
            self.chatUserList.remove(at: indexPath)
            self.messageUserTableView.reloadData()
                                
          }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
              //Cancel Action
          }))
        
          self.present(alert, animated: true, completion: nil)
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
                if let metaTotal = self.metaData?.total{
                    if self.chatUserList.count != metaTotal{
                        self.hasMorePage = false
                        self.page += 1
                        self.getChat(page: self.page)
                    }
                }
            }
        
        }
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension MessageListScreen: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTableViewCell", for: indexPath) as! ChatUserTableViewCell
        if chatUserList.count > 0{
            cell.setUpData(model: chatUserList[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = chatUserList[indexPath.row].user
        let vc =  STORYBOARD.message.instantiateViewController(withIdentifier: "ChatDetailScreen") as! ChatDetailScreen
        vc.userData = model
        vc.receiverId = model?.user_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
//            deleteChat(id: 1)
            self.showChatDeleteAlert(indexPath: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
// MARK: - UITEXTFIELD DELEGATE
extension MessageListScreen:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //chatUserList.removeAll()
        page = 1
        getChat(page: page)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(txtAfterUpdate)
            NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(searchUserList),object: textField)
            self.perform(#selector(searchUserList),with: textField,afterDelay: 0.5)
        }
        return true
    }
    @objc func searchUserList(){
        //chatUserList.removeAll()
        page = 1
        getChat(page: page)
    }
}

//MARK: - API Calling
extension MessageListScreen{
    func getChat(page:Int){
        let url = chatUserUrl + "\(page)" + "&perPage=" + "\(15)"
        if !self.refreshControl.isRefreshing{
           // Utility.showIndicator()
        }
        //Utility.showIndicator()
        let data = UserChatRequest(search: searchSomeOneTextField.text?.trimmingCharacters(in: .whitespaces))
        MessageService.shared.getChatUserList(parameters: data.toJSON(), url: url) { (statusCode, response) in
            Utility.hideIndicator()
            self.hasMorePage = true
            self.refreshControl.endRefreshing()
            if let res = response.chatListData{
                if page == 1{
                    self.chatUserList = res
                    self.messageUserTableView.reloadData()
                    
                }else{
                    self.appendPostDataTableView(data: res)
                }
            }
            
            if let meta = response.meta{
                self.metaData = meta
            }

        } failure: { (error) in
            self.refreshControl.endRefreshing()
            Utility.hideIndicator()
            Utility.showAlert(vc: self, message: error)
        }
    }
    
    //MARK:- DELETE CHAT
    func deleteChat(id:Int){
        Utility.showIndicator()
        MessageService.shared.getChatUser(id: id) { statusCode, response in
            Utility.hideIndicator()
        } failure: {  error in
            Utility.hideIndicator()
            Utility.showAlert(vc: self, message: error)
        }
    }
    
    func appendPostDataTableView(data: [ChatListData]){
        var indexPath : [IndexPath] = []
        for i in self.chatUserList.count..<self.chatUserList.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.chatUserList.append(contentsOf: data)
        self.messageUserTableView.insertRows(at: indexPath, with: .bottom)
    }
    
}
