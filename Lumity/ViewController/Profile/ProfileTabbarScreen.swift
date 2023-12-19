//
//  ProfileScreen.swift
//  Source-App
//
//  Created by iroid on 31/03/21.
//

import UIKit
import ExpandableLabel
import PanModal
import SafariServices
import SwiftReorder

class ProfileTabbarScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
    @IBOutlet weak var topFivePlusView: UIView!
    @IBOutlet weak var editDoneButton: UIButton!
    @IBOutlet weak var editTopFiveViewHeight: NSLayoutConstraint!
    @IBOutlet weak var editTopFiveView: UIView!
    @IBOutlet weak var libraryViewWidth: NSLayoutConstraint!
    @IBOutlet weak var moreButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var settingButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinBtnBGView: dateSportView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var intrestsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editButtonMainView: dateSportView!
    @IBOutlet weak var userProfileImageView: dateSportImageView!
    @IBOutlet weak var joinMessageView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var libraryView: UIView!
    
    @IBOutlet weak var top5Label: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var searchMainView: dateSportView!
    @IBOutlet weak var top5SelectedView: dateSportView!
    @IBOutlet weak var postSelectedView: dateSportView!
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var searchView: dateSportView!
    @IBOutlet weak var intresetCollectionView: UICollectionView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var joinMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var editProfileHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewButton: UIButton!
    
    // MARK: - VARIABLE DECLARE
    //    var selectedIndex: Int = 0
    var itemArray: [PostReponse] = []
    var topFiveItemArray: [PostReponse] = []
    var collapedArray: [Bool] = []
    var hasMorePage: Bool = false
    var meta: Meta?
    var userId: Int?
    var page: Int = 1
    var postType: String?
    var searhText: String?
    var superVC: TabBarScreen?
    var isHideBack: Bool = false
    var userData: LoginResponse?
    var refreshControl = UIRefreshControl()
    private var canRefresh = true
    var selectedIndex: Int = 0
    var intrestedTagArray:[String] = []
    
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: true),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: true),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: true)]
    
    var topFiveCompletedData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: true),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: true),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: true)]
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userId == nil{
            self.userId = Utility.getCurrentUserId()
        }
        self.initializeDetails()
        self.tabBarController?.tabBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //        self.userId = nil
    }
    
    func initializeDetails(){
        self.headerViewTop.constant = topSafeArea
        self.searchTextField.clearButtonMode = .always
        self.searchTextField.delegate = self
        self.scrollView.delegate = self
        self.scrollView.bounces = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.refreshControl = self.refreshControl
        self.scrollView.refreshControl?.addTarget(self, action: #selector(self.refreshed), for: .valueChanged)
        
        self.editProfileHeight
            .constant = self.userId == Utility.getCurrentUserId() ? 35 : 0
        self.editButtonMainView
            .isHidden = self.userId != Utility.getCurrentUserId()
        self.joinMessageHeight
            .constant = self.userId == Utility.getCurrentUserId() ? 0 : 55
        self.moreButtonWidth.constant = self.userId == Utility.getCurrentUserId() ? 0 : 50
        self.libraryViewWidth.constant = self.userId == Utility.getCurrentUserId() ? 0 : 100
        
        self.settingButtonWidth.constant = self.userId != Utility.getCurrentUserId() ? 0 : 50
        self.headerViewHeight.constant = self.userId == Utility.getCurrentUserId() ? 0 : 50
        self.headerView.isHidden = self.userId == Utility.getCurrentUserId()
        self.joinMessageView.isHidden = self.userId == Utility.getCurrentUserId()
        self.backButton.isHidden = self.isHideBack
        
        if !isHideBack{
            self.headerView.isHidden = false
            self.settingButtonWidth.constant = self.userId != Utility.getCurrentUserId() ? 0 : 50
            self.headerViewHeight.constant = self.userId == Utility.getCurrentUserId() ? 50 : 50
        }
        self.registerCell()
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.displayEditFiveView(isHide: true)
        self.getUserData()
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page,postType: self.postType)
        
        self.viewButton.gradientButton("View", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)

    }
    
    func registerCell(){
        self.postTableView.register(UINib(nibName: "HomePostCell", bundle: nil), forCellReuseIdentifier: "HomePostCell")
        self.postTableView.register(UINib(nibName: "LinkPostCell", bundle: nil), forCellReuseIdentifier: "LinkPostCell")
        self.postTableView.register(UINib(nibName: "ResharePostCell", bundle: nil), forCellReuseIdentifier: "ResharePostCell")
        self.filterCollectionView.register(UINib(nibName: "PostTypeFilterCell", bundle: nil), forCellWithReuseIdentifier: "PostTypeFilterCell")
        self.postTableView.register(UINib(nibName: "TopFivePostCell", bundle: nil), forCellReuseIdentifier: "TopFivePostCell")
        self.postTableView.register(UINib(nibName: "SelectPostTopFiveCell", bundle: nil), forCellReuseIdentifier: "SelectPostTopFiveCell")
        self.intresetCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
    }
    
    @objc func refreshed(){
        if self.postTableView.tag == 0{
            self.page = 1
            self.getPostAPI(page: self.page, postType: self.postType)
        }else{
            self.setTopFiveView()
            self.getTopFivePost()
        }
    }
    
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }
    
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            self.searhText = nil
            self.getPostAPI(page: self.page, postType: self.postType)
        }else{
            self.page = 1
            self.searhText = text
            self.getPostAPI(page: self.page, postType: self.postType)
        }
    }
    
    func getUserData(){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            ProfileService.shared.getUserDetail(userId: self.userId ?? 0) { [weak self] (statusCode, response) in
                //                print(response?.toJSON())
                self?.setUserData(userData: response)
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
    
    
    func setUserData(userData: LoginResponse?){
        self.userData = userData
        if let data = userData{
            //            self.userProfileImageView.
            Utility.setImage(data.profile_pic ?? "", imageView: self.userProfileImageView)
            self.userNameLabel.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
            self.headLineLabel.text = data.headline
            self.bioLabel.text = data.bio
            self.linkLabel.text = data.url
            //            self.intrestsLabel.text = data.interest
            self.linkLabel.isUserInteractionEnabled = true // Remember to do this
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(onTap))
            self.linkLabel.addGestureRecognizer(tap)
            if data.join_status == 1{
                self.setJoinStatus(isJoin: true)
            }else if data.join_status == 0{
                self.setJoinStatus(isJoin: false)
            }
            if self.libraryViewWidth.constant == 100{
                if (userData?.mylibrary_public_count ?? 0) > 0{
                    self.libraryViewWidth.constant = 100
                    self.libraryButton.isHidden = false
                    self.libraryView.isHidden = false
                }else{
                    self.libraryViewWidth.constant = 0
                    self.libraryButton.isHidden = true
                    self.libraryView.isHidden = true
                }
            }
            if let intrests = userData?.interest{
                if intrests != ""{
                    let arr = intrests.components(separatedBy: ",")
                    intrestedTagArray = arr
                    intresetCollectionView.reloadData()
                }
            }
        }
    }
    
    func addJoinUser(status: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: self.userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.userData?.join_status = status
                if status == 1{
                    self?.setJoinStatus(isJoin: true)
                }else if status == 0{
                    self?.setJoinStatus(isJoin: false)
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
    
    func setJoinStatus(isJoin: Bool){
        if isJoin{
            self.joinBtnBGView.backgroundColor = .white
            self.joinButton.setTitle("Joined", for: .normal)
            self.joinButton.setTitleColor(.black, for: .normal)
//            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "A4D1D6")
            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "707070")

            self.joinBtnBGView.borderWidth = 1
            self.removeGradient(selectedGradientView: self.joinBtnBGView)

        }else{
//            self.joinBtnBGView.backgroundColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
            self.joinButton.setTitle("Join", for: .normal)
            self.joinButton.setTitleColor(.white, for: .normal)
//            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
            self.joinBtnBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            self.joinBtnBGView.borderWidth = 0
        }
    }
    
    func removeGradient(selectedGradientView:UIView){
        selectedGradientView.layer.sublayers = selectedGradientView.layer.sublayers?.filter { theLayer in
                !theLayer.isKind(of: CAGradientLayer.classForCoder())
          }
    }
    
    // MARK: - ACTIONS
    @IBAction func onCommunityView(_ sender: Any) {
        let vc = STORYBOARD.community.instantiateViewController(withIdentifier: "UserCommunityScreen") as! UserCommunityScreen
        vc.userId = self.userId
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onJoin(_ sender: Any) {
        let status = self.userData?.join_status == 0 ? 1 : 0
        self.addJoinUser(status: status)
    }
    
    @IBAction func onLibrary(_ sender: Any) {
        if userData?.mylibrary_public_count == 0{
            Utility.showAlert(vc: self, message: "This person does not have a public playlist.")
        }else{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "OtherUserLibrartFolderScreen") as! OtherUserLibrartFolderScreen
            vc.userId = userId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func onMore(_ sender: Any) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileBlockScreen") as! ProfileBlockScreen
        let rowVC: PanModalPresentable.LayoutType = vc
        vc.userResponse = self.userData
        vc.onBlockUser  = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.presentPanModal(rowVC)
        //        Utility.showAlert(vc: self, message: "Coming Soon")
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func displayEditFiveView(isHide: Bool){
        if self.userId == Utility.getCurrentUserId(){
            self.editTopFiveViewHeight.constant = isHide ? 0 : 40
            self.editTopFiveView.isHidden = isHide
        }else{
            self.editTopFiveViewHeight.constant = 0
            self.editTopFiveView.isHidden = true
        }
    }
    
    @objc func onTap(){
        if let link = self.linkLabel.text,(self.linkLabel.text?.count ?? 0) > 0{
            
            let validUrlString = link.hasPrefix("http") ? link : "http://\(link)"
            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
            control.linkUrl = validUrlString
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
    
    func getPostType() -> String{
        var idArray : [Int] = []
        for i  in self.postTypeData{
            if i.isSelected == true{
                idArray.append(i.postType ?? 0)
            }
        }
        return idArray.map { String($0) }.joined(separator: ",")
        
    }
    
    func getAllTypePostSelectionCount() -> Int{
        var idArray : [Int] = []
        for i  in self.postTypeData{
            if i.isSelected == true{
                idArray.append(i.postType ?? 0)
            }
        }
        return idArray.count
        
    }
    
    //MARK:- POST API
    func getPostAPI(page: Int,postType: String?){
        //        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
                //Utility.showIndicator()
            }
            let data = GetUserPostRequest(user_id: self.userId, post_type: postType, search: self.searhText, page: page)
            ProfileService.shared.getUserPost(parameters: data.toJSON(), page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.stopPulling()
                self?.hasMorePage = true
                if let res = response.postListResponse,(response.postListResponse?.count ?? 0) > 0{
                    if page == 1{
                        self?.itemArray = res
                        self?.collapedArray = [Bool](repeating: true, count: self?.itemArray.count ?? 0)
                        self?.postTableViewHeight.constant = 800
                        self?.postTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self?.postTableView.scrollToTop(animated: true)
                        }
                        self?.startImageDownload()
                    }else{
                        self?.appendPostDataTableView(data: res)
                    }
                }else{
                    self?.itemArray = []
                    self?.postTableView.reloadData()
                    self?.postTableViewHeight.constant = 150
                }
                //                if (self?.itemArray.count)! < 0{
                //                    self?.postTableView.reloadData()
                //                }else{
                self?.startDownload()
                //                }
                
                //                self?.stopPulling()
                if let meta = response.meta{
                    self?.meta = meta
                }
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                stronSelf.stopPulling()
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            self.stopPulling()
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:- DELETE TOP FIVE POST
    func deleteTopFivePost(postId: Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            ProfileService.shared.deleteTopFivePost(postID:postId) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
                strongSelf.editTopFivePostAPI()
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func downloadTopFivePostMetaData(link: String,id: Int){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            if let index = self?.topFiveItemArray.firstIndex(where: {$0.id == id && $0.link == link}){
                self?.topFiveItemArray[index].linkMeta = linkMetaData
                if self?.postTableView.tag == 1{
                    UIView.performWithoutAnimation {
                        let loc = self?.postTableView.contentOffset
                        if self?.topFiveItemArray.indices.contains(index) == true{
                            self?.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
                    }
                }
                
            }
            self?.startDownloadTopFiveLink()
        }
    }
    
    func startDownloadTopFiveLink(){
        guard let item = self.topFiveItemArray.first(where: {$0.linkMeta == nil && ($0.post_type == PostType.artical.rawValue || $0.post_type == PostType.video.rawValue || $0.post_type == PostType.podcast.rawValue)}) else {
            return
        }
        if let link = item.link,let id = item.id{
            self.downloadTopFivePostMetaData(link: link,id: id)
        }else{
            self.startDownloadTopFiveLink()
        }
    }
    
    func downloadMetaData(link: String,id: Int,reshare: Bool){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            if let index = self?.itemArray.firstIndex(where: {$0.id == id && $0.reshare == reshare}){
                self?.itemArray[index].linkMeta = linkMetaData
                if self?.postTableView.tag == 0{
                    UIView.performWithoutAnimation {
                        let loc = self?.postTableView.contentOffset
                        
                        self?.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        self?.postTableView.contentOffset = loc ?? .zero
                    }
                }
                
            }
            self?.startDownload()
        }
    }
    
    func startDownload(){
        guard let item = self.itemArray.first(where: {$0.linkMeta == nil && ($0.post_type == PostType.artical.rawValue || $0.post_type == PostType.video.rawValue || $0.post_type == PostType.podcast.rawValue)}) else {
            return
        }
        if let link = item.link,let id = item.id,let reshare = item.reshare{
            self.downloadMetaData(link: link,id: id,reshare: reshare)
        }else{
            self.startDownload()
        }
    }
    
    func appendPostDataTableView(data: [PostReponse]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.postTableViewHeight.constant = self.postTableViewHeight.constant + CGFloat((150 * data.count))

        if self.postTableView.tag == 0{
            UIView.performWithoutAnimation { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.collapedArray = [Bool](repeating: true, count: strongSelf.itemArray.count)
                strongSelf.postTableView.insertRows(at: indexPath, with: .none)
                
            }
        }
    }
    
    
    //MARK:- TOP FIVE
    func getTopFivePost(){
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
               // Utility.showIndicator()
            }
//            Utility.showIndicator()
            let data = TopFiveRequest(user_id: self.userId,post_type: self.topFiveCompletedData[self.selectedIndex].postType)
            ProfileService.shared.getTopFivePost(parameters: data.toJSON()) { [weak self] (statusCode, response) in
//                Utility.hideIndicator()
                self?.stopPulling()
                DispatchQueue.main.async {
                    if let res = response,res.count > 0{
                        self?.topFiveItemArray = res
                    }else{
                        self?.topFiveItemArray = []
                    }
                    self?.editTopFiveView.isHidden = self?.userId == Utility.getCurrentUserId() ? false : true
                    self?.editDoneButton.isHidden = self?.checkPostPosititonArray() ?? true
                    self?.topFivePlusView.isHidden = true
                    self?.postTableView.reloadData()
                    self?.startDownloadTopFiveLink()
                    self?.startTopFiveImageDownload()

                }
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                stronSelf.stopPulling()
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            self.stopPulling()
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    // MARK: scroll method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.postTableView.tag == 0{
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
                            self.getPostAPI(page: self.page, postType: self.postType)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- DO LIKE API
    func doLikeAPI(postId:Int,islike:Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let parameter = doLikeRequest(post_id: postId, islike: islike, group_post_id: nil)
            PostService.shared.doLikeOnPost(parameters: parameter.toJSON()) { (statusCode, response) in
                //                Utility.hideIndicator()
                var isLikeStatus = false
                if islike == 1{
                    isLikeStatus = true
                }else{
                    isLikeStatus = false
                }
                self.changeLikeStatus(postId: postId, isLike:isLikeStatus )
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func changeLikeStatus(postId: Int,isLike: Bool){
        if let index = self.itemArray.firstIndex(where: {$0.id == postId}){
            if isLike{
                itemArray[index].like_count! += 1
            }else{
                itemArray[index].like_count! -= 1
            }
            self.itemArray[index].is_like = isLike
            DispatchQueue.main.async { [weak self] in
                UIView.performWithoutAnimation {
                    let loc = self?.postTableView.contentOffset
                    self?.postTableView.reloadData()
                    self?.postTableView.contentOffset = loc ?? .zero
                }
            }
        }
    }
    
    //MARK:- DELETE POST ALERT
    func deletePostAlert(postObj: PostReponse){
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: { [weak self] (alert) in
            self?.deletePostAPI(postObj: postObj)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func deletePostAPI(postObj: PostReponse){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            guard let id = postObj.id else {
                return
            }
            PostService.shared.deletePost(id: id) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.page = 1
                self?.getPostAPI(page: 1,postType: self?.postType)
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
    
    func goFurtherPostEdit(postObj: PostReponse){
        if postObj.reshare == true{
            let reshareVC = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
            reshareVC.modalPresentationStyle = .fullScreen
            reshareVC.postObject = postObj
            reshareVC.completeAddNewPostDelegate = self
            reshareVC.isEdit = true
            self.superVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
        }else{
            switch postObj.post_type {
            case PostType.podcast.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
                vc.superVC = self
                vc.postObj = postObj
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case PostType.video.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
                vc.superVC = self
                vc.postObj = postObj
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case PostType.book.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
                vc.postObj = postObj
                vc.superVC = self
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
                vc.postObj = postObj
                vc.superVC = self
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
        
    }
    
    @IBAction func onSetting(_ sender: UIButton) {
        let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "SettingScreen") as! SettingScreen
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onEditProfile(_ sender: Any) {
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "EditProfileScreen") as! EditProfileScreen
        vc.onEdit = { [weak self] in
            self?.getUserData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPost(_ sender: Any) {
        if self.postTableView.tag == 0{
            return
        }
        self.postLabel.textColor = .black
        self.top5Label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        self.postLabel.font = UIFont(name: "Calibri-Bold", size: 17)
        self.top5Label.font = UIFont(name: "Calibri", size: 17)
        self.top5SelectedView.isHidden = true
        self.postSelectedView.isHidden = false
        self.searchMainView.isHidden = false
        self.searchViewHeight.constant = 40
        self.postTableView.tag = 0
        self.filterCollectionView.tag = 0
        self.filterCollectionView.reloadData()
        self.postTableView.reloadData()
        self.displayEditView(isDisplay: false)
        self.displayEditFiveView(isHide: true)
        self.postTableView.reorder.delegate = nil
        self.page = 1
        self.getPostAPI(page: self.page,postType: self.postType)
    }
    
    @IBAction func onEditTopFive(_ sender: Any) {
        self.displayEditView(isDisplay: true)
    }
    
    func displayEditView(isDisplay: Bool){
        if isDisplay{
            self.editTopFiveView.isHidden = true
            self.topFivePlusView.isHidden = false
            if !self.topFiveItemArray.isEmpty && self.topFiveItemArray.count > 1{
                self.postTableView.reorder.delegate = self
            }else{
                self.postTableView.reorder.delegate = nil
            }
            self.editDoneButton.isHidden = false
            self.postTableView.reloadData()
        }else{
            self.editTopFiveView.isHidden = false
            self.editDoneButton.isHidden = true
            self.topFivePlusView.isHidden = true
            self.postTableView.reorder.delegate = nil
            self.postTableView.reloadData()
        }
    }
    
    @IBAction func onMessage(_ sender: UIButton) {
        let vc =  STORYBOARD.message.instantiateViewController(withIdentifier: "ChatDetailScreen") as! ChatDetailScreen
        vc.userData = userData
        vc.receiverId = userData?.user_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onViewProfile(_ sender: UIButton) {
        if let profilePhoto = userData?.profile_pic{
            if profilePhoto != ""{
                let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl = profilePhoto
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self.present(confirmAlertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func onAddTopFive(_ sender: Any) {
        var idArray: [Int] = []
        for i in self.topFiveItemArray{
            idArray.append(i.id ?? 0)
        }
        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "AddTopFiveFromCompletedScreen") as! AddTopFiveFromCompletedScreen
        vc.selectedIndex = self.selectedIndex
        vc.onDone = { [weak self] in
            self?.getTopFivePost()
            self?.displayEditView(isDisplay: false)
        }
        vc.idArray = idArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTop5(_ sender: Any) {
        if self.postTableView.tag == 1{
            return
        }
        self.setTopFiveView()
        self.getTopFivePost()
    }
    
    func setTopFiveView(){
        self.postLabel.textColor = Utility.getUIcolorfromHex(hex: "707070")
        self.top5Label.textColor = .black
        self.top5Label.font = UIFont(name: "Calibri-Bold", size: 17)
        self.postLabel.font = UIFont(name: "Calibri", size: 17)
        self.searchMainView.isHidden = true
        self.searchViewHeight.constant = 0
        self.top5SelectedView.isHidden = false
        self.postSelectedView.isHidden = true
        self.postTableView.tag = 1
        self.filterCollectionView.tag = 1
        self.filterCollectionView.reloadData()
        self.postTableView.reloadData()
        self.displayEditFiveView(isHide: false)
    }
    
    @IBAction func onEditDone(_ sender: Any) {
        if !self.checkPostPosititonArray(){
            self.editTopFivePostAPI()
        }else{
            self.displayEditView(isDisplay: false)
        }
    }
    @IBAction func onHideSearchView(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
    }
    
    func getTopFiveJson() -> [AddTopFiveJsonRequest]{
        var jsonArray: [AddTopFiveJsonRequest] = []
        for (index,element) in self.topFiveItemArray.enumerated(){
            jsonArray.append(AddTopFiveJsonRequest(post_id: "\(element.id ?? 0)", position: "\(index)"))
        }
        return jsonArray
    }
    
    //MARK:- Edit top five API
    func editTopFivePostAPI(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let json = self.getTopFiveJson().toJSONString()
            let data = AddTopFiveCompletedRequest(data: json,post_type: self.self.postTypeData[self.selectedIndex].postType)
            ProfileService.shared.addPostTopFive(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.displayEditView(isDisplay: false)
               // self?.getTopFivePost()
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
    
    func checkPostPosititonArray() -> Bool{
        var positionArray: [Int] = []
        for i in self.topFiveItemArray{
            positionArray.append(i.position ?? 0)
        }
        return positionArray.isAscending()
    }
    
    func didSelectData(indexPath:Int){
        let data = itemArray[indexPath]
        
        if data.reshare == true{
            let reshareVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
            reshareVC.postDetailData = data
            reshareVC.postId = data.id ?? 0
            reshareVC.backSuperVC = self
            reshareVC.completeAddNewPostDelegate = self
            reshareVC.onBack = { [weak self] (data) in
                if let obj = data{
                    self?.itemArray[indexPath] = obj
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            let loc = self?.postTableView.contentOffset
                            self?.postTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .none)
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
                    }
                }
            }
            reshareVC.onSuccessReport = { [weak self] in
                self?.itemArray.remove(at: indexPath)
                self?.postTableView.reloadData()
            }
            reshareVC.onUnFollowUser = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
                strongSelf.getPostAPI(page: strongSelf.page, postType: self?.getPostType())
            }
            
            self.navigationController?.pushViewController(reshareVC, animated: true)
        }else{
            let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
            vc.postId = data.id ?? 0
            vc.postDetailData = data
            vc.backSuperVC = self
            vc.completeAddNewPostDelegate = self
            vc.onBack = { [weak self] (data) in
                if let obj = data{
                    self?.itemArray[indexPath] = obj
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            let loc = self?.postTableView.contentOffset
                            self?.postTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .none)
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
                    }
                }
            }
            vc.onSuccessReport = { [weak self] in
                self?.itemArray.remove(at: indexPath)
                self?.postTableView.reloadData()
            }
            vc.onUnFollowUser = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
                strongSelf.getPostAPI(page: strongSelf.page, postType: self?.getPostType())
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func displayDeleteDialogue(id: Int,index:Int){
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "Are you sure you want to Delete?", preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
//            self?.deletePost(obj: obj)
            self?.topFiveItemArray.remove(at: index)
            self?.postTableView.reloadData()
            self?.deleteTopFivePost(postId: id)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension ProfileTabbarScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == intresetCollectionView{
            return self.intrestedTagArray.count
        }else{
            if collectionView.tag == 0{
                return self.postTypeData.count
            }
            return self.topFiveCompletedData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == intresetCollectionView{
            let cell = self.intresetCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
            cell.label.text = self.intrestedTagArray[indexPath.row]
            cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
            cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
            cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTypeFilterCell", for: indexPath) as! PostTypeFilterCell
            if collectionView.tag == 0{
                cell.item = self.postTypeData[indexPath.row]
            }else{
                cell.setItemMyLibrary = postTypeData[indexPath.row]
                if selectedIndex == indexPath.row{
                    cell.postTypeView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }else{
                    cell.postTypeView.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
                }
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView{
            if collectionView.tag == 0{
                let data = self.postTypeData[indexPath.row]
                if data.isSelected ?? false{
                    data.isSelected = false
                }else{
                    data.isSelected = true
                }
                self.postTypeData[indexPath.row] = data
                //        self.selectedIndex = indexPath.row
                self.filterCollectionView.reloadData()
                
                self.page = 1
                self.postType = self.getPostType()
                self.getPostAPI(page: self.page,postType: postType)
            }else{
                let data = self.topFiveCompletedData[indexPath.row]
                if data.isSelected ?? false{
                    data.isSelected = false
                }else{
                    data.isSelected = true
                }
                self.topFiveCompletedData[indexPath.row] = data
                self.selectedIndex = indexPath.row
                
                self.searchMainView.isHidden = true
                self.searchViewHeight.constant = 0
                self.top5SelectedView.isHidden = false
                self.postSelectedView.isHidden = true
                self.topFivePlusView.isHidden = true
                self.editDoneButton.isHidden = true
                self.postTableView.tag = 1
                self.filterCollectionView.tag = 1
                self.filterCollectionView.reloadData()
                self.postTableView.reloadData()
                self.displayEditFiveView(isHide: false)
                self.getTopFivePost()
                
            }
        }else if collectionView == self.intresetCollectionView{
                let data = self.intrestedTagArray[indexPath.row]
                let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
                vc.searhText = data
                vc.superVC = self.superVC
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == intresetCollectionView{
            let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.intrestedTagArray[indexPath.row])
            return CGSize(width: width + 16, height: 32)
        }
        return CGSize(width: collectionView.frame.width/4, height: 46)
    }
    
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension ProfileTabbarScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return self.itemArray.count
        }else{
            if self.topFiveItemArray.isEmpty{
                return self.userId == Utility.getCurrentUserId() ? 1 : 0
            }
            return self.topFiveItemArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.postTableViewHeight.constant = tableView.contentSize.height
        if tableView.tag == 1{
            if self.topFiveItemArray.isEmpty{
                let cell = self.postTableView.dequeueReusableCell(withIdentifier: "SelectPostTopFiveCell") as! SelectPostTopFiveCell
                cell.onCompleted = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "AddTopFiveFromCompletedScreen") as! AddTopFiveFromCompletedScreen
                    vc.selectedIndex = self?.selectedIndex ?? 0
                    vc.onDone = { [weak self] in
                        self?.getTopFivePost()
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
            let cell = self.postTableView.dequeueReusableCell(withIdentifier: "TopFivePostCell") as! TopFivePostCell
            cell.item = self.topFiveItemArray[indexPath.row]
            if self.userId == Utility.getCurrentUserId(){
//                cell.positionLabel.isHidden = self.editTopFiveView.isHidden
                cell.positionLabel.isHidden = true
                cell.swapeImageView.isHidden = self.topFivePlusView.isHidden
            }else{
//                cell.positionLabel.isHidden = false
            }
            
            cell.onLinkClick = {[weak self ] in
                let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                control.linkUrl = self?.topFiveItemArray[indexPath.row].link ?? ""
                self?.navigationController?.pushViewController(control, animated: true)
            }
            return cell
        }
        
        
        //MARK:- RESHARE
        if self.itemArray[indexPath.row].reshare == true{
            let cell = self.postTableView.dequeueReusableCell(withIdentifier: "ResharePostCell") as! ResharePostCell
            cell.item = self.itemArray[indexPath.row]
            cell.viewController = self
            cell.tabBarVC = self.superVC
//            let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "1958D0"),NSAttributedString.Key.font: cell.captionLabel.font!])
//            cell.captionLabel.delegate = self
//            cell.layoutIfNeeded()
//            cell.captionLabel.shouldCollapse = true
//            cell.captionLabel.collapsedAttributedLink = attributedString
//            cell.captionLabel.textReplacementType = .character
//            cell.captionLabel.collapsed = self.collapedArray[indexPath.row]
            cell.reShareCaptionLabel.numberOfLines = 0
            cell.reShareCaptionLabel.text = self.itemArray[indexPath.row].reshare_caption
            cell.reShareCaptionLabel.adjustsFontSizeToFitWidth = false
            cell.reShareCaptionLabel.lineBreakMode = .byTruncatingTail
            if getCaptionLineNumber(text: self.itemArray[indexPath.row].reshare_caption ?? "") <= 64.5{
                cell.reshareReadMoreButton.isHidden = true
                cell.reShareReadMoreLineView.isHidden = true
            }else{
                cell.reshareReadMoreButton.isHidden = self.itemArray[indexPath.row].reshareReadMore == false ? true : false
                cell.reShareReadMoreLineView.isHidden = self.itemArray[indexPath.row].reshareReadMore == false ? true : false
            }
            cell.reShareCaptionLabel.numberOfLines = self.itemArray[indexPath.row].reshareReadMore == false ? 0 : 3
            
            cell.reshareReadMore = { [weak self] in
                self?.itemArray[indexPath.row].reshareReadMore = false
                UIView.performWithoutAnimation { [weak self]
                    in
                    let loc = self?.postTableView.contentOffset
                    self?.postTableView.reloadRows(at: [indexPath], with: .bottom)
                    self?.postTableView.contentOffset = loc ?? .zero
                }
            }
            
            cell.captionLabel.numberOfLines = 0
            cell.captionLabel.text = self.itemArray[indexPath.row].caption
            cell.captionLabel.adjustsFontSizeToFitWidth = false
            cell.captionLabel.lineBreakMode = .byTruncatingTail
            if getCaptionLineNumber(text: self.itemArray[indexPath.row].caption ?? "") <= 64.5{
//                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreLineView.isHidden = true
                cell.readMoreButton.isHidden = true
            }else{
                if self.collapedArray.indices.contains(indexPath.row){
                    cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                    cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                }else{
                    cell.readMoreButton.isHidden = false
                }
                
            }
            if self.collapedArray.indices.contains(indexPath.row){
                cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
            }else{
                cell.captionLabel.numberOfLines = 3
            }
            
            cell.onReadMore = {[weak self] in
                self?.collapedArray[indexPath.row] = false
//                cell.readMoreButton.isHidden = true
                UIView.performWithoutAnimation { [weak self]
                    in
                    let loc = self?.postTableView.contentOffset
                    self?.postTableView.reloadRows(at: [indexPath], with: .bottom)
                    self?.postTableView.contentOffset = loc ?? .zero
                }
                print("read more")
            }
            
           // cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 2
           // cell.captionLabel.text = self.itemArray[indexPath.row].caption
            cell.onLinkClick = {[weak self ] in
                let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                control.linkUrl = self?.itemArray[indexPath.row].link ?? ""
                self?.navigationController?.pushViewController(control, animated: true)
            }
            cell.onPostImage = { [weak self] in
                let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl =  self?.itemArray[indexPath.row].media ?? ""
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self?.present(confirmAlertController, animated: true, completion: nil)
            }
            cell.onSubPost = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                vc.postId = self?.itemArray[indexPath.row].reshare_main_post_id ?? 0
                vc.isFromReShare = true
                //                vc.postDetailData = data
                vc.onBack = { [weak self] (data) in
                    if let obj = data{
                        self?.itemArray[indexPath.row] = obj
                        DispatchQueue.main.async {
                            UIView.performWithoutAnimation {
                                let loc = self?.postTableView.contentOffset
                                self?.postTableView.reloadRows(at: [indexPath], with: .none)
                                self?.postTableView.contentOffset = loc ?? .zero
                            }
                        }
                    }
                }
                vc.onSuccessReport = { [weak self] in
                    self?.itemArray.remove(at: indexPath.row)
                    self?.postTableView.reloadData()
                }
                vc.onUnFollowUser = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.page = 1
                    strongSelf.getPostAPI(page: strongSelf.page, postType: self?.getPostType())//getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                }
                
                self?.superVC?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.onShare = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostShareScreen") as! PostShareScreen
                vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                vc.onSendMessage = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
                    vc.messageNavigationType = MessageNavigationType.profileScreen.rawValue
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
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
                self?.superVC?.navigationController?.presentPanModal(rowVC)
            }
            cell.onLike = {[weak self] in
                //                if let isLike = self?.itemArray[indexPath.row].is_like{
                //                    if isLike{
                //                        return
                //                    }
                //                }
                let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                self?.doLikeAPI(postId:  self?.itemArray[indexPath.row].id ?? 0 , islike: islike)
            }
            cell.onMore = { [weak self] in
                if Utility.getCurrentUserId() == self?.itemArray[indexPath.row].user_id{
                    let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "DeletePostScreen") as! DeletePostScreen
                    vc.onDelete = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
                    }
                    vc.onEdit = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.goFurtherPostEdit(postObj: strongSelf.itemArray[indexPath.row])
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }else{
                    
                    let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                    //                vc.modalPresentationStyle = .overCurrentContext
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.isFromReShare = true
                    vc.onReportPost = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.postId = self?.itemArray[indexPath.row].id
                        vc.onSuccessReport = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            self?.itemArray.remove(at: indexPath.row)
                            self?.postTableView.reloadData()
                            self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                    
                    vc.onUnfollowUser = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.page = 1
                        strongSelf.getPostAPI(page: strongSelf.page, postType: self?.getPostType())//getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }
            }
            cell.onLikeCount = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.postId = self?.itemArray[indexPath.row].id ?? 0
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.onComment = { [weak self] in
                self?.didSelectData(indexPath: indexPath.row)
            }
            
            cell.onReShare = { [weak self] in
                let reshareVC = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
                reshareVC.modalPresentationStyle = .fullScreen
                reshareVC.postObject = self?.itemArray[indexPath.row]
                reshareVC.completeAddNewPostDelegate = self
                self?.superVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
            }
            return cell
            
        }else{
            if self.itemArray[indexPath.row].post_type == PostType.artical.rawValue ||  self.itemArray[indexPath.row].post_type == PostType.video.rawValue ||  self.itemArray[indexPath.row].post_type == PostType.podcast.rawValue{
                let cell = self.postTableView.dequeueReusableCell(withIdentifier: "LinkPostCell", for: indexPath) as! LinkPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.viewController = self
                cell.superVC = self.superVC
//                let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "1958D0"),NSAttributedString.Key.font: cell.captionLabel.font!])
//                cell.captionLabel.delegate = self
//                cell.layoutIfNeeded()
//                cell.captionLabel.shouldCollapse = true
//                cell.captionLabel.collapsedAttributedLink = attributedString
//                cell.captionLabel.textReplacementType = .character
//                cell.captionLabel.collapsed = self.collapedArray[indexPath.row]
//                cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 2
//                cell.captionLabel.text = self.itemArray[indexPath.row].caption
                
                cell.captionLabel.numberOfLines = 0
                cell.captionLabel.text = self.itemArray[indexPath.row].caption
                cell.captionLabel.adjustsFontSizeToFitWidth = false
                cell.captionLabel.lineBreakMode = .byTruncatingTail
                
                if getCaptionLineNumber(text: self.itemArray[indexPath.row].caption ?? "") <= 64.5{
    //                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                    cell.readMoreButton.isHidden = true
                    cell.readMoreLineView.isHidden = true
                }else{
                    if self.collapedArray.indices.contains(indexPath.row){
                        cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                        cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                    }else{
                        cell.readMoreLineView.isHidden = true
                        cell.readMoreButton.isHidden = false
                    }
                    
                }
                if self.collapedArray.indices.contains(indexPath.row){
                    cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
                }else{
                    cell.captionLabel.numberOfLines = 3
                }
                print("read first more")
                
                cell.onReadMore = {[weak self] in
                    if self?.collapedArray.indices.contains(indexPath.row) == true{
                        self?.collapedArray[indexPath.row] = false
                     }
                   
    //                cell.readMoreButton.isHidden = true
                    UIView.performWithoutAnimation { [weak self]
                        in
                        let loc = self?.postTableView.contentOffset
                        self?.postTableView.reloadRows(at: [indexPath], with: .bottom)
                        self?.postTableView.contentOffset = loc ?? .zero
                    }
                    print("read more")
                }
                
                cell.onLinkClick = {[weak self ] in
                    let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                    control.linkUrl = self?.itemArray[indexPath.row].link ?? ""
                    self?.navigationController?.pushViewController(control, animated: true)
                }
                cell.onShare = { [weak self] in
                    let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostShareScreen") as! PostShareScreen
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.onSendMessage = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
                        vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                        vc.messageNavigationType = MessageNavigationType.profileScreen.rawValue
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
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }
                cell.onLike = {[weak self] in
                    //                    if let isLike = self?.itemArray[indexPath.row].is_like{
                    //                        if isLike{
                    //                            return
                    //                        }
                    //                    }
                    let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                    self?.doLikeAPI(postId:  self?.itemArray[indexPath.row].id ?? 0 , islike: islike)
                }
                cell.onMore = { [weak self] in
                    if Utility.getCurrentUserId() == self?.itemArray[indexPath.row].user_id{
                        let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "DeletePostScreen") as! DeletePostScreen
                        vc.onDelete = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
                        }
                        vc.onEdit = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.goFurtherPostEdit(postObj: strongSelf.itemArray[indexPath.row])
                        }
                        let rowVC: PanModalPresentable.LayoutType = vc
                        self?.superVC?.navigationController?.presentPanModal(rowVC)
                    }else{
                        let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                        //                    vc.modalPresentationStyle = .overCurrentContext
                        vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                        
                        vc.onReportPost = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.postId = self?.itemArray[indexPath.row].id
                            
                            vc.onSuccessReport = { [weak self] in
                                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                                vc.modalPresentationStyle = .overCurrentContext
                                
                                self?.itemArray.remove(at: indexPath.row)
                                self?.postTableView.reloadData()
                                
                                self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                            self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        vc.onUnfollowUser = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.page = 1
                            strongSelf.getPostAPI(page: strongSelf.page, postType: self?.postType)//getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                        }
                        let rowVC: PanModalPresentable.LayoutType = vc
                        self?.superVC?.navigationController?.presentPanModal(rowVC)
                    }
                     
                }
                cell.onLikeCount = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.postId = self?.itemArray[indexPath.row].id ?? 0
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                cell.onReShare = { [weak self] in
                    let reshareVC = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
                    reshareVC.modalPresentationStyle = .fullScreen
                    reshareVC.postObject = self?.itemArray[indexPath.row]
                    reshareVC.completeAddNewPostDelegate = self
                    self?.superVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
                }
                cell.onComment = { [weak self] in
                    self?.didSelectData(indexPath: indexPath.row)
                }
                return cell
            }
            let cell = self.postTableView.dequeueReusableCell(withIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
            cell.item = self.itemArray[indexPath.row]
            cell.viewController = self
            cell.superVC = self.superVC
            
            let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "000000"),NSAttributedString.Key.font: cell.captionLabel.font!])
//            cell.captionLabel.delegate = self
//            
//            cell.layoutIfNeeded()
//            
//            cell.captionLabel.shouldCollapse = true
//            cell.captionLabel.collapsedAttributedLink = attributedString
//            cell.captionLabel.textReplacementType = .character
//            cell.captionLabel.collapsed = self.collapedArray[indexPath.row]
//            cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 2
//            cell.captionLabel.text = self.itemArray[indexPath.row].caption
//
            
            cell.captionLabel.numberOfLines = 0
            cell.captionLabel.text = self.itemArray[indexPath.row].caption
            cell.captionLabel.adjustsFontSizeToFitWidth = false
            cell.captionLabel.lineBreakMode = .byTruncatingTail
            if getCaptionLineNumber(text: self.itemArray[indexPath.row].caption ?? "") <= 64.5{
//                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreButton.isHidden = true
                cell.readMoreLineView.isHidden = true
            }else{
                if self.collapedArray.indices.contains(indexPath.row){
                    cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                    cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                }else{
                    cell.readMoreLineView.isHidden = false
                    cell.readMoreButton.isHidden = false
                }
                
            }
            if self.collapedArray.indices.contains(indexPath.row){
                cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
            }else{
                cell.captionLabel.numberOfLines = 3
            }
            
            cell.onReadMore = {[weak self] in
                self?.collapedArray[indexPath.row] = false
//                cell.readMoreButton.isHidden = true
                UIView.performWithoutAnimation { [weak self]
                    in
                    let loc = self?.postTableView.contentOffset
                    self?.postTableView.reloadRows(at: [indexPath], with: .bottom)
                    self?.postTableView.contentOffset = loc ?? .zero
                }
                print("read more")
            }
            
            //MARK:- SHARE
            cell.onShare = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostShareScreen") as! PostShareScreen
                vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                vc.onSendMessage = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
                    vc.messageNavigationType = MessageNavigationType.profileScreen.rawValue
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
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
                self?.superVC?.navigationController?.presentPanModal(rowVC)
            }
            //MARK:- Preview
            cell.onPostImage = { [weak self] in
                let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl =  self?.itemArray[indexPath.row].media ?? ""
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self?.present(confirmAlertController, animated: true, completion: nil)
            }
            //MARK:- LIKE
            cell.onLike = {[weak self] in
                let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                self?.doLikeAPI(postId:  self?.itemArray[indexPath.row].id ?? 0 , islike: islike)
            }
            //MARK:- BLOCK SAVE/COMPLETED VIEW
            
            cell.onMore = { [weak self] in
                if Utility.getCurrentUserId() == self?.itemArray[indexPath.row].user_id{
                    let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "DeletePostScreen") as! DeletePostScreen
                    vc.onDelete = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
                    }
                    vc.onEdit = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.goFurtherPostEdit(postObj: strongSelf.itemArray[indexPath.row])
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }else{
                    let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                    //                vc.modalPresentationStyle = .overCurrentContext
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.onReportPost = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.postId = self?.itemArray[indexPath.row].id
                        
                        vc.onSuccessReport = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            
                            self?.itemArray.remove(at: indexPath.row)
                            self?.postTableView.reloadData()
                            
                            self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                    
                    vc.onUnfollowUser = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.page = 1
                        strongSelf.getPostAPI(page: strongSelf.page, postType: self?.postType)//getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }
           }
            cell.onLikeCount = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "LikeUserListScreen") as! LikeUserListScreen
                vc.modalPresentationStyle = .overCurrentContext
                vc.postId = self?.itemArray[indexPath.row].id ?? 0
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.onReShare = { [weak self] in
                let reshareVC = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
                reshareVC.modalPresentationStyle = .fullScreen
                reshareVC.postObject = self?.itemArray[indexPath.row]
                reshareVC.completeAddNewPostDelegate = self
                self?.superVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
            }
            cell.onComment = { [weak self] in
                self?.didSelectData(indexPath: indexPath.row)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0{
            self.didSelectData(indexPath: indexPath.row)
        }else{
            if self.topFiveItemArray.count > 0{
                let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "MyLibraryPostDetailScreen") as! MyLibraryPostDetailScreen
                vc.isFromOtherUserProfile = self.userId != Utility.getCurrentUserId()
                vc.postObj = self.topFiveItemArray[indexPath.row]//[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.postTableViewHeight.constant = tableView.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 1{
            if !self.itemArray.isEmpty && self.itemArray.count > 1{
                return true
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 1{
            if topFiveItemArray.count > indexPath.row{
                if topFiveItemArray[indexPath.row].user_id == Utility.getCurrentUserId(){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
            
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.displayDeleteDialogue(id: self.topFiveItemArray[indexPath.row].id ?? 0, index: indexPath.row)
        }
    }
    
    func getCaptionLineNumber(text:String)-> CGFloat{
        let captionHiddenlabel = UILabel(frame: CGRect(x: 0, y: 0, width: (screenWidth-50), height: .greatestFiniteMagnitude))
        captionHiddenlabel.numberOfLines = 0
        captionHiddenlabel.text = text
        captionHiddenlabel.font = UIFont(name:"SourceSansPro-Regular", size: 17)!
        captionHiddenlabel.sizeToFit()
        return captionHiddenlabel.frame.height
    }
}
 // MARK: - EXPANDABLE DELEGATE
extension ProfileTabbarScreen: ExpandableLabelDelegate{
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.postTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.postTableView)
        if let indexPath = self.postTableView.indexPathForRow(at: point) as IndexPath? {
            //            if let  cell = self.postTableView.cellForRow(at: indexPath) as? HomePostCell{
            self.collapedArray[indexPath.row] = false
            //                cell.captionLabel.collapsed = false
            //            }
            DispatchQueue.main.async { [weak self] in
                self?.postTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        self.postTableView.endUpdates()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.searchView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9411764706, alpha: 1)
       
        self.searchTextField.resignFirstResponder()
        
        self.removeGesture()
    }
    
    func removeGesture(){
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
            }
        }
    }
}
//MARK: - TEXTFIELD DELEGATE
extension ProfileTabbarScreen: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.checkTextFieldChangedValue(textField:)),object: textField)
        self.perform(#selector(self.checkTextFieldChangedValue(textField:)),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.checkTextFieldChangedValue(textField:)),object: textField)
        self.perform(#selector(self.checkTextFieldChangedValue(textField:)),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        self.searchView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9411764706, alpha: 1)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        self.searchView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9411764706, alpha: 1)
        self.removeGesture()
    }
}
//MARK: - ADD NEW POST DELEGATE
extension ProfileTabbarScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page, postType: self.postType)
    }
}
extension ProfileTabbarScreen: TableViewReorderDelegate {
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.topFiveItemArray[sourceIndexPath.row]
        self.topFiveItemArray.remove(at: sourceIndexPath.row)
        self.topFiveItemArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
        //        self.editDoneButton.isHidden = self.checkPostPosititonArray()
    }
}
extension ProfileTabbarScreen {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: self.view)
    }
}

//MARK: - CACHE IMAGE
extension ProfileTabbarScreen{
    

    func startImageDownload(){
        guard let obj = self.itemArray.first(where: {$0.localImagePath == nil && $0.media != nil && $0.post_type == PostType.book.rawValue}) else {
            print("All cached")
            return
        }
    
        guard let url = URL(string: obj.media ?? "") else {
            return
        }
//        let blockOperation = BlockOperation { [weak self] in
            self.downloadImageURL(fileName: url.lastPathComponent, id: obj.id ?? 0,imageURL: obj.media ?? "")
//        }
//        let queue = OperationQueue()
//        queue.addOperation(blockOperation)
//        print("isReady :-- \(blockOperation.isReady)")
    }
    
    //MARK: - GENERATE IMAGE PRESIGNED URL
    func downloadImageURL(fileName: String,id: Int,imageURL: String){
        PresignedImageCacheHelper.downloadAndReturnPresignedImage(fileName: fileName, imageURL: imageURL) { [weak self] (error, imageURL) in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                if let imgURL = imageURL{
                    if strongSelf.postTableView.tag == 0{
                        if let index =  strongSelf.itemArray.firstIndex(where: {$0.id == id}){
                            strongSelf.itemArray[index].localImagePath = imgURL
                            UIView.performWithoutAnimation {
                                let loc = strongSelf.postTableView.contentOffset
                                strongSelf.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                                strongSelf.postTableView.contentOffset = loc
                                strongSelf.startImageDownload()
                            }
                        }
                    }
                }else{
                    strongSelf.startImageDownload()
                }
            }
        }
    }
    
    func startTopFiveImageDownload(){
        guard let obj = self.topFiveItemArray.first(where: {$0.localImagePath == nil && $0.media != nil && $0.post_type == PostType.book.rawValue}) else {
            print("All cached")
            return
        }
    
        guard let url = URL(string: obj.media ?? "") else {
            return
        }
//        let blockOperation = BlockOperation { [weak self] in
            self.downloadTopFiveImageURL(fileName: url.lastPathComponent, id: obj.id ?? 0,imageURL: obj.media ?? "")
//        }
//        let queue = OperationQueue()
//        queue.addOperation(blockOperation)
//        print("isReady :-- \(blockOperation.isReady)")
    }
    
    //MARK: - GENERATE IMAGE PRESIGNED URL
    func downloadTopFiveImageURL(fileName: String,id: Int,imageURL: String){
        PresignedImageCacheHelper.downloadAndReturnPresignedImage(fileName: fileName, imageURL: imageURL) { [weak self] (error, imageURL) in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                if let imgURL = imageURL{
                    if strongSelf.postTableView.tag == 1{
                        if let index =  strongSelf.topFiveItemArray.firstIndex(where: {$0.id == id}){
                            strongSelf.topFiveItemArray[index].localImagePath = imgURL
                            UIView.performWithoutAnimation {
                                let loc = strongSelf.postTableView.contentOffset
                                strongSelf.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                                strongSelf.postTableView.contentOffset = loc
                                strongSelf.startTopFiveImageDownload()
                            }
                        }
                    }
                }else{
                    strongSelf.startTopFiveImageDownload()
                }
            }
        }
    }
}
