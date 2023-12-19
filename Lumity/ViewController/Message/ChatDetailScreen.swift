//
//  ChatDetailScreen.swift
//  Tendask
//
//  Created by iroid on 15/03/21.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class ChatDetailScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var chatDetailTableView: UITableView!
    @IBOutlet weak var onlineOfflineLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var onlineStatusImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var chatOptionButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    var refreshControl = UIRefreshControl()
    var page = 1
    var metaData:Meta?
    var hasMorePages = false
    var chatDetailList:[MessageData] = []
    var filterDictionary = [String:[MessageData]]()
    var finalDictionary = [SectionMessageData]()
    var imageData: Data? = nil
    var userData:LoginResponse?
    var tap: UITapGestureRecognizer?
    var receiverId = 0
    var isFromSuggested = false
    var isCheckNotification = false
    var totalMessageArray:[MessageData] = []
    var  messageNavigationType = 0
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isHidden = true
        isCheckCurrantNotificationScreen = true
        initialDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //        let scrollPoint = CGPoint(x: 0, y: self.chatTableView.contentSize.height - self.chatTableView.frame.size.height)
        //        self.chatTableView.setContentOffset(scrollPoint, animated: false)
        self.tabBarController?.tabBar.isHidden = true

        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offSocket()
        currantChatId = -1
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        isCheckCurrantNotificationScreen = false
    }
    
    func initialDetail(){
        messageTextView.delegate = self
        messageTextView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 7, right: 15)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
       
        
//        tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap!)
        
        chatDetailTableView.delegate = self
        chatDetailTableView.dataSource = self
        let nib = UINib(nibName: "SenderTableViewCell", bundle: nil)
        chatDetailTableView.register(nib, forCellReuseIdentifier: "SenderTableViewCell")
        chatDetailTableView.register(UINib(nibName: "receiverTableViewCell", bundle: nil), forCellReuseIdentifier: "receiverTableViewCell")
        chatDetailTableView.register(UINib(nibName: "ChatTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTimeTableViewCell")
        chatDetailTableView.register(UINib(nibName: "SenderPhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderPhotosTableViewCell")
        chatDetailTableView.register(UINib(nibName: "ReceiverPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverPhotoTableViewCell")
        chatDetailTableView.register(UINib(nibName: "BookPostReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "BookPostReceiverTableViewCell")
        chatDetailTableView.register(UINib(nibName: "BookPostSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "BookPostSenderTableViewCell")
        chatDetailTableView.register(UINib(nibName: "LinkPostReveiverTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkPostReveiverTableViewCell")
        chatDetailTableView.register(UINib(nibName: "LinkPostSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkPostSenderTableViewCell")
        chatDetailTableView.register(UINib(nibName: "FolderSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "FolderSenderTableViewCell")
        chatDetailTableView.register(UINib(nibName: "FolderReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "FolderReceiverTableViewCell")
        chatDetailTableView.register(UINib(nibName: "ReshareSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReshareSenderTableViewCell")
        chatDetailTableView.register(UINib(nibName: "ReshareReciverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReshareReciverTableViewCell")
        
        
        if let data = userData{
            setUpData(model: data)
        }
        getChatDetail(pageNumber: page)
        var parameter = [String: Any]()
        currantChatId = receiverId
        parameter = ["senderId": Utility.getCurrentUserId(),
                     "receiverId":receiverId,
        ] as [String:Any]
      
        SocketHelper.Events.addUser.emit(params: parameter)
        
        let  param = ["senderId":Utility.getCurrentUserId(),
                      "receiverId":receiverId,
                      "messageId":0] as [String:Any]
        print(param)
        SocketHelper.Events.ReadMessage.emit(params: param)
        
        socketListenMethods(parameter: parameter)
        let  parameterOnline = ["senderId":Utility.getCurrentUserId(),
                                "isOnline":1
                                ] as [String:Any]
        SocketHelper.Events.getOnlineStatus.emit(params: parameterOnline)
    }
    
    @IBAction func onSideMenu(_ sender: UIButton) {
        if  self.chatOptionButton.isSelected{
            self.chatOptionButton.isSelected = false
        }else{
            self.chatOptionButton.isSelected = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        view.gestureRecognizers?.removeAll()

        self.chatOptionButton.isSelected = false
    }
    
    // MARK: - ACTIONS
    @IBAction func onDeleteChat(_ sender: UIButton) {
        showChatDeleteAlert()
    }
    func showChatDeleteAlert() {
        let alert = UIAlertController(title: APPLICATION_NAME, message: "Are you sure you want to delete chat?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
              //Cancel Action
            self.deleteChat()
          }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
              //Cancel Action
          }))
        
          self.present(alert, animated: true, completion: nil)
      }
    
    func setUpData(model:LoginResponse){
        
      
        Utility.setImage(model.profile_pic, imageView: profileImageView)
        nameLabel.text = model.first_name
        
//        if model.is_online ?? false{
//            onlineStatusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.8365593553, blue: 0.6070920229, alpha: 1)
//            onlineOfflineLabel.text = "Online"
//        }else{
//            onlineStatusImageView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
//            onlineOfflineLabel.text = "Offline"
//        }
    }
    //Calls this function when the tap is recognized.
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        view.endEditing(true)
        if messageTextView.text == "" {
            messageTextView.text = "Type a Message..."
            messageTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    //MARK:Keyboard Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height) != nil {
            self.chatDetailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.chatDetailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let _:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let _:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomViewBottomConstraint?.constant = 0.0
            } else {
                var bottomPadding = CGFloat()
                bottomPadding = 0
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    _ = window?.safeAreaInsets.top
                    bottomPadding = (window?.safeAreaInsets.bottom)!
                }
                self.bottomViewBottomConstraint?.constant = 0 + ((endFrame?.size.height)! - bottomPadding)
            }
        }
    }
    @objc func appBecomeActive() {
      
        
        let parameter = ["senderId": Utility.getCurrentUserId(),
                         "receiverId":receiverId] as [String:Any]
        
        SocketHelper.Events.addUser.emit(params: parameter)
        self.socketListenMethods(parameter: parameter)
        //        self.loadChat(isNextPage: false, nextUrl: nil, isShwoIndicator: true)
    }
    func socketListenMethods(parameter: [String:Any]) {
        
        
        SocketHelper.Events.userAdded.listen { [weak self] (result) in
            
            SocketHelper.Events.getOnlineStatus.emit(params: parameter)
            
        }
        
        SocketHelper.Events.DisplayTyping.listen { [weak self] (result) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
               
                
                if let dictFromJSON = decoded as? [String:Any] {
                    if Utility.getCurrentUserId() == dictFromJSON["receiverId"] as? Int{
                        self?.onlineOfflineLabel.text = "Typing..."
                    }
                }
            }catch{}
        }
        
        SocketHelper.Events.getOnlineStatus.listen { [weak self] (result) in
           print(result)
        }
        
        //                SocketHelper.Events.newMessageRead.listen { [weak self] (result) in
        //                    if let messageDetail = self?.messageDetail {
        //                        for i in messageDetail {
        //                            i.isSeen = true
        //                            self?.messagesTableView.reloadData()
        //                        }
        //                    }
        //                }
        
        SocketHelper.Events.chatDeactivated.listen { [weak self] (result) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    if((dictFromJSON["isDeactivate"] as! Int) == 0){
                        self!.messageTextView.resignFirstResponder()
                    }else{
                        self!.messageTextView.resignFirstResponder()
                    }
                }
            }catch{}
        }
        
        SocketHelper.Events.removeTypingMessage.listen { [weak self] (result) in
            self?.onlineOfflineLabel.text = "Online"
        }
        
        SocketHelper.Events.statusOnline.listen { [weak self] (result) in
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let dictFromJSON = decoded as? [String:Any] {
                    if(((dictFromJSON["senderId"] as! NSNumber).intValue) == self?.userData?.user_id ?? 0){
                        if(((dictFromJSON["isOnline"] as! NSNumber).intValue) == 1){
                            self?.onlineOfflineLabel.text = "Online"
                            self?.onlineStatusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.8156862745, blue: 0.537254902, alpha: 1)
                        }else{
                            
                            self?.onlineOfflineLabel.text = "Offline"
                            self?.onlineStatusImageView.backgroundColor = #colorLiteral(red: 0.5777416825, green: 0.5874431133, blue: 0.6538439393, alpha: 1)
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
        SocketHelper.Events.newMessage.listen { [weak self] (result) in
            print(result)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
               
                
                if let dictFromJSON = decoded as? [String:Any] {
                    if self?.receiverId == dictFromJSON["senderId"] as? Int{
                        let  param = ["senderId":self?.receiverId ?? 0 ,
                                      "receiverId":Utility.getCurrentUserId(),
                                      "messageId":dictFromJSON["messageId"] as? Int ?? 0] as [String:Any]
                        SocketHelper.Events.ReadMessage.emit(params: param)
                        let newMessage = MessageData(id: 0, senderId: dictFromJSON["senderId"] as? Int, receiverId: dictFromJSON["receiverId"] as? Int, type: dictFromJSON["type"] as? Int, message: dictFromJSON["message"] as? String, createdAt: dictFromJSON["createdAt"] as? Int, seen: 1, postDetails: nil, mylibraryDetails: nil)
                        
                        self?.addNewElementIntoDictionary(model:MessageData(id: 0, senderId: dictFromJSON["senderId"] as? Int, receiverId: dictFromJSON["receiverId"] as? Int, type: dictFromJSON["type"] as? Int, message: dictFromJSON["message"] as? String, createdAt: dictFromJSON["createdAt"] as? Int, seen: 1, postDetails: nil, mylibraryDetails: nil) , currentKey: dictFromJSON["createdAt"] as? Int ?? 0)
                        self?.chatDetailList.append(newMessage)
                        self?.chatDetailTableView.reloadData()
                        if self?.chatDetailList.count ?? 0 > 0{
                            self?.chatDetailTableView.scrollToBottom(with: true)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        offSocket()
        if isFromSuggested{            
            if messageNavigationType == MessageNavigationType.homeScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is HomeScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.detailScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is PostDetailScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.shareDetailScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is ReSharePostDetailScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.exploreScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is ExploreSelectedIntrestedScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.myLibraryScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is MyLibraryScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.profileScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is ProfileTabbarScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.likeScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is LikePostScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }else if messageNavigationType == MessageNavigationType.newUserScreen.rawValue{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller is MessageListScreen{
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            
            
//            if self.navigationController?.viewControllers[1] as? MessageListScreen != nil {
//            let chatViewController = self.navigationController?.viewControllers[1] as! MessageListScreen
//            if (chatViewController.isKind(of: MessageListScreen.classForCoder())){
//                self.navigationController?.popToViewController(chatViewController, animated: true)
//                return
//            }
//            }
            
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller is MessageListScreen{
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else if controller is HomeScreen{
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else if controller is LikePostScreen{
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else if controller is MyLibraryScreen {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else if controller is ProfileTabbarScreen{
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else if controller is ExploreSelectedIntrestedScreen{
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
            return
        }
       
        if isCheckNotification{
            Utility.setTabRoot()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        // attachMediabutton.isHidden = false
        if(messageTextView.text.trimmingCharacters(in: .whitespaces).isEmpty || (messageTextView.text == "Type a Message...")){
            Utility.showAlert(vc: self, message: "Please enter valid message.")
            return
        }
        else{
            sendMessage()
        }
    }
    
    @IBAction func onProfile(_ sender: UIButton) {
//        let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
//        let navVC = UINavigationController(rootViewController: tabVC)
//        tabVC.userId = receiverId
//        navVC.setViewControllers([tabVC], animated: false)
//        navVC.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = navVC
//        tabVC.selectedIndex = 3
       // appDelegate.window?.makeKeyAndVisible()
        
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
        vc.userId = receiverId
       // vc.superVC = self?.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onAttachment(_ sender: UIButton) {
        uploadDocumentOptionAlert(controller: self)
    }
    
    func offSocket() {
        SocketHelper.Events.newMessage.off()
//        SocketHelper.Events.statusOnline.off()
        SocketHelper.Events.DisplayTyping.off()
        SocketHelper.Events.removeTyping.off()
        SocketHelper.Events.addUser.off()
    }
    
    func sendMessage(){
        
        // uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        var parameter = [String:Any]()
        parameter = ["message":messageTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                     "senderId":Utility.getCurrentUserId(),
                     "receiverId":receiverId,
                     "type":1] as [String:Any]
        
        
        if SocketHelper.shared.checkConnection() {
            SocketHelper.Events.sendMessage.emit(params: parameter)
            let currentTimeStamp = Date().toMillis()!
            addNewElementIntoDictionary(model: MessageData(id: 0, senderId: Utility.getCurrentUserId(), receiverId: receiverId, type: 1, message: messageTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines), createdAt: Int(currentTimeStamp), seen: 1, postDetails: nil, mylibraryDetails: nil) , currentKey: Int(currentTimeStamp))
            self.chatDetailTableView.reloadData()
            self.chatDetailTableView.scrollToBottom(with: true)
            messageTextView.text = "Type a Message..."
            messageTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            attachmentButton.isHidden  = false
            sendButton.isHidden = true
            view.endEditing(true)
            let parameter = ["receiverId":receiverId] as [String:Any]
            SocketHelper.Events.removeTyping.emit(params: parameter)
        }else{
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    //MARK:- DELETE CHAT
    func deleteChat(){
//        self.deleteChatView.isHidden = true
//        let url = deleteChatUrl
//        let data = UserChatDelete(deleted_to: "\(recieverId)")
//        Utility.showIndecator()
//        MessageService.shared.deleteUserChat(parameters: data.toJSON(), url: url) { (statusCode, response) in
//            Utility.hideIndicator()
//            self.finalDictionary = []
//            self.chatDetailTableView.reloadData()
//        } failure: { (error) in
//            Utility.hideIndicator()
//            Utility.showAlert(vc: self, message: error)
//        }
    }
  //MARK:- GET MESSAGE LIST
    func getChatDetail(pageNumber:Int){
        let url = "\(chatDetailUrl)\(receiverId)?perPage=100&page=\(pageNumber)"
        Utility.showIndicator()
//        let data = userChatDetailRequest(id: "\(recieverId)")
        MessageService.shared.getChatDetail( url: url) { (statusCode, response) in
            Utility.hideIndicator()
            self.hasMorePages = true
            self.refreshControl.endRefreshing()
            if let data = response?.userdetailData{
                Utility.setImage(data.profile_pic, imageView: self.profileImageView)
                self.nameLabel.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
                self.receiverId = data.id ?? 0
                if data.is_online ?? false{
                    self.onlineStatusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.8365593553, blue: 0.6070920229, alpha: 1)
                    self.onlineOfflineLabel.text = "Online"
                }else{
                    self.onlineStatusImageView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
                    self.onlineOfflineLabel.text = "Offline"
                }
            }
            self.totalMessageArray.append(contentsOf: (response?.messageData)!)
            if(self.metaData == nil){
                Utility.hideIndicator()
                self.chatDetailList = []
                self.chatDetailList = response?.messageData ?? []
                
                self.metaData = response?.meta
                if response?.messageData?.count ?? 0 > 0{
                self.formatttedArray(dataArray: response?.messageData?.reversed() ?? [])
                self.chatDetailTableView.reloadData()
                    if self.chatDetailList.count > 0{
                        self.chatDetailTableView.scrollToBottom(with: false)
                    }
                }
            }else{
                
                self.chatDetailList.append(contentsOf: response?.messageData?.reversed() ?? [])
                self.formatttedArray(dataArray: self.chatDetailList)
                self.chatDetailTableView.reloadData()
                if self.chatDetailList.count > 0{
//                    self.chatDetailTableView.scrollToBottom(with: false)
                }
                
                //                let reverseDataArray = response?.messageData?.reversed()
                //                let datesArray = (reverseDataArray)?.compactMap { $0.createdAt } // return array of date
                //                var dic = [String:[MessageData]]() // Your required result
                //                datesArray?.forEach {
                //                    let dateKey = Utility.UTCToLocaltimeInterval(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)
                //                    let filterArray = (reverseDataArray)?.filter { Utility.UTCToLocaltimeInterval(date: $0.createdAt!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)  == dateKey }
                //                    dic[Utility.UTCToLocaltimeInterval(date: $0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)] = filterArray
                //                }
                //                print(dic)
                //                let componentArray = Array(dic.keys)
                //                for key in componentArray{
                //                    if self.filterDictionary.index(forKey: key) != nil {
                //                        var lastDateDictionaryArray = dic[key]!
                //                        lastDateDictionaryArray.append(contentsOf: self.filterDictionary[key]!)
                //                        self.filterDictionary[key] = lastDateDictionaryArray
                //                    }else{
                //                        var newArray = [MessageData]()
                //                        newArray.append(contentsOf: dic[key]!)
                //                        self.filterDictionary[key] = newArray
                //                    }
                //                }
                //                self.finalDictionary = []
                //                let fruitsTupleArray = self.filterDictionary.sorted { $0.key > $1.key }
                ////                for (key, value) in fruitsTupleArray {
                //
                //                    var keyName = key
                //                    let date = Date()
                //                    let df = DateFormatter()
                //                    df.dateFormat = MM_DD_YYYY
                //                    let dateString = df.string(from: date)
                //                    let calendar = Calendar.current
                //                    let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
                //                    let yesterdayDate = df.string(from: yesterday)
                //                    if dateString == keyName{
                //                        keyName = "Today"
                //                    }else if yesterdayDate == keyName{
                //                        keyName = "Yesterday"
                //                    }
                ////                    finalDictionary.append( SectionMessageData(headerDate: keyName, messageData: value))
                //                    self.finalDictionary.append( SectionMessageData(headerDate: keyName, messageData: value))
                //                }
                
                self.metaData = response?.meta
                self.chatDetailTableView.reloadData()
            }
        } failure: { (error) in
            self.refreshControl.endRefreshing()
            Utility.hideIndicator()
            Utility.showAlert(vc: self, message: error)
        }
        
    }
    
    func sendAttachment(type:Int, postId:String?, imageData:Data){
        if(Utility.isInternetAvailable()){
            Utility.showIndicator()
            
            let data = SendAttachment(receiver_id: "\(receiverId)", type: "\(type)", post_id: postId ?? "0")
            MessageService.shared.sendPhoto(parameters: data.toJSON(), imageData: imageData) { (status, response) in
                if let data = response?.chatAttachmentData{
                    let parameter = ["message":data.message ?? "",
                                     "senderId":Utility.getCurrentUserId(),
                                     "receiverId":data.receiver_id ?? 0,
                                     "type":data.message_type ?? 2] as [String:Any]
                    SocketHelper.Events.sendMessage.emit(params: parameter)
                    let currentTimeStamp = Date().toMillis()!
                    self.addNewElementIntoDictionary(model:MessageData(id: 0, senderId: Utility.getCurrentUserId(), receiverId: data.receiver_id ?? 0, type: type, message: data.message ?? "", createdAt: Int(currentTimeStamp), seen: 1, postDetails: nil, mylibraryDetails: nil) , currentKey: Int(currentTimeStamp))
                    self.chatDetailTableView.reloadData()
                    self.chatDetailTableView.scrollToBottom(with: true)
                }
                
                Utility.hideIndicator()
            } failure: { (string) in
                Utility.hideIndicator()
            }
        }else{
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //Show alert to selected the media source type.
        func uploadDocumentOptionAlert(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.getImage(fromSourceType: .camera)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: scroll method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.chatOptionButton.isSelected = false
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.chatDetailTableView && !decelerate {
            self.scrollingFinished()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollingFinished()
    }
    
    
    func scrollingFinished(){
        var visibleRect = CGRect()
        visibleRect.origin = self.chatDetailTableView.contentOffset
        visibleRect.size = self.chatDetailTableView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.chatDetailTableView.indexPathForRow(at: visiblePoint) else { return }
        if chatDetailTableView.contentOffset.y < 50 {
            if self.hasMorePages{
                if let metaTotal = self.metaData?.total{
                    if self.totalMessageArray.count != metaTotal{
                        print("called")
                        self.hasMorePages = false
                        self.page += 1
                        self.getChatDetail(pageNumber: page)
                    }
                }
            }
        }
        
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension ChatDetailScreen: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return finalDictionary.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ChatTimeTableViewCell") as! ChatTimeTableViewCell
//        header.timeLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        header.timeLabel.text = Utility.getLocalDateFromUTCForMessageHeader(timeInterval: finalDictionary[section].headerInterVal ?? 0)

        return header.contentView
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
       let dateString = finalDictionary[section]
        return (dateString.headerDate)
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateString = finalDictionary[section]
        return dateString.messageData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainArray = finalDictionary[indexPath.section]
        if let model = mainArray.messageData?[indexPath.row]{
            if model.receiverId == receiverId{
                if model.type == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "receiverTableViewCell", for: indexPath) as! receiverTableViewCell
                cell.setData(data: model)
                return cell
                }else if model.type == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverPhotoTableViewCell", for: indexPath) as! ReceiverPhotoTableViewCell
                    cell.setData(data: model)
                    return cell
                }else if model.type == 3{
                     let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostSenderTableViewCell", for: indexPath) as! BookPostSenderTableViewCell
                    cell.item  = model
                    return cell
                  }else if model.type == 4 || model.type == 5 || model.type == 6{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LinkPostSenderTableViewCell", for: indexPath) as! LinkPostSenderTableViewCell
                   cell.item  = model
                cell.onLinkClick = {[weak self ] in
                        let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                        control.linkUrl = model.postDetails?.link ?? ""
                        self?.navigationController?.pushViewController(control, animated: true)
                    }
                   return cell
                  }else if model.type == 7{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReshareSenderTableViewCell", for: indexPath) as! ReshareSenderTableViewCell
                   cell.item  = model
                    cell.onLinkClick = {[weak self ] in
                            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                            control.linkUrl = model.postDetails?.link ?? ""
                            self?.navigationController?.pushViewController(control, animated: true)
                        }
                   return cell
                    
                }else if model.type == 8{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FolderSenderTableViewCell", for: indexPath) as! FolderSenderTableViewCell
                   cell.item  = model
                   return cell
                    
                  }
            }else{
                if model.type == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
                    cell.setData(data: model)
                    return cell
                }else if model.type == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderPhotosTableViewCell", for: indexPath) as! SenderPhotosTableViewCell
                    cell.setData(data: model)
                    return cell
                }else if model.type == 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostReceiverTableViewCell", for: indexPath) as! BookPostReceiverTableViewCell
                    cell.item  = model
                    return cell
                }else if model.type == 4 || model.type == 5 || model.type == 6{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LinkPostReveiverTableViewCell", for: indexPath) as! LinkPostReveiverTableViewCell
                   cell.item  = model
                    cell.onLinkClick = {[weak self ] in
                            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                            control.linkUrl = model.postDetails?.link ?? ""
                            self?.navigationController?.pushViewController(control, animated: true)
                        }
                   return cell
                }else if model.type == 7{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReshareReciverTableViewCell", for: indexPath) as! ReshareReciverTableViewCell
                   cell.item  = model
                    cell.onLinkClick = {[weak self ] in
                            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                            control.linkUrl = model.postDetails?.link ?? ""
                            self?.navigationController?.pushViewController(control, animated: true)
                        }
                   return cell
                    
                }else if model.type == 8{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FolderReceiverTableViewCell", for: indexPath) as! FolderReceiverTableViewCell
                   cell.item  = model
                   return cell
                    
                  }
                
            }
        }
        return UITableViewCell()
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainArray = finalDictionary[indexPath.section]
        if let model = mainArray.messageData?[indexPath.row]{
            if model.type == 2{
            let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl =  model.message ?? ""
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self.present(confirmAlertController, animated: true, completion: nil)
            }else if model.type == 8{
//                Utility.showAlert(vc: self, message: "Comming soon")
                let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "PlayListDetailScreen") as! PlayListDetailScreen
                vc.myLibraryObj = model.mylibraryDetails
                vc.userId = model.mylibraryDetails?.user_id
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.type == 7{
                let reshareVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                reshareVC.postDetailData = model.postDetails
                reshareVC.postId = model.postDetails?.id ?? 0
                self.navigationController?.pushViewController(reshareVC, animated: true)
            }else{
                if let data = model.postDetails{
                    self.didSelectData(data: data)
                }
            }
        }
    }
    
    
    func didSelectData(data:PostReponse){
        
        if data.reshare == true{
            let reshareVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
            reshareVC.postDetailData = data
            reshareVC.postId = data.id ?? 0
            reshareVC.onBack = { [weak self] (data) in
//                if let obj = data{
//                    self?.itemArray[indexPath] = obj
//                    DispatchQueue.main.async {
//                        UIView.performWithoutAnimation {
//                            let loc = self?.postTableView.contentOffset
//                            self?.postTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .none)
//                            self?.postTableView.contentOffset = loc ?? .zero
//                        }
//                    }
//                }
            }
            reshareVC.onSuccessReport = { [weak self] in
//                self?.itemArray.remove(at: indexPath)
//                self?.postTableView.reloadData()
            }
            reshareVC.onUnFollowUser = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
//                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
            }
            
            self.navigationController?.pushViewController(reshareVC, animated: true)
        }else{
            let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
            vc.postId = data.id ?? 0
            vc.postDetailData = data
            vc.onBack = { [weak self] (data) in
                if let obj = data{
//                    self?.itemArray[indexPath] = obj
//                    DispatchQueue.main.async { [weak self] in
//                        UIView.performWithoutAnimation {
//                            let loc = self?.postTableView.contentOffset
//                            self?.postTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .none)
//                            self?.postTableView.contentOffset = loc ?? .zero
//                        }
//                    }
                }
            }
            vc.onSuccessReport = { [weak self] in
                UIView.performWithoutAnimation {
//                    let loc = self?.postTableView.contentOffset
//                    self?.itemArray.remove(at: indexPath)
//                    self?.postTableView.reloadData()
//                    self?.postTableView.contentOffset = loc ?? .zero
                }
            }
            vc.onUnFollowUser = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
//                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func formatttedArray(dataArray:[MessageData]){
        var sectionData: [SectionMessageData] = []
        for i in dataArray{
            let temp = dataArray.filter({Utility.compareDate(fromDate: $0.createdAt ?? 0, toDate: i.createdAt ?? 0) == true})
            for i in temp{
                if let index = sectionData.firstIndex(where: {Utility.compareDate(fromDate: $0.headerInterVal ?? 0, toDate: i.createdAt ?? 0) == true}){
                    if sectionData[index].messageData?.contains(where: {$0.id != i.id}) == true{
                        sectionData[index].messageData?.append(i)
                    }
                }else{
                    let dateKey = Utility.UTCToLocaltimeInterval(date: i.createdAt ?? 0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)
                    sectionData.append(SectionMessageData(headerInterVal: i.createdAt, headerDate: dateKey, messageData: temp))
                }
            }
        }
        sectionData.sort(by: {Utility.getDateTimeFromTimeInterVel(from: $0.headerInterVal ?? 0) < Utility.getDateTimeFromTimeInterVel(from: $1.headerInterVal ?? 0)})
        self.finalDictionary = sectionData
        print(sectionData)
    }
    
//    func addNewElementIntoDictionary(model:MessageData,currentKey: String){
//        var index = finalDictionary.count
//        if(index == 0){
//            index = 0
//        }else{
//            index = index - 1
//        }
//        if(finalDictionary.count == 0){
//            var newArray = [MessageData]()
//            newArray.append(model)
//            finalDictionary.append(SectionMessageData(headerDate: currentKey, messageData: newArray))
//        }else{
//            let object = finalDictionary[index]
//            if (object.headerDate == currentKey){
//                object.messageData?.append(model)
//            finalDictionary[index] = object
//        }else{
//            var newArray = [MessageData]()
//            newArray.append(model)
//            finalDictionary.append(SectionMessageData(headerDate: currentKey, messageData: newArray))
//        }
//        }
//    }
    
    
    func addNewElementIntoDictionary(model:MessageData,currentKey: Int){
    //        var index = finalDictionary.count
    //        if(index == 0){
    //            index = 0
    //        }else{
    //            index = index - 1
    //        }
    //        if(finalDictionary.count == 0){
    //            var newArray = [MessageData]()
    //            newArray.append(model)
    //            let dateKey = Utility.UTCToLocaltimeInterval(date: currentKey, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)
    //            finalDictionary.append(SectionMessageData(headerInterVal: currentKey, headerDate: dateKey, messageData: newArray))//SectionMessageData(headerDate: currentKey, messageData: newArray))
    //        }else{
    //            let object = finalDictionary[index]
    //            if (object.headerDate == currentKey){
    //                object.messageData?.append(model)
    //            finalDictionary[index] = object
    //        }else{
    //            var newArray = [MessageData]()
    //            newArray.append(model)
    //            finalDictionary.append(SectionMessageData(headerDate: currentKey, messageData: newArray))
    //        }
    //        }
            if let index = self.finalDictionary.firstIndex(where: {Utility.compareDate(fromDate: $0.headerInterVal ?? 0, toDate: currentKey) == true}){
                self.finalDictionary[index].messageData?.append(model)
            }else{
                let dateKey = Utility.UTCToLocaltimeInterval(date: currentKey, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)
                finalDictionary.append(SectionMessageData(headerInterVal: currentKey, headerDate: dateKey, messageData: [model]))
            }
        }
}

//MARK: - UIImagePickerControllerDelegate
extension ChatDetailScreen: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            self!.imageData = image.jpegData(compressionQuality:0.2)!
            self?.imageData = image.png(isOpaque: false)
            self?.sendAttachment(type: 2, postId: nil, imageData: self!.imageData!)
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
  
}

//MARK: - UITextViewDelegate
extension ChatDetailScreen:UITextViewDelegate{
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
////        view.endEditing(true)
//        return true
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.text == "Type a Message..."{
            messageTextView.text = ""
        }
        
        messageTextView.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
        let parameter = ["receiverId":receiverId] as [String:Any]
        SocketHelper.Events.typing.emit(params: parameter)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            messageTextView.text = "Type a Message..."
            messageTextView.textColor = #colorLiteral(red: 0.007843137255, green: 0.03137254902, blue: 0.03921568627, alpha: 1)
            sendButton.isHidden = true
            attachmentButton.isHidden  = false
            let parameter = ["receiverId":receiverId] as [String:Any]
            SocketHelper.Events.removeTyping.emit(params: parameter)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView == messageTextView){
//            textView.isScrollEnabled = true
            guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
                return false
            }
            if (text == "\n") {
//                sendButton.isHidden = true
//                attachmentButton.isHidden  = false
//                textView.resignFirstResponder()
            }
            let substringToReplace = textView.text[rangeOfTextToReplace]
            let count = textView.text.count - substringToReplace.count + text.count
            if(count > 0){
                sendButton.isHidden = false
                attachmentButton.isHidden  = true
            }
            else{
                sendButton.isHidden = true
                attachmentButton.isHidden  = false
            }
            return count >= 0 // Bool
        }
        return true
    }
}


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
}
