//
//  PostDetailScreen.swift
//  Source-App
//
//  Created by Nikunj on 04/04/21.
//

import UIKit
import ExpandableLabel
import KTCenterFlowLayout
import LinkPresentation
import PanModal
import IQKeyboardManagerSwift

class PostDetailScreen: UIViewController {
    // IBOutlet declarations: UI components connected from Storyboard.
    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var intrestedCollectionView: UICollectionView!
    @IBOutlet weak var replyCommentTextView: UITextView!
    @IBOutlet weak var commentPlaceHolder: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var linkView: dateSportView!
    @IBOutlet weak var postImageHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var intresetedCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var readMoreLineView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    
    // Variables declaration: Various variables for data management and UI control.
    var intrestItemArray: [String] = []
    var commentArray:[CommentResponse] = []
    var postId: Int?
    var page: Int = 1
    var meta: Meta?
    var hasMorePage: Bool = false
    var isFromReShare: Bool = false
    var postDetailData:PostReponse?
    var superVC: TabBarScreen?
    var onSuccessReport: (() -> Void)?
    var onUnFollowUser: (() -> Void)?
    var onBack:((_ data: PostReponse?) -> Void)?
    var isFromNotification = false
    var backSuperVC: UIViewController?
    var completeAddNewPostDelegate: EnterNewPostDelegate?

    var mainCommentArray: [CommentResponse] = []
    var itemArray: [CommentResponse] = []
    var postCommentId: Int?
    var commentReplyID: Int?
    var groupPostId: Int?
    var groupId: Int?
    
    // viewDidLoad: Initial setup when view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        self.commentTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // viewWillAppear: Called before the view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // viewWillDisappear: Called before the view disappears.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postDetailData?.comment_count = Int(self.commentCountLabel.text ?? "0")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // initializeDetails: Sets up initial UI components and data.
    func initializeDetails(){
        self.replyButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 4)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.commentTableView.register(UINib(nibName: "CommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCell")
        self.intrestedCollectionView.register(UINib(nibName: "InterestCell", bundle: Bundle.main), forCellWithReuseIdentifier: "InterestCell")
        self.commentTableView.register(UINib(nibName: "CommentReplyCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentReplyCell")
        self.commentTableView.register(UINib(nibName: "ReplyMoreCell", bundle: Bundle.main), forCellReuseIdentifier: "ReplyMoreCell")
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
//        self.replyPostCommentTextField.delegate = self
        
        if let postData = postDetailData{
            self.postDetailDataSet(data: postData)
        }else if let postId = self.postId{
            self.postDetailAPI(postId: postId)
        }else if let postId = self.groupPostId{
            self.postDetailAPI(postId: nil)
        }
        self.replyCommentTextView.delegate = self
//        self.getPostCommentAPI(postId: postId)
        self.getPostComments()
    }
    
    // postDetailDataSet: Sets the data for the post details.
    func postDetailDataSet(data:PostReponse){
        self.postDetailData = data
        Utility.setImage(data.userDetails?.profile_pic, imageView: self.profileImageView)
        self.headLineLabel.text = data.userDetails?.headline ?? " "
        self.ratingLabel.text = "\(data.rate ?? 0)/5"
        
        self.captionLabel.text = data.caption
        
        if data.post_type != 5{
            if Utility.lines(label: captionLabel) < 4{
                self.readMoreButton.isHidden = true
                self.readMoreLineView.isHidden = true
            }else{
                self.readMoreButton.isHidden =  false
                self.readMoreLineView.isHidden = false
            }
            self.captionLabel.numberOfLines = 3
        }else{
            self.readMoreButton.isHidden = true
            self.readMoreLineView.isHidden = true
        }
        
        
        if data.rate == 0 || data.rate == nil{
            self.ratingLabel.isHidden = true
            self.startImageView.isHidden = true
        }else{
            self.ratingLabel.text = "\(data.rate ?? 0)/5"
            self.ratingLabel.isHidden = false
            self.startImageView.isHidden = false
        }
        
        if let date = data.created_at{
            let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
            self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
        }
        
        self.userNameLabel.text = "\(data.userDetails?.first_name ?? "") \(data.userDetails?.last_name ?? "")"
        
//        self.setExpandLabel(text: data.caption ?? "")
        
        if let isLike = data.is_like{
            if isLike{
                likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
            }else{
                likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
            }
        }
        self.likeCountLabel.text = "\(data.like_count ?? 0)"
        self.shareCountLabel.text = "\(data.reshare_count ?? 0)"
        self.commentCountLabel.text = "\(data.comment_count ?? 0)"
        if data.post_type == 1 ||  data.post_type == 4 || data.post_type == 2{
            if !self.linkView.subviews.contains(where: {$0.tag == data.id ?? 0}){
                if let link = data.link{
                    self.loadLinkView(link: link)
                }
            }
            self.linkView.isHidden = false
            self.postImageView.isHidden = true
            self.postImageHeightConstant.constant = 200
        }else if data.post_type == 5{
            self.linkView.isHidden = true
            self.postImageView.isHidden = true
            self.shareButton.isHidden = true
            self.postImageHeightConstant.constant = 0
        }else{
            self.linkView.isHidden = true
            self.postImageView.isHidden = false
            self.postImageHeightConstant.constant = 400
            Utility.setImage(data.media, imageView: self.postImageView)
        }
        
//        if self.groupPostId != nil{
//            self.moreOptionButton.isHidden = true
//        }else{
//            self.moreOptionButton.isHidden = false
//        }
        
        if let arr = data.interest,data.interest?.count ?? 0 > 0{
            self.intrestItemArray = arr
            self.intrestedCollectionView.reloadData()
            self.intresetedCollectionViewHeight.constant = 40
        }else{
            self.intresetedCollectionViewHeight.constant = 30
        }
        
//        if data.post_type == 1{
//            postTypeImageView.image = UIImage(named: "book_icon")
//        }else if data.post_type == 2{
//            postTypeImageView.image = UIImage(named: "podcast_icon")
//        }else if data.post_type == 3{
//            postTypeImageView.image = UIImage(named: "book_icon")
//        }else{
//            postTypeImageView.image = UIImage(named: "book_icon")
//        }
        
        if data.post_type == 1{
            postTypeImageView.image = UIImage(named: "podcast_icon")
        }else if data.post_type == 2{
            postTypeImageView.image = UIImage(named: "video_icon")
        }else if data.post_type == 3{
            postTypeImageView.image = UIImage(named: "book_icon")
        }else if data.post_type == 5{
            postTypeImageView.image = UIImage(named: "text_icon")
        }else{
            postTypeImageView.image = UIImage(named: "article_icon")
            linkButton.isHidden = false
        }
    }
    
    // loadLinkView: Loads a view for a link.
    func loadLinkView(link: String){
//        self.view.addSubview(activityIndicatorView)
//        activityIndicatorView.startAnimating()
        Utility.loadLinkView(view: self.linkView)
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, metaData) in
            guard let strongSelf = self else {
                return
            }
            guard let meta = metaData else {
                return
            }
            if self?.postDetailData?.link == link{
                let linkMetaView = LPLinkView(metadata: meta)
                linkMetaView.tag = self?.postDetailData?.id ?? 0
                strongSelf.linkView.addSubview(linkMetaView)
                linkMetaView.frame = CGRect(x: 0, y: 0, width: screenWidth - 20, height: 200)
            }
            Utility.hideLinkLoadView(view: strongSelf.linkView)
//            activityIndicatorView.stopAnimating()
//            strongSelf.linkView.borderColor = .clear
        }
    }
    
    // @IBAction functions: Actions for various button presses in the UI.
    @IBAction func onUser(_ sender: Any) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
        vc.userId = self.postDetailData?.user_id
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        if isFromNotification{
            Utility.setTabRoot()
        }else{
            if !isFromReShare{
                self.onBack?(self.postDetailData)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onLinkClick(_ sender: UIButton) {
        let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
        control.linkUrl = postDetailData?.link ?? ""
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onReadMore(_ sender: UIButton) {
        self.captionLabel.numberOfLines = 0
        self.readMoreButton.isHidden = true
        self.readMoreLineView.isHidden = true
    }
    
    
    
    func goFurtherPostEdit(postObj: PostReponse){
        switch postObj.post_type {
        case PostType.podcast.rawValue:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
            vc.superVC = self.backSuperVC
            vc.postObj = postObj
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case PostType.video.rawValue:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
            vc.superVC = self.backSuperVC
            vc.postObj = postObj
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case PostType.book.rawValue:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
            vc.superVC = self.backSuperVC
            vc.postObj = postObj
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "TextPostScreen") as! TextPostScreen
            vc.superVC = self.backSuperVC
            vc.postObj = postObj
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
            vc.superVC = self.backSuperVC
            vc.postObj = postObj
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    @IBAction func onMoreOption(_ sender: Any) {
        if Utility.getCurrentUserId() == self.postDetailData?.user_id{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "DeletePostScreen") as! DeletePostScreen
            vc.onDelete = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                guard let postObj = strongSelf.postDetailData else {
                    return
                }
                strongSelf.deletePostAlert(postObj: postObj)
            }
            vc.onEdit = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                guard let postObj = strongSelf.postDetailData else {
                    return
                }
                strongSelf.goFurtherPostEdit(postObj: postObj)
            }
            let rowVC: PanModalPresentable.LayoutType = vc
            self.navigationController?.presentPanModal(rowVC)
        }else{
            let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
            vc.postItemDataDetailData = postDetailData
            vc.onReportPost = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.postId = self?.postDetailData?.id
                vc.groupPostId = self?.postDetailData?.groupPostId
                vc.onSuccessReport = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                    vc.modalPresentationStyle = .overCurrentContext
                    
                    vc.onClose = { [weak self] in
                        self?.onSuccessReport?()
                        self?.navigationController?.popViewController(animated: false)
                    }
                    
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                }
                
                self?.navigationController?.present(vc, animated: true, completion: nil)
            }
            
            vc.onUnfollowUser = { [weak self] in
                self?.onUnFollowUser?()
                self?.navigationController?.popViewController(animated: false)
            }
            
            let rowVC: PanModalPresentable.LayoutType = vc
            self.navigationController?.presentPanModal(rowVC)
        }
    }
    
    // deletePostAlert: Shows an alert for post deletion.
    func deletePostAlert(postObj: PostReponse){
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: { [weak self] (alert) in
            self?.deletePostAPI(postObj: postObj)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // deletePostAPI: API call to delete a post.
    func deletePostAPI(postObj: PostReponse){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            
//             let id = postObj.id ?? 0
//
//            guard let groupPostId = postObj.groupPostId else {
//                return
//            }
            
            let postId = groupPostId == nil ? postObj.id:groupPostId
            
            PostService.shared.deletePost(id: postId ?? 0,isGroup:  groupPostId == nil ? false:true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isFromNotification{
                    Utility.setTabRoot()
                }else{
                    if !strongSelf.isFromReShare{
                        strongSelf.onBack?(strongSelf.postDetailData)
                    }
                   
                    if self?.completeAddNewPostDelegate != nil{
                        self?.completeAddNewPostDelegate?.uploadNewPost()
                    }
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            } failure: { [weak self] (error) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
                Utility.showAlert(vc: strongSelf, message: error)
            }

            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    
    @IBAction func onLike(_ sender: Any) {
//        if let isLike = postDetailData?.is_like{
//            if isLike{
//                return
//            }
//        }
        doLikeAPI(postId: postId, islike: postDetailData?.is_like == false ? 1 : 2)
    }
    @IBAction func onLikeCount(_ sender: Any) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
        vc.modalPresentationStyle = .overCurrentContext
        vc.postId = self.postDetailData?.id ?? 0
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onReShare(_ sender: Any) {
        let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
        vc.modalPresentationStyle = .fullScreen
        vc.postObject = self.postDetailData
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func onReShareCount(_ sender: Any) {
      
    }
    
    @IBAction func onComment(_ sender: Any) {
      
    }
    @IBAction func onCommentCount(_ sender: Any) {
      
    }
    
    @IBAction func onPreviewPhoto(_ sender: UIButton) {
        let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
        confirmAlertController.imageUrl =  postDetailData?.media ?? ""
            confirmAlertController.modalPresentationStyle = .overFullScreen
            self.present(confirmAlertController, animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostShareScreen") as! PostShareScreen
        vc.postItemDataDetailData = postDetailData
        vc.isFromGroup = self.groupPostId != nil
        vc.onSendMessage = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
            vc.postItemDataDetailData = self?.postDetailData
            vc.messageNavigationType = MessageNavigationType.detailScreen.rawValue
            self?.navigationController?.pushViewController(vc, animated: true)
//                    strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
        }
        vc.onShareMessage = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            Utility.showAlert(vc: strongSelf, message: "Your message has been sent. Thank you for sharing!")
        }
        let rowVC: PanModalPresentable.LayoutType = vc
        self.navigationController?.presentPanModal(rowVC)
    }
    
    @IBAction func onReply(_ sender: UIButton) {
        if self.replyCommentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            if self.postCommentId == nil{
                Utility.showAlert(vc: self, message: "Please enter reply")
            }else{
                Utility.showAlert(vc: self, message: "Please enter comment")
            }
            return
        }
        if let id = self.postCommentId{
            self.replyComment(postCommentId: id)
        }else{
            self.commentPost()
        }
//        doCommentAPI(postId: postId)
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
                self.hasMorePage = false
                self.getPostComments()
            }
        }
    }
    
    //MARK:- POST API
    func postDetailAPI(postId:Int?){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            PostService.shared.getPostDetail(postId: postId ?? nil,groupPostId:groupPostId) { (statusCode, response) in
                Utility.hideIndicator()
                if let data = response.postDetail{
                    self.postDetailData = data
                    self.postDetailDataSet(data: data)
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
    
    //MARK: - DO COMMENT LIKE API
    func doCommentLikeAPI(commentId:Int,islike:Int,isReply: Bool){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let parameter = doCommentLikeRequest(comment_id: commentId, islike: islike)
            PostService.shared.doLikeOnComment(parameters: parameter.toJSON(),iSFromGroup: self.groupPostId == nil ? false:true) { (statusCode, response) in
//                Utility.hideIndicator()
                var isLikeStatus = false
                if islike == 1{
                    isLikeStatus = true
                }else{
                    isLikeStatus = false
                }
                self.changeLikeStatus(postId: commentId, isLike:isLikeStatus ,isReply: isReply)
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }

        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - Change like status
    func changeLikeStatus(postId: Int,isLike: Bool,isReply: Bool){
        if isReply == true{
            if let index = self.itemArray.firstIndex(where: {$0.replayId == postId}){
                if isLike{
                    self.itemArray[index].like_count! += 1
                }else{
                    self.itemArray[index].like_count! -= 1
                }
                self.itemArray[index].is_like = isLike
                if let cell = self.commentTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CommentReplyCell{
                    let isLike = self.itemArray[index].is_like ?? false
                    cell.likeCountLabel.text = "\(self.itemArray[index].like_count ?? 0)"
                    if isLike{
                        cell.likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                    }else{
                        cell.likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
                    }
                }
            }
        }else{
            if let index = self.itemArray.firstIndex(where: {$0.id == postId}){
                if isLike{
                    self.itemArray[index].like_count! += 1
                }else{
                    self.itemArray[index].like_count! -= 1
                }
                self.itemArray[index].is_like = isLike
                if let cell = self.commentTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CommentCell{
                    let isLike = self.itemArray[index].is_like ?? false
                    cell.likeCountLabel.text = "\(self.itemArray[index].like_count ?? 0)"
                    if isLike{
                        cell.likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                    }else{
                        cell.likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
                    }
                }
                
            }
        }
    }
    
    //MARK:- DO LIKE API
    func doLikeAPI(postId:Int?,islike:Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let parameter = doLikeRequest(post_id: postId, islike: islike, group_post_id: groupPostId)
            PostService.shared.doLikeOnPost(parameters: parameter.toJSON(),isGroupLike: groupPostId == nil ? false:true) { (statusCode, response) in
//                Utility.hideIndicator()
                if islike == 1{
                    self.postDetailData?.like_count! += 1
                    self.postDetailData?.is_like = true
                    self.likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                }else{
                    self.postDetailData?.like_count! -= 1
                    
                    self.postDetailData?.is_like = false
                    self.likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
                }
                self.likeCountLabel.text = "\(self.postDetailData?.like_count ?? 0)"
                self.commentCountLabel.text = "\(self.postDetailData?.comment_count ?? 0)"
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }

        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    // deleteCommentAlert: Shows an alert for comment deletion.
    func deleteCommentAlert(commentObj: CommentResponse){
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete?",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        self.dismiss(animated: true, completion: { [weak self] in
                                            self?.deletePostComment(commentObj: commentObj)
                                        })
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // deletePostComment: API call to delete a comment.
    func deletePostComment(commentObj: CommentResponse){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            var id = 0
            if let replyID = commentObj.replayId{
                id = replyID
            }else if let commentID = commentObj.id{
                id = commentID
            }
            PostService.shared.deleteCommentPost(comment_id: id) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
//                strongSelf.page = 1
//                strongSelf.getPostCommentAPI(postId: strongSelf.postId)
                if let replyId = commentObj.replayId{
                    strongSelf.removeReply(id: replyId)
                }else if let commentId = commentObj.id{
                    strongSelf.removeComment(id: commentId)
                }
                if let count = response.commentCountResponse?.comment_count{
                    self?.commentCountLabel.text = "\(count)"
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
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension PostDetailScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableViewHeight.constant = tableView.contentSize.height
        if self.itemArray[indexPath.row].isMore == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyMoreCell", for: indexPath) as! ReplyMoreCell
            return cell
        }
        if self.itemArray[indexPath.row].replayId == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.item = self.itemArray[indexPath.row]
            cell.onClickReply = { [weak self] in
                if let postCommentId = self?.itemArray[indexPath.row].id{
                    self?.postCommentId = postCommentId
                }else if let groupPostId = self?.itemArray[indexPath.row].group_post_comment_id{
                    self?.postCommentId = groupPostId
                }
                self?.commentPlaceHolder.text = "Reply to comment..."
                self?.replyCommentTextView.becomeFirstResponder()
            }
            
            cell.onLike = {[weak self] in
    //            if self?.commentArray[indexPath.row].is_like == true{
    //                return
    //            }
                let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                self?.doCommentLikeAPI(commentId:  self?.itemArray[indexPath.row].id ?? 0 , islike: islike,isReply: false)
            }
            
            cell.onUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].user_id
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
                
            cell.onMore = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "CommentReportScreen") as! CommentReportScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.commentObj = self?.itemArray[indexPath.row]
                vc.onReportComment = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.postId = self?.itemArray[indexPath.row].id
                    vc.groupPostCommentId = self?.groupPostId == nil ? nil:self?.itemArray[indexPath.row].id
                    vc.isFromComment = true
                    vc.onSuccessReport = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                        vc.modalPresentationStyle = .overCurrentContext
//                        self?.commentArray.remove(at: indexPath.row)
//                        self?.commentTableView.reloadData()
//                        if let replyId = self?.itemArray[indexPath.row].replayId{
//                            self?.removeReply(id: replyId)
//                        }else
                        if let commentId = self?.itemArray[indexPath.row].id{
                            self?.removeComment(id: commentId)
                        }
                        
                        self?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                    
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                }
                vc.onDelete = { [weak self] in
                    guard  let strongSelf = self else {
                        return
                    }
                    strongSelf.deleteCommentAlert(commentObj: strongSelf.itemArray[indexPath.row])
                }
                
                self?.navigationController?.present(vc, animated: true, completion: nil)
            }
            
            cell.onLikeCount = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.postId = self?.itemArray[indexPath.row].id ?? 0
                vc.isFromCommentLike = true
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        //MARK:- REPLY
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentReplyCell", for: indexPath) as! CommentReplyCell
        cell.item = self.itemArray[indexPath.row]
        cell.onClickReply = { [weak self] in
            self?.postCommentId = self?.itemArray[indexPath.row].id
            self?.commentReplyID = self?.itemArray[indexPath.row].replayId
            self?.commentPlaceHolder.text = "Reply to comment..."
            self?.replyCommentTextView.becomeFirstResponder()
        }
        
        cell.onLike = {[weak self] in
//            if self?.commentArray[indexPath.row].is_like == true{
//                return
//            }
            let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
            self?.doCommentLikeAPI(commentId:  self?.itemArray[indexPath.row].replayId ?? 0 , islike: islike,isReply: true)
        }
        
        cell.onUser = { [weak self] in
            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
            vc.userId = self?.itemArray[indexPath.row].user_id
            vc.superVC = self?.superVC
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.onMore = { [weak self] in
            let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "CommentReportScreen") as! CommentReportScreen
            vc.modalPresentationStyle = .overCurrentContext
            vc.commentObj = self?.itemArray[indexPath.row]
            vc.onReportComment = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.postId = self?.itemArray[indexPath.row].replayId
                vc.isFromComment = true
                vc.onSuccessReport = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                    vc.modalPresentationStyle = .overCurrentContext
                    if let replyId = self?.itemArray[indexPath.row].replayId{
                        self?.removeReply(id: replyId)
                    }
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                }
                
                self?.navigationController?.present(vc, animated: true, completion: nil)
            }
            vc.onDelete = { [weak self] in
                guard  let strongSelf = self else {
                    return
                }
                strongSelf.deleteCommentAlert(commentObj: strongSelf.itemArray[indexPath.row])
            }
            
            self?.navigationController?.present(vc, animated: true, completion: nil)
        }
        
        cell.onLikeCount = { [weak self] in
            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
            vc.modalPresentationStyle = .overCurrentContext
            vc.postId = self?.itemArray[indexPath.row].replayId ?? 0
            vc.isFromCommentLike = true
            vc.superVC = self?.superVC
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableViewHeight.constant = tableView.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.itemArray[indexPath.row].isMore == true{
            self.getPostCommentReply(commentID: self.itemArray[indexPath.row].id ?? 0)
        }
    }
}

//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension PostDetailScreen: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.intrestItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // self.intresetedCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intrestedCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.intrestItemArray[indexPath.row]
        cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.intrestItemArray[indexPath.row]
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
        vc.searhText = data
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.intrestItemArray[indexPath.row])
        return CGSize(width: width + 16, height: 32)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            self.commentViewBottom.constant = (keyboardSize.height - bottomSafeArea)
            self.view.layoutIfNeeded()
            print("Keyboard Height  :-",keyboardSize.height)

            print("View Bottom :-",self.commentViewBottom.constant)
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
            self.commentViewBottom.constant = 0
            self.view.layoutIfNeeded()
    }
}

//MARK: - TEXTFIELD DELEGATE
extension PostDetailScreen: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - EXPANDABLE DELEGATE
extension PostDetailScreen: ExpandableLabelDelegate{
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
    }
}

//MARK: - TEXTVIEW DELEGATE
extension PostDetailScreen: UITextViewDelegate{
       
    func textViewDidChange(_ textView: UITextView) {
        self.commentPlaceHolder.isHidden = self.replyCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
//MARK: - COMMENT/REPLAY
extension PostDetailScreen{
    
    //MARK: - Get POST Comments API
    func getPostComments(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            var data: [String: Any] = [:]
            if let lastCommentId = self.mainCommentArray.last?.id{
                data = GetCommentsRequest(group_post_id: self.groupPostId,id: postId,prePage: 10,lastId: lastCommentId).toJSON()
            }else if let lastCommentId = self.mainCommentArray.last?.group_post_comment_id{
                data = GetCommentsRequest(group_post_id: self.groupPostId,id: postId,prePage: 10,lastId: lastCommentId).toJSON()
            }else{
                data = GetCommentsRequest(group_post_id: self.groupPostId,id: postId,prePage: 10,lastId: 0).toJSON()
            }
            print(data)
            PostService.shared.getPostComments(parameters: data,isGroup: self.groupPostId == nil ? false : true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response.commentResponse,(response.commentResponse?.count ?? 0) > 0{
                    self?.hasMorePage = true
                    if self?.mainCommentArray.count == 0{
                        self?.mainCommentArray = res
                        self?.manageCommentArray()
                    }else{
                        self?.mainCommentArray.append(contentsOf: res)
                        self?.manageCommentArray()
                    }
                }
                if let count = response.comment_count{
                    self?.commentCountLabel.text = "\(count)"
                }
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }
    }
    
    //MARK: - COMMENT MANAGE
    func manageCommentArray(){
        var commentArray: [CommentResponse] = []
        for i in self.mainCommentArray{
            commentArray.append(i)
            if let reply = i.replies{
                for j in reply{
                    commentArray.append(j)
                }
                if (i.repliesCount ?? 0) > reply.count && reply.count == 2{
                    commentArray.append(self.createNillCommentForMore(commentId: reply.first?.id ?? 0,repliesCount: i.repliesCount ?? 0))
                }
            }
        }
        self.itemArray = commentArray
        let loc = self.commentTableView.contentOffset
        self.commentTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.commentTableView.setContentOffset(loc, animated: true)
        })
    }
    
    func createNillCommentForMore(commentId: Int,repliesCount: Int) -> CommentResponse{
        let postComment = CommentResponse()
        postComment.id = commentId
        postComment.user_id = nil
        postComment.username = nil
        postComment.post_id = nil
        postComment.comment = nil
        postComment.is_like = nil
        postComment.like_count = nil
        postComment.created_at = nil
        postComment.userDetails = nil
        
        postComment.repliesCount = repliesCount
        postComment.replies = nil
        
        postComment.replayId = nil
        postComment.isMore = true
        
        return postComment
    }
    
    //MARK: - POST COMMENT
    func commentPost(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = AddCommentRequest(group_post_id: self.groupPostId, post_id: self.postId, comment: self.replyCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            PostService.shared.addComment(parameters: data.toJSON(),iSFromGroup: self.groupPostId == nil ? false:true ) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response.postCommentResponse{
                    self?.addNewComment(obj: res)
                    self?.refreshComment()
                }
                if let count = response.postCommentResponse?.comment_count{
                    self?.commentCountLabel.text = "\(count)"
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
    
    //MARK: - ADD NEW COMMENT
    func addNewComment(obj: CommentResponse){
        let mainArr = self.mainCommentArray
        var commentArr: [CommentResponse] = []
        commentArr.append(obj)
        for i in mainArr{
            commentArr.append(i)
        }
        self.mainCommentArray = commentArr
        self.manageCommentArray()
    }
    
    //MARK: - REFRESH COMMENT
    func refreshComment(){
        self.replyCommentTextView.text = nil
        if self.postCommentId == nil{
            self.commentPlaceHolder.text = "Reply to post..."
        }else{
            self.commentPlaceHolder.text = "Reply to comment..."
        }
        self.commentPlaceHolder.isHidden = false
    }
    
    //MARK: - REPLY COMMENT
    func replyComment(postCommentId: Int?){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = ReplyRequest(group_post_comment_id: self.groupPostId != nil ? postCommentId : nil ,comment_id: self.groupPostId == nil ? postCommentId : nil, comment: self.replyCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines),replayId: self.commentReplyID)
            PostService.shared.addReply(parameters: data.toJSON(),isGroup: self.groupPostId == nil ? false : true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.postCommentId = nil
                self?.commentReplyID = nil
                self?.refreshComment()
                if let res = response.postCommentResponse{
                   self?.addNewReply(obj: res)
                }
                if let count = response.postCommentResponse?.comment_count{
                    self?.commentCountLabel.text = "\(count)"
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
    
    //MARK: - ADD NEW COMMENT REPLY
    func addNewReply(obj: CommentResponse){
        var replies : [CommentResponse] = []
        if let comment = self.mainCommentArray.first(where: {$0.id == obj.id}){
            let items = comment.replies ?? []
            replies.append(obj)
            for i in items{
                replies.append(i)
            }
            comment.replies = replies
            comment.repliesCount = ((comment.repliesCount ?? 0) + 1)
            if (comment.repliesCount ?? 0) > replies.count && replies.count > 2{
                self.getPostCommentReply(commentID: comment.id ?? 0)
            }
            self.manageCommentArray()
        }
    }
    
    //MARK: - GET POST COMMENT REPLY
    func getPostCommentReply(commentID: Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = ReplyRequest(group_post_comment_id: self.groupPostId != nil ? commentID : nil ,comment_id: self.groupPostId == nil ? commentID : nil, comment: nil,replayId: nil)
            PostService.shared.getPostReplys(parameters: data.toJSON(),isGroup: self.groupPostId == nil ? false : true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response.commentResponse{
                    if let item = self?.mainCommentArray.first(where: {$0.id == res.first?.id}){
                        item.replies = res
                        self?.manageCommentArray()
                    }
                }
                if let count = response.comment_count{
                    self?.commentCountLabel.text = "\(count)"
                }
            } failure: { [weak self] (error) in
                guard let strongSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: strongSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - REMOVE COMMENT
    func removeComment(id: Int){
        if let index = self.mainCommentArray.firstIndex(where: {$0.id == id}){
            self.mainCommentArray.remove(at: index)
            self.manageCommentArray()
        }
    }
    
    //MARK: - REMOVE COMMENT REPLY
    func removeReply(id: Int){
        for i in self.mainCommentArray{
            if let reply = i.replies?.firstIndex(where: {$0.replayId == id}){
                i.replies?.remove(at: reply)
                i.repliesCount = ((i.repliesCount ?? 0) - 1)
                if (i.repliesCount ?? 0) > (i.replies?.count ?? 0){
                    self.getPostCommentReply(commentID: i.id ?? 0)
                }
            }
        }
        self.manageCommentArray()
    }
}
