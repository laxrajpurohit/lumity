//
//  LikePostScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit
import ExpandableLabel
import SDWebImageLinkPlugin
import PanModal

class LikePostScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var searchTextField: dateSportTextField!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var PostTypeFilterCollectionView: UICollectionView!
    @IBOutlet weak var searchView: dateSportView!
    @IBOutlet weak var searchBottomView: UIView!
    
    var superVC: TabBarScreen?
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: true),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: true),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: true)]
    
    var collapedArray: [Bool] = []
    
    var page: Int = 1
    var itemArray: [PostReponse] = []
    var meta: Meta?
    var hasMorePage: Bool = false
    var searhText: String?
    var postType: String?
    var searchUserName: String?
    
    let refreshControl = UIRefreshControl()
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
   
    
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
        
        
      
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page,postType: self.postType,search: self.searhText,userName: self.searchUserName)

        self.searchTextField.clearButtonMode = .always
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
    
    @objc func pullRefreshHomeList(_ sender: Any){
        self.page = 1
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText,userName: self.searchUserName)
    }
    
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }
    
    func downloadMetaData(link: String,id: Int,reshare: Bool){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
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
    
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            self.searchUserName = nil
//            self.searhText = nil
            //            self.postType = nil
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText,userName: self.searchUserName)
        }else{
            self.page = 1
            self.searchUserName = text
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText,userName: self.searchUserName)
            
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
    
    func deletePostAPI(postObj: PostReponse){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            guard let id = postObj.id else {
                return
            }
            PostService.shared.deletePost(id: id) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let strongSelf = self else {
                    return
                }
                strongSelf.page = 1
                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText, userName: strongSelf.searchUserName)
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
    
    //MARK:- POST API
    func getPostAPI(page: Int,postType: String?,search: String?,userName: String?){
//        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
//                Utility.showIndicator()
            }
            let data = GetPostRequest(post_type: postType, search: search,username: userName, explore: nil, groupId: nil)
            ProfileService.shared.getLikePost(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let res = response.postListResponse{
                    if page == 1{
                        self?.itemArray = res
                        self?.collapedArray = [Bool](repeating: true, count: self?.itemArray.count ?? 0)
                        UIView.performWithoutAnimation {
                            let loc = self?.postTableView.contentOffset
                            self?.postTableView.reloadData()
                            self?.postTableView.layoutIfNeeded()
                            self?.postTableView.contentOffset = loc ?? .zero
                        }
//                        self?.scrollToTop()
                    }else{
                        self?.appendPostDataTableView(data: res)
                    }
                    self?.startImageDownload()
                }
                if (self?.itemArray.count)! < 0{
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
    
    
    
    func appendPostDataTableView(data: [PostReponse]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.collapedArray = [Bool](repeating: true, count: self.itemArray.count)
        self.postTableView.insertRows(at: indexPath, with: .bottom)
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
                        self.getPostAPI(page: self.page,postType: self.postType,search: self.searhText,userName: self.searchUserName)
                    }
                }
            }
        }
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
                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText, userName: strongSelf.searchUserName)
            }
            
            self.navigationController?.pushViewController(reshareVC, animated: true)
        }else{
            let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
            vc.postId = data.id ?? 0
            vc.postDetailData = data
            vc.isFromReShare = true
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
                strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText,userName: strongSelf.searchUserName)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHideSearchView(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        Utility.removeLocalData()
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
        let rootvc = UINavigationController(rootViewController: control)
        appDelegate.window?.rootViewController = rootvc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func onAddPost(_ sender: UIButton) {
//        let control = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
//        control.superVC = self
//        self.navigationController?.pushViewController(control, animated: true)
    }
    
}
//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension LikePostScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText,userName: self.searchUserName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: 46)
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension LikePostScreen: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK:- RESHARE
        if self.itemArray[indexPath.row].reshare == true{
            let cell = self.postTableView.dequeueReusableCell(withIdentifier: "ResharePostCell") as! ResharePostCell
            cell.item = self.itemArray[indexPath.row]
            cell.viewController = self
            cell.tabBarVC = self.superVC
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
                cell.readMoreLineView.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
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
            
            cell.onSubPost = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                vc.postId = self?.itemArray[indexPath.row].reshare_main_post_id ?? 0
                vc.isFromReShare = true
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
                    strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText, userName: strongSelf.searchUserName)
                }
                
                self?.navigationController?.pushViewController(vc, animated: true)
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
                    vc.messageNavigationType = MessageNavigationType.likeScreen.rawValue
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
                self?.navigationController?.presentPanModal(rowVC)
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
                        strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText,userName: strongSelf.searchUserName)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.navigationController?.presentPanModal(rowVC)
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
                    vc.isHideBack = false
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
                        vc.postItemDataDetailData = strongSelf.itemArray[indexPath.row]
                        vc.messageNavigationType = MessageNavigationType.likeScreen.rawValue
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
                    self?.navigationController?.presentPanModal(rowVC)
                }
                cell.onLike = {[weak self] in
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
                                
                                self?.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                            self?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        vc.onUnfollowUser = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.page = 1
                            strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText,userName: strongSelf.searchUserName)
                        }
                        let rowVC: PanModalPresentable.LayoutType = vc
                        self?.navigationController?.presentPanModal(rowVC)
                        //                    self?.navigationController?.present(vc, animated: true, completion: nil)
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
                    self?.navigationController?.present(reshareVC, animated: true, completion: nil)
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
            
//            let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "1958D0"),NSAttributedString.Key.font: cell.captionLabel.font!])
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
            cell.onShare = { [weak self] in
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostShareScreen") as! PostShareScreen
                vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                vc.onSendMessage = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
                    vc.postItemDataDetailData = strongSelf.itemArray[indexPath.row]
                    vc.messageNavigationType = MessageNavigationType.likeScreen.rawValue
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
                vc.onShareMessage = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }

                    Utility.showAlert(vc: strongSelf, message: "Your message has been sent. Thank you for sharing!")
                }
                let rowVC: PanModalPresentable.LayoutType = vc
                self?.navigationController?.presentPanModal(rowVC)
            }
            cell.onLike = {[weak self] in
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
                    vc.onReportPost = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.postId = self?.itemArray[indexPath.row].id
                        
                        vc.onSuccessReport = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            
                            self?.itemArray.remove(at: indexPath.row)
                            self?.postTableView.reloadData()
                            
                            self?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        self?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                    
                    vc.onUnfollowUser = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.page = 1
                        strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText,userName: strongSelf.searchUserName)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.navigationController?.presentPanModal(rowVC)
                    //                self?.navigationController?.present(vc, animated: true, completion: nil)
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
                self?.navigationController?.present(reshareVC, animated: true, completion: nil)
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
    //
    
    func getCaptionLineNumber(text:String)-> CGFloat{
        let captionHiddenlabel = UILabel(frame: CGRect(x: 0, y: 0, width: (screenWidth-50), height: .greatestFiniteMagnitude))
        captionHiddenlabel.numberOfLines = 0
        captionHiddenlabel.text = text
        captionHiddenlabel.font = UIFont(name:"SourceSansPro-Regular", size: 17)!
        captionHiddenlabel.sizeToFit()
        return captionHiddenlabel.frame.height
    }
}
//MARK: - EXPANDABLE DELEGATE
extension LikePostScreen: ExpandableLabelDelegate{
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
}

//MARK: - TEXTFIELD DELEGATE
extension LikePostScreen: UITextFieldDelegate{
    
    
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
//MARK: - ADD NEW POST DELEGATE
extension LikePostScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.postType = self.getPostType()
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText,userName: self.searchUserName)
    }
}
//MARK: - CACHE IMAGE{
extension LikePostScreen{
    

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
