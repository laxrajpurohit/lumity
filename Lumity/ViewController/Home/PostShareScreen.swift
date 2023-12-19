//
//  PostShareScreen.swift
//  Source-App
//
//  Created by Nikunj on 04/04/21.
//

import UIKit
import PanModal
import FirebaseDynamicLinks
import LinkPresentation

class PostShareScreen: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var saveToLaterIcon: UIImageView!
    @IBOutlet weak var addToCompletedImageView: UIImageView!
    
    @IBOutlet weak var saveForLaterView: UIView!
    @IBOutlet weak var addToCompleteView: UIView!
    @IBOutlet weak var saveMainView: dateSportView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageStackView: UIStackView!
    
    @IBOutlet weak var messageMainView: dateSportView!
    
    @IBOutlet weak var messageHeightConstant: NSLayoutConstraint!
    
    var postItemDataDetailData:PostReponse?
    
    var onSendMessage: (() -> Void)?
    var onShareMessage: (() -> Void)?
    var onSendPostOnGroup: (() -> Void)?

    var isFromGroup = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        panModalSetNeedsLayoutUpdate()
//        panModalTransition(to: .shortForm)

        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 16
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if isFromGroup{
//            self.saveForLaterView.isHidden = true
//            self.addToCompleteView.isHidden = true
//            self.saveMainView.isHidden = true
            self.messageMainView.isHidden = true
            self.messageHeightConstant.constant = 0
        }
        // Do any additional setup after loading the view.
        initailDetail()
    }
    
    func initailDetail(){
        if let isSave = postItemDataDetailData?.user_is_saved{
            if isSave == 1{
                self.saveToLaterIcon.image = UIImage(named: "is_save_selected_icon")
            }else{
                self.saveToLaterIcon.image = UIImage(named: "save_to_ater_icon")
            }
        }
        if let isCompleted = postItemDataDetailData?.user_is_complete{
            if isCompleted == 1{
                self.addToCompletedImageView.image = UIImage(named: "completedlist_icon")
            }else{
                self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        panModalSetNeedsLayoutUpdate()
    }

  
     // MARK: - ACTIONS
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSendDirectMessage(_ sender: Any) {
//        Utility.showAlert(vc: self, message: "working in progress")
        self.dismiss(animated: true, completion: { [weak self] in
            self?.onSendMessage?()
        })
    }
   
    @IBAction func onSendPostGroup(_ sender: Any) {
//        Utility.showAlert(vc: self, message: "working in progress")
        self.dismiss(animated: true, completion: { [weak self] in
            self?.onSendPostOnGroup?()
        })
    }
    
    
    @IBAction func onSharePost(_ sender: UIButton) {
        self.dynamicLink()
    }
    
    @IBAction func onSaveOrLater(_ sender: Any) {
        var isSave = 0
        if postItemDataDetailData?.user_is_saved == 0{
            isSave = 1
            postItemDataDetailData?.user_is_saved = 1
            self.saveToLaterIcon.image = UIImage(named: "is_save_selected_icon")
        }else{
            isSave = 0
            postItemDataDetailData?.user_is_saved = 0
            self.saveToLaterIcon.image = UIImage(named: "save_to_ater_icon")
        }
            
        self.saveForLater(postId: postItemDataDetailData?.id ?? 0, isSave: isSave , isCompleted: nil)//postItemDataDetailData?.user_is_complete ?? 0)
    }
    
    @IBAction func onCompleted(_ sender: Any) {
        
        var isCompleted = 0
        if postItemDataDetailData?.user_is_complete == 0{
            isCompleted = 1
            postItemDataDetailData?.user_is_complete = 1
            self.addToCompletedImageView.image = UIImage(named: "completedlist_icon")
        }else{
            isCompleted = 0
            postItemDataDetailData?.user_is_complete = 0
            self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
        }
        
        self.saveForLater(postId: postItemDataDetailData?.id ?? 0, isSave: nil, isCompleted: isCompleted)// postItemDataDetailData?.user_is_saved ?? 0 , isCompleted: isCompleted)
        
    }
    
     // MARK: - API CALL
    func saveForLater(postId: Int,isSave: Int?,isCompleted:Int?){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            var data = [String:Any]()
            if isFromGroup{
                let GroupRequestData = GroupsaveComplatePostRequest(group_post_id: postItemDataDetailData?.groupPostId, is_saved: isSave, is_complete: isCompleted)
                data = GroupRequestData.toJSON()
            }else{
                let requestData = saveComplatePostRequest(post_id: postId, is_saved: isSave, is_complete: isCompleted)
                data = requestData.toJSON()
            }
           
            PostService.shared.doSaveCompletedPost(parameters: data, isFromGroup: self.isFromGroup) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
//                self?.changeJoinStatus(userId: userId,status: status)
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
   
     // MARK: - DYNAMIC LINK
    func dynamicLink(){
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.lumityapp.com"
        
        var itemIDQueryItem1 = URLQueryItem(name: "", value: "")
        
        components.path = PATH_POST
        if postItemDataDetailData?.reshare == true{
            itemIDQueryItem1 = URLQueryItem(name: POST_RESHARE_ID, value: "\(self.postItemDataDetailData?.id ?? 0)")
        }else{
            itemIDQueryItem1 = URLQueryItem(name: POST_ID, value: "\(self.postItemDataDetailData?.id ?? 0)")
        }
       
        components.queryItems = [itemIDQueryItem1]
        
        guard let linkParameter = components.url else { return }
        print("I am sharing \(linkParameter.absoluteString)")
        
        let dynamicLinksDomainURIPrefix = "https://lumityapp.page.link"
        guard let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: dynamicLinksDomainURIPrefix)  else { return }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // 2
        linkBuilder.iOSParameters?.appStoreID = "1565191495"
        // 3
        
        guard let longURL = linkBuilder.url else { return }
        print("The long dynamic link is \(longURL.absoluteString)")
        
        linkBuilder.shorten { url, warnings, error in
            if let error = error {
                print("Oh no! Got an error! \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }
            guard let url = url else { return }
//            self.stringForShare = url.absoluteString
            
            print("I have a short url to share! \(url.absoluteString)")
            self.activityAlert(url: URL(string: (url.absoluteString )))
            //self.shareItem(with: url)
        }
    }
    
    // MARK: - SHARE DILOG
    func activityAlert(url:URL?){
//        let promoText//"You have been invited to this. "
        if let name = url, !name.absoluteString.isEmpty {
            let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                if completed {
                    // User completed activity
                    print("Activity completed")
                    self.dismiss(animated: true, completion: { [weak self] in
                        self?.onShareMessage?()
//                        Utility.showAlert(vc: self!, message: "Thanks for sharing")

                    })

//                    self.dismiss(animated: true)
//                    Utility.showAlert(vc: self, message: "Thanks for sharing")
                } else {
                    // User cancelled
                    print("Activity cancelled")
                }
            }
            self.present(activityVC, animated: true) {
            }
        } else {
          // show alert for not available
        }
    }
    
}

 // MARK: - PRESENT BOTTOM SHEET
extension PostShareScreen: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        return self.isFromGroup == true ? .contentHeight(180):.contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return self.isFromGroup == true ? .contentHeight(180):.contentHeight(300)
    }
    
    var allowsExtendedPanScrolling: Bool{
        return true
    }
    
    var showDragIndicator: Bool{
        return false
    }
    
    
//    var panModalBackgroundColor: UIColor{
//        return Utility.getUIcolorfromHex(hex: "eaeaea")
//    }
}
