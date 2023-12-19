//
//  HomeScreen.swift
//  Source-App
//
//  Created by iroid on 31/03/21.
//

import UIKit
import ExpandableLabel
import SDWebImageLinkPlugin
import PanModal
import UserNotifications

// HomeScreen: Manages the home screen interface.
class HomeScreen: UIViewController {
    
    // Outlets for UI components.
    @IBOutlet weak var searchTextField: dateSportTextField!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var PostTypeFilterCollectionView: UICollectionView!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var messageCountView: dateSportView!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var searchView: dateSportView!
    @IBOutlet weak var searchBottomView: UIView!
    
    // Data models for post types and various states.
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: true),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: true),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: true)]
    
    var collapedArray: [Bool] = []
    var superVC: TabBarScreen?
    var page: Int = 1
    var itemArray: [PostReponse] = []
    var meta: Meta?
    var hasMorePage: Bool = false
    
    var searhText: String?
    var postType: String?
    
    let refreshControl = UIRefreshControl()
    
    
    // Initial setup when the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    // Actions to perform each time the view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postTableView.reloadData()
        self.getChatCount()
    }
   
    // Sets up initial details for the view.
    func initialDetail(){
        self.navigationController?.isNavigationBarHidden = true
        self.searchTextField.delegate = self
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.pullRefreshHomeList(_:)), for: .valueChanged)
        let nib = UINib(nibName: "PostTypeFilterCell", bundle: nil)
        PostTypeFilterCollectionView.register(nib, forCellWithReuseIdentifier: "PostTypeFilterCell")
        self.postTableView.register(UINib(nibName: "HomePostCell", bundle: nil), forCellReuseIdentifier: "HomePostCell")
        self.postTableView.register(UINib(nibName: "LinkPostCell", bundle: nil), forCellReuseIdentifier: "LinkPostCell")
        self.postTableView.register(UINib(nibName: "ResharePostCell", bundle: nil), forCellReuseIdentifier: "ResharePostCell")
        
        self.registerForRemoteNotification()
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page,postType: self.postType,search: nil)
        self.searchTextField.clearButtonMode = .always
    }
    
    // Registers the app for remote notifications.
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // Combines selected post type IDs into a comma-separated string.
    func getPostType() -> String{
        var idArray : [Int] = []
        for i  in self.postTypeData{
            if i.isSelected == true{
                idArray.append(i.postType ?? 0)
            }
        }
        return idArray.map { String($0) }.joined(separator: ",")
        
    }
    
    // Counts the number of selected post types.
    func getAllTypePostSelectionCount() -> Int{
        var idArray : [Int] = []
        for i  in self.postTypeData{
            if i.isSelected == true{
                idArray.append(i.postType ?? 0)
            }
        }
        return idArray.count
        
    }
    
    // Refreshes the home list when the user pulls down the list.
    @objc func pullRefreshHomeList(_ sender: Any){
        self.page = 1
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
    }
    
    // Stops the refresh control animation.
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }
    
    func downloadMetaData(link: String,id: Int,reshare: Bool){
        if let link = URL(string: link){
            Utility.displayLinkView(link: link) { [weak self] (error, linkMetaData) in
                if let index = self?.itemArray.firstIndex(where: {$0.id == id && $0.reshare == reshare}){
                    self?.itemArray[index].linkMeta = linkMetaData
                    DispatchQueue.main.async { [weak self] in
                        UIView.performWithoutAnimation {
                            let loc = self?.postTableView.contentOffset
                            self?.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
                    }
                }
                self?.startDownload()
            }
        }else{
            if let index = self.itemArray.firstIndex(where: {$0.id == id && $0.reshare == reshare}){
                let data = LPLinkMetadata()
                //                data.originalURL = URL(string: link) ??
                self.itemArray[index].linkMeta = data
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        let loc = self?.postTableView.contentOffset
                        self?.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        self?.postTableView.contentOffset = loc ?? .zero
                    }
                }
            }
            self.startDownload()
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
    
    // Triggers when text in the search text field changes.
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            self.searhText = nil
            //            self.postType = nil
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
        }else{
            self.page = 1
            self.searhText = text
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
            
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
    
    // Changes the like status of a post in the UI.
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
                    self?.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    self?.postTableView.contentOffset = loc ?? .zero
                }
            }
            //            self.postTableView.reloadData()
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
    
    // Perform network request to delete a post.
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
                self?.getPostAPI(page: 1, postType: self?.postType,search: self?.searhText)
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
    
    // Continues the editing process for a post.
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
   
    // Fetches the count of new messages or notifications.
    func getChatCount(){
        if Utility.isInternetAvailable(){
            MessageService.shared.getChatCount { status, response in
                if let res = response?.messageCountData{
                    print(res.count)
                    if res.count == 0{
                        self.messageCountView.isHidden = true
                    }else{
                        self.messageCountLabel.text = "\(res.count ?? 0)"
                        self.messageCountView.isHidden = false
                    }
                    if res.notification_count == 0{
                        self.notificationImageView.image = UIImage(named: "like_tabbar_icon")
                        
                    }else{
                        self.notificationImageView.image = UIImage(named: "heart_notification_av")
                        
                    }
                    
                }
            } failure: { error in
                print(error)
            }
        }else{
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    
    //MARK:- POST API
    func getPostAPI(page: Int,postType: String?,search: String?){
//        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
               // Utility.showIndicator()
            }
            let data = GetPostRequest(post_type: postType, search: search,username: nil, explore: nil, groupId: nil)
            PostService.shared.getAllPost(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.postListResponse{
                    if page == 1{
                        self?.itemArray = res
                        self?.collapedArray = [Bool](repeating: true, count: self?.itemArray.count ?? 0)
                        self?.postTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self?.postTableView.scrollToTop(animated: true)
                        }
                    }else{
                        self?.appendPostDataTableView(data: res)
                    }
                    self?.startImageDownload()
                }
                if (self?.itemArray.count) ?? 0 < 0{
                    self?.postTableView.reloadData()
                }else{
                    self?.startDownload()
                }
                
                self?.stopPulling()
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
    
    // Append more data to the post table view.
    func appendPostDataTableView(data: [PostReponse]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.collapedArray = [Bool](repeating: true, count: self.itemArray.count)
        self.postTableView.insertRows(at: indexPath, with: .bottom)
    }
    
    // Handles scroll behavior for lazy loading or pagination.
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
                        self.getPostAPI(page: self.page,postType: self.postType,search: self.searhText)
                    }
                }
            }
        }
    }
    
    // Actions to perform on logout button tap.
    @IBAction func onLogout(_ sender: UIButton) {
        Utility.removeLocalData()
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
        let rootvc = UINavigationController(rootViewController: control)
        appDelegate.window?.rootViewController = rootvc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // Actions to perform on adding a new post.
    @IBAction func onAddPost(_ sender: UIButton) {
//        self.ShowAlert()
//
        let control = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
        control.superVC = self
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    // Display an alert with multiple options.
    func ShowAlert(){
        // Create an instance of UIAlertController
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .alert)

        // Add buttons (actions)
        alert.addAction(UIAlertAction(title: "Book", style: .default, handler: { (_) in
            print("Option 1 selected")
            let control = STORYBOARD.bookList.instantiateViewController(withIdentifier: "BookListScreen") as! BookListScreen
            control.uploadType = UploadType.book.rawValue
            self.navigationController?.pushViewController(control, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "YouTube Videos", style: .default, handler: { (_) in
            print("Option 2 selected")
            let control = STORYBOARD.bookList.instantiateViewController(withIdentifier: "BookListScreen") as! BookListScreen
            control.uploadType = UploadType.youTubeVideo.rawValue
            self.navigationController?.pushViewController(control, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "YouTube Channel", style: .default, handler: { (_) in
            print("Option 3 selected")
            let control = STORYBOARD.bookList.instantiateViewController(withIdentifier: "BookListScreen") as! BookListScreen
            control.uploadType = UploadType.youTubeChannel.rawValue
            self.navigationController?.pushViewController(control, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Show the alert
        self.present(alert, animated: true, completion: nil)

    }
    
    // Actions to perform on notification button tap.
    @IBAction func onNotification(_ sender: Any) {
        let vc = STORYBOARD.notification.instantiateViewController(withIdentifier: "NotificationScreen") as! NotificationScreen
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Actions to perform on groups button tap.
    @IBAction func onGroups(_ sender: Any) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupListScreen") as! GroupListScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    // Actions to perform on message button tap.
    @IBAction func onMessage(_ sender: Any) {
        let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageListScreen") as! MessageListScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Actions to perform on hiding the search view.
    @IBAction func onHideSearchView(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
    }
    
    // Handling selection of a specific post.
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
                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
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
                    DispatchQueue.main.async { [weak self] in
                        UIView.performWithoutAnimation {
                            let loc = self?.postTableView.contentOffset
                            self?.postTableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .none)
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
                    }
                }
            }
            vc.onSuccessReport = { [weak self] in
                UIView.performWithoutAnimation {
                    let loc = self?.postTableView.contentOffset
                    self?.itemArray.remove(at: indexPath)
                    self?.postTableView.reloadData()
                    self?.postTableView.contentOffset = loc ?? .zero
                }
            }
            vc.onUnFollowUser = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension HomeScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTypeFilterCell", for: indexPath) as! PostTypeFilterCell
        cell.item = postTypeData[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = postTypeData[indexPath.row]
        if data.isSelected ?? false{
            guard self.getAllTypePostSelectionCount() > 1 else {
                return
            }
            data.isSelected = false
        }else{
            data.isSelected = true
        }
        postTypeData[indexPath.row] = data
        PostTypeFilterCollectionView.reloadData()
        self.page = 1
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: 46)
    }
}
// MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension HomeScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.itemArray.count
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK:- RESHARE
        if self.itemArray[indexPath.row].reshare == true{
            let cell = self.postTableView.dequeueReusableCell(withIdentifier: "ResharePostCell") as! ResharePostCell
            cell.item = self.itemArray[indexPath.row]
            cell.viewController = self
            cell.tabBarVC = self.superVC
//            let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "1958D0"),NSAttributedString.Key.font: UIFont(name: "Calibri", size: 15)!])
//            cell.captionLabel.delegate = self
//            cell.layoutIfNeeded()
//            cell.captionLabel.shouldCollapse = true
//            cell.captionLabel.collapsedAttributedLink = attributedString
//            cell.captionLabel.textReplacementType = .character
//            cell.captionLabel.collapsed = self.collapedArray[indexPath.row]
//            cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 2
//            cell.captionLabel.text = self.itemArray[indexPath.row].caption
            
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
                cell.readMoreButton.isHidden = true
                cell.readMoreLineView.isHidden = true
            }else{
                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
            }
            cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
            print("read first more")

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
            
            //user detail
            cell.onUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].user_id
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.onPostImage = { [weak self] in
                let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl =  self?.itemArray[indexPath.row].media ?? ""
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self?.present(confirmAlertController, animated: true, completion: nil)
            }
            cell.onSubUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].userDetails?.user_id
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.onLinkClick = {[weak self ] in
                let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                control.linkUrl = self?.itemArray[indexPath.row].link ?? ""
                self?.navigationController?.pushViewController(control, animated: true)
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
                    strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
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
                    vc.postItemDataDetailData = strongSelf.itemArray[indexPath.row]
                    vc.messageNavigationType = MessageNavigationType.homeScreen.rawValue
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
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
                        strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                }
                
//                self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
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
//                cell.captionLabel.text = nil
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
                    cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                    cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                }
                
                cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3

                cell.onReadMore = {[weak self] in
                    self?.collapedArray[indexPath.row] = false
    //                cell.readMoreButton.isHidden = true
                    UIView.performWithoutAnimation { [weak self]
                        in
                        let loc = self?.postTableView.contentOffset
                        self?.postTableView.reloadRows(at: [indexPath], with: .bottom)
                        self?.postTableView.contentOffset = loc ?? .zero
                    }
                }
                
                //user detail
                cell.onUser = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    vc.userId = self?.itemArray[indexPath.row].user_id
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
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
                        vc.messageNavigationType = MessageNavigationType.homeScreen.rawValue
                        self?.navigationController?.pushViewController(vc, animated: true)
    //                    strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
                    }
                    vc.onShareMessage = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }

                        Utility.showAlert(vc: strongSelf, message: "Your message has been sent. Thank you for sharing!")
                    }
                    vc.onSendPostOnGroup = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "MyGroupListScreen") as! MyGroupListScreen
//                        vc.postItemDataDetailData = self?.itemArray[indexPath.row]
//                        vc.messageNavigationType = MessageNavigationType.homeScreen.rawValue
                        self?.navigationController?.pushViewController(vc, animated: true)
//                        strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
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
                                UIView.performWithoutAnimation {
                                    let loc = self?.postTableView.contentOffset
                                    self?.postTableView.reloadData()
                                    self?.postTableView.contentOffset = loc ?? .zero
                                }
                                
                                self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                            self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        vc.onUnfollowUser = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.page = 1
                            strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                        }
                        let rowVC: PanModalPresentable.LayoutType = vc
                        self?.superVC?.navigationController?.presentPanModal(rowVC)
                        //                    self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
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
            
            //let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "1958D0"),NSAttributedString.Key.font: cell.captionLabel.font!])
//            cell.captionLabel.delegate = self
//
//            cell.layoutIfNeeded()
//
//            cell.captionLabel.shouldCollapse = true
//            cell.captionLabel.collapsedAttributedLink = attributedString
//            cell.captionLabel.textReplacementType = .character
//            cell.captionLabel.collapsed = self.collapedArray[indexPath.row]
          //  self.postTableView.beginUpdates()

            cell.captionLabel.numberOfLines = 0
            cell.captionLabel.text = self.itemArray[indexPath.row].caption
            cell.captionLabel.adjustsFontSizeToFitWidth = false
            cell.captionLabel.lineBreakMode = .byTruncatingTail
            if getCaptionLineNumber(text: self.itemArray[indexPath.row].caption ?? "") <= 64.5{
//                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreButton.isHidden = true
                cell.readMoreLineView.isHidden = true
            }else{
                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
            }
            cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
            print("read first more")
            //self.postTableView.endUpdates()

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
            
            cell.onUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].user_id
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            //MARK:- Preview
            cell.onPostImage = { [weak self] in
                let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                confirmAlertController.imageUrl =  self?.itemArray[indexPath.row].media ?? ""
                confirmAlertController.modalPresentationStyle = .overFullScreen
                self?.present(confirmAlertController, animated: true, completion: nil)
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
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.messageNavigationType = MessageNavigationType.homeScreen.rawValue
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
                        strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.superVC?.navigationController?.presentPanModal(rowVC)
                    //                self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
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
        self.didSelectData(indexPath: indexPath.row)
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
// MARK: - EXPANDABLELABEL DELEGATE
extension HomeScreen: ExpandableLabelDelegate{
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
    
    //    func willCollapseLabel(_ label: ExpandableLabel) {
    //        self.postTableView.beginUpdates()
    //    }
    //
    //    func didCollapseLabel(_ label: ExpandableLabel) {
    //        let point = label.convert(CGPoint.zero, to: self.postTableView)
    //        if let indexPath = self.postTableView.indexPathForRow(at: point) as IndexPath? {
    //            if let  cell = self.postTableView.cellForRow(at: indexPath) as? HomePostCell{
    //                cell.captionLabel.collapsed = true
    //            }
    //            DispatchQueue.main.async { [weak self] in
    //                self?.postTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    //            }
    //        }
    //        self.postTableView.endUpdates()
    //    }
}

// MARK: - TEXTFIELD DELEGATE
extension HomeScreen: UITextFieldDelegate{
    
    
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
        self.searchBottomView.isHidden = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        self.searchView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.searchBottomView.isHidden = true
    }
}
// MARK: - ADD NEW POST DELEGATE
extension HomeScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
    }
}
// MARK: - OTHER HELPER METHODS
extension HomeScreen {
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
// MARK: - SCROLL TO TOP
extension UITableView {
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }

  func scrollToTop(animated: Bool) {
    let indexPath = IndexPath(row: 0, section: 0)
    if self.hasRowAtIndexPath(indexPath: indexPath) {
      self.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
  }
}
//MARK: - CACHE IMAGE{
extension HomeScreen{
    

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
    
    //MARK:- GENERATE IMAGE PRESIGNED URL
    func downloadImageURL(fileName: String,id: Int,imageURL: String){
        PresignedImageCacheHelper.downloadAndReturnPresignedImage(fileName: fileName, imageURL: imageURL) { [weak self] (error, imageURL) in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                if let imgURL = imageURL{
                   
                    if let index =  strongSelf.itemArray.firstIndex(where: {$0.id == id}){
                        strongSelf.itemArray[index].localImagePath = imgURL
                        UIView.performWithoutAnimation {
                            let loc = strongSelf.postTableView.contentOffset
                            strongSelf.postTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            strongSelf.postTableView.contentOffset = loc
                            strongSelf.startImageDownload()
                        }
                    }
                }else{
                    strongSelf.startImageDownload()
                }
            }
        }
    }
}
