//
//  GroupDetailScreen.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit
import PanModal
import ExpandableLabel
import SDWebImageLinkPlugin


class GroupDetailScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupBioLabel: UILabel!
    @IBOutlet weak var groupMemberCountLabel: UILabel!
    
    @IBOutlet weak var postNotFoundLabel: UILabel!
    @IBOutlet weak var searchView: dateSportView!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var editGroupButton: UIButton!
    
    @IBOutlet weak var searchBottomView: UIView!

    // MARK: - VARIABLE DECLARE
    var groupListData:GroupListData?
    var superVC: TabBarScreen?
    var groupListVC: GroupListScreen?
    var collapedArray: [Bool] = []
    var page: Int = 1
    var itemArray: [PostReponse] = []
    var meta: Meta?
    var hasMorePage: Bool = false
    
    var searhText: String?
    var postType: String?
    
    let refreshControl = UIRefreshControl()
    var groupId:Int? = nil
    
    var onUpdateGroupListCell:((GroupListData)->Void)? = nil
    var deleteGroupDelegate: DeleteGroupDelegate?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialDetail()
        //        self.postTableView.sectionHeaderHeight = UITableView.automaticDimension;
        //        self.postTableView.estimatedSectionHeaderHeight = 150;
    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        // Recalculates height
    //        self.postTableView.beginUpdates()
    //        self.postTableView.endUpdates()
    //    }
    
    
    func initialDetail(){
        //
        if let groupListData = groupListData {
            self.onUpdateGroupListCell?(groupListData)
        }else{
            self.getGroupDetailData(groupId: self.groupId ?? 0)
        }
        
        self.searchTextField.delegate = self
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.pullRefreshHomeList(_:)), for: .valueChanged)
        self.postTableView.register(UINib(nibName: "GroupDetailUserCell", bundle: nil), forCellReuseIdentifier: "GroupDetailUserCell")
        self.postTableView.register(UINib(nibName: "HomePostCell", bundle: nil), forCellReuseIdentifier: "HomePostCell")
        self.postTableView.register(UINib(nibName: "LinkPostCell", bundle: nil), forCellReuseIdentifier: "LinkPostCell")
        self.postTableView.register(UINib(nibName: "ResharePostCell", bundle: nil), forCellReuseIdentifier: "ResharePostCell")
        self.postTableView.register(UINib(nibName: "TextPostTableViewCell", bundle: nil), forCellReuseIdentifier: "TextPostTableViewCell")
        
        self.getPostAPI(page: self.page,postType: self.postType,search: nil)
        self.searchTextField.clearButtonMode = .always
    }
    
    func setUpdata(){
        Utility.setImage(groupListData?.profile, imageView: profileImageView)
        self.groupNameLabel.text = self.groupListData?.name
        self.groupBioLabel.text = self.groupListData?.bio
        self.groupMemberCountLabel.text = "\(self.groupListData?.groupMembersCount ?? 0) Members"
        
        if groupListData?.isCreatedByMe == 1{
            self.editGroupButton.setTitle("Edit Group", for: .normal)
            
            //            self.editGroupButton.gradientButton("Edit Group", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 5, cornerRadius: )
            
        }else{
            self.editGroupButton.setTitle(groupListData?.isJoin == 1 ? "Leave Group":"Join", for: .normal)
            
            //            self.editGroupButton.gradientButton(groupListData?.isJoin == 1 ? "Leave Group":"Join", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 5)
        }
    }
    
    
    
    @objc func pullRefreshHomeList(_ sender: Any){
        self.page = 1
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
    }
    
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        if let groupListData = groupListData {
            self.onUpdateGroupListCell?(groupListData)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditGroup(_ sender: Any) {
        if self.groupListData?.isCreatedByMe == 1{
            let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "EditGroupScreen") as! EditGroupScreen
            vc.groupId = self.groupId ?? 0
            if let groupListVC = self.groupListVC{
                vc.deleteGroupDelegate = groupListVC
            }
            vc.onEditGroupClick = { [weak self]  updatedObj in
                self?.groupListData = updatedObj
                self?.setUpdata()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if self.groupListData?.isJoin == 1{
                self.deleteGroup()
            }else{
                self.groupListData?.isJoin = 1
                self.editGroupButton.setTitle(groupListData?.isJoin == 1 ? "Leave Group":"Join", for: .normal)
                self.doJoinAPI()
            }
        }
    }
    @IBAction func onHideSearchView(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func onAddPost(_ sender: UIButton) {
        let control = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
        control.isFromGroup = true
        control.groupId = self.groupId ?? 0
        control.superVC = self
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onInvite(_ sender: UIButton) {
        let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "InviteGroupMemberScreen") as! InviteGroupMemberScreen
        vc.groupId = self.groupId ?? 0
        vc.onRefreshMemberCount = {  [weak self ] memberCount in
            self?.groupListData?.groupMembersCount = memberCount
            self?.groupMemberCountLabel.text = "\(self?.groupListData?.groupMembersCount ?? 0) Members"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteGroup() {
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to leave this group?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //Delete action
            self.removeAndDeleteGroup(groupId: self.groupId ?? 0, userId: Utility.getCurrentUserId())
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - DELETE POST ALERT
    func deletePostAlert(postObj: PostReponse){
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.destructive,handler: { [weak self] (alert) in
            self?.deletePostAPI(postObj: postObj)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    
    func goFurtherPostEdit(postObj: PostReponse){
        if postObj.reshare == true{
            let reshareVC = STORYBOARD.post.instantiateViewController(withIdentifier: "SharePostScreen") as! SharePostScreen
            reshareVC.modalPresentationStyle = .fullScreen
            reshareVC.postObject = postObj
            reshareVC.completeAddNewPostDelegate = self
            reshareVC.isEdit = true
            self.navigationController?.present(reshareVC, animated: true, completion: nil)
        }else{
            switch postObj.post_type {
            case PostType.podcast.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
                vc.superVC = self
                vc.postObj = postObj
                vc.groupId = groupId
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case PostType.video.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
                vc.superVC = self
                vc.postObj = postObj
                vc.groupId = groupId
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case PostType.book.rawValue:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
                vc.postObj = postObj
                vc.groupId = groupId
                vc.superVC = self
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "TextPostScreen") as! TextPostScreen
                vc.superVC = self
                vc.groupId = self.groupId
                vc.postObj = postObj
                vc.completeAddNewPostDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
                vc.postObj = postObj
                vc.groupId = groupId
                vc.superVC = self
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
        
    }
    
    func didSelectData(indexPath:Int){
        let data = itemArray[indexPath]
        
        if data.reshare == true{
            let reshareVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
            reshareVC.postDetailData = data
            reshareVC.postId = data.id
            reshareVC.groupPostId = data.groupPostId
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
            vc.postId = data.id
            vc.groupPostId = data.groupPostId
            vc.groupId = groupId
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
    
    func downloadMetaData(link: String,id: Int,reshare: Bool){
        if let link = URL(string: link){
            Utility.displayLinkView(link: link) { [weak self] (error, linkMetaData) in
                if let index = self?.itemArray.firstIndex(where: {$0.groupPostId == id && $0.reshare == reshare}){
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
            if let index = self.itemArray.firstIndex(where: {$0.groupPostId == id && $0.reshare == reshare}){
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
        if let link = item.link,let id = item.groupPostId,let reshare = item.reshare{
            self.downloadMetaData(link: link,id: id,reshare: reshare)
        }else{
            self.startDownload()
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
                        self.getPostAPI(page: self.page,postType: self.postType,search: self.searhText)
                    }
                }
            }
        }
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension GroupDetailScreen: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "GroupDetailUserCell") as? GroupDetailUserCell
        Utility.setImage(groupListData?.profile, imageView: headerView?.profileImageView)
        headerView?.groupNameLabel.text = self.groupListData?.name
        headerView?.groupBioLabel.text = self.groupListData?.bio
        headerView?.groupMemberCountLabel.text = "\(groupListData?.groupMembersCount ?? 0) Members"
        
        if groupListData?.isCreatedByMe == 1{
            //            headerView?.editGroupButton.setTitle("Edit Group", for: .normal)
            
            headerView?.editGroupButton.gradientButton("Edit Group", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 1, cornerRadius: 5)
            
        }else{
            //            headerView?.editGroupButton.setTitle(groupListData?.isJoin == 1 ? "Leave Group":"Join", for: .normal)
            
            headerView?.editGroupButton.gradientButton(groupListData?.isJoin == 1 ? "Leave Group":"Join", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 1, cornerRadius: 5)
            
        }
        headerView?.onMember = { [weak self] in
            let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupUserListScreen") as! GroupUserListScreen
            vc.groupId = self?.groupId ?? 0
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        headerView?.onViewProfile = { [weak self] in
            if let profilePhoto = self?.groupListData?.profile{
                if profilePhoto != ""{
                    let confirmAlertController = STORYBOARD.home.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
                    confirmAlertController.imageUrl = profilePhoto
                    confirmAlertController.modalPresentationStyle = .overFullScreen
                    self?.present(confirmAlertController, animated: true, completion: nil)
                }
            }
        }
        headerView?.onEdit = { [weak self] in
            if self?.groupListData?.isCreatedByMe == 1{
                let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "EditGroupScreen") as! EditGroupScreen
                vc.groupId = self?.groupId ?? 0
                vc.groupDetailData = self?.groupListData
                if let groupListVC = self?.groupListVC{
                    vc.deleteGroupDelegate = groupListVC
                }
                vc.onEditGroupClick = { [weak self]  updatedObj in
                    self?.groupListData = updatedObj
                    self?.postTableView.reloadData()
                    
                    //                    self?.setUpdata()
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
                if self?.groupListData?.isJoin == 1{
                    self?.deleteGroup()
                }else{
                    self?.groupListData?.isJoin = 1
                    headerView?.editGroupButton.setTitle(self?.groupListData?.isJoin == 1 ? "Leave Group":"Join", for: .normal)
                    self?.postTableView.reloadData()
                    self?.doJoinAPI()
                }
            }
        }
        headerView?.onInvite = { [weak self] in
            let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "InviteGroupMemberScreen") as! InviteGroupMemberScreen
            vc.groupId = self?.groupId ?? 0
            vc.onRefreshMemberCount = {  [weak self ] memberCount in
                self?.groupListData?.groupMembersCount = memberCount
                self?.groupMemberCountLabel.text = "\(self?.groupListData?.groupMembersCount ?? 0) Members"
                self?.postTableView.reloadData()
            }
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return headerView?.contentView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
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
            //            cell.moreOptionButton.isHidden = true
            //            cell.tabBarVC = self.superVC
            
            if self.itemArray[indexPath.row].post_type != 5{
                
                cell.shareButton.isHidden = false
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
            }else{
                cell.shareButton.isHidden = true
                cell.captionLabel.text = self.itemArray[indexPath.row].caption
                cell.reShareCaptionLabel.text = self.itemArray[indexPath.row].reshare_caption
                cell.readMoreLineView.isHidden = true
                cell.reShareReadMoreLineView.isHidden = true
                cell.reshareReadMoreButton.isHidden = true
                cell.readMoreButton.isHidden = true
                cell.readMoreLineView.isHidden = true
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
            
            //user detail
            cell.onUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].user_id
                //                vc.superVC = self?.superVC
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
                vc.isFromGroup = true
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
                let rowVC: PanModalPresentable.LayoutType = vc
                self?.groupListVC?.navigationController?.presentPanModal(rowVC)
            }
            cell.onLike = {[weak self] in
                //                if let isLike = self?.itemArray[indexPath.row].is_like{
                //                    if isLike{
                //                        return
                //                    }
                //                }
                let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                self?.doLikeAPI(groupPostId:  self?.itemArray[indexPath.row].groupPostId ?? 0 , islike: islike)
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
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                    
                }else{
                    
                    let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.isFromReShare = true
                    vc.onReportPost = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.groupPostId = self?.itemArray[indexPath.row].groupPostId
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
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
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
                self?.groupListVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
            }
            return cell
            
        }else{
            if self.itemArray[indexPath.row].post_type == PostType.artical.rawValue ||  self.itemArray[indexPath.row].post_type == PostType.video.rawValue ||  self.itemArray[indexPath.row].post_type == PostType.podcast.rawValue{
                let cell = self.postTableView.dequeueReusableCell(withIdentifier: "LinkPostCell", for: indexPath) as! LinkPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.viewController = self
                cell.superVC = self.superVC
                //                cell.moreOptionButton.isHidden = true
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
                }else{
                    cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
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
                    vc.isFromGroup = true
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
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                }
                cell.onLike = {[weak self] in
                    //                    if let isLike = self?.itemArray[indexPath.row].is_like{
                    //                        if isLike{
                    //                            return
                    //                        }
                    //                    }
                    let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                    self?.doLikeAPI(groupPostId:  self?.itemArray[indexPath.row].groupPostId ?? 0 , islike: islike)
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
                        self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                    }else{
                        let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                        //                    vc.modalPresentationStyle = .overCurrentContext
                        vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                        
                        vc.onReportPost = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.groupPostId = self?.itemArray[indexPath.row].groupPostId
                            
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
                        self?.groupListVC?.navigationController?.presentPanModal(rowVC)
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
                    self?.groupListVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
                }
                cell.onComment = { [weak self] in
                    self?.didSelectData(indexPath: indexPath.row)
                }
                return cell
            }else if self.itemArray[indexPath.row].post_type == 5{
                let cell = self.postTableView.dequeueReusableCell(withIdentifier: "TextPostTableViewCell", for: indexPath) as! TextPostTableViewCell
                cell.item = self.itemArray[indexPath.row]
                cell.viewController = self
                cell.superVC = self.superVC
                //                cell.moreOptionButton.isHidden = true
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
                
                //                cell.captionLabel.numberOfLines = 0
                cell.captionLabel.text = self.itemArray[indexPath.row].caption
                //                cell.captionLabel.adjustsFontSizeToFitWidth = false
                //                cell.captionLabel.lineBreakMode = .byTruncatingTail
                //                if getCaptionLineNumber(text: self.itemArray[indexPath.row].caption ?? "") <= 64.5{
                //                    //                cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                //                    cell.readMoreButton.isHidden = true
                //                }else{
                //                    cell.readMoreButton.isHidden = self.collapedArray[indexPath.row] == false ? true : false
                //                }
                //                cell.captionLabel.numberOfLines = self.collapedArray[indexPath.row] == false ? 0 : 3
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
                    vc.isFromGroup = true
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
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                }
                //MARK:- LIKE
                cell.onLike = {[weak self] in
                    let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                    self?.doLikeAPI(groupPostId:  self?.itemArray[indexPath.row].groupPostId ?? 0 , islike: islike)
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
                        self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                    }else{
                        let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                        //                vc.modalPresentationStyle = .overCurrentContext
                        vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                        vc.onReportPost = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.groupPostId = self?.itemArray[indexPath.row].groupPostId
                            
                            vc.onSuccessReport = { [weak self] in
                                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                                vc.modalPresentationStyle = .overCurrentContext
                                
                                self?.itemArray.remove(at: indexPath.row)
                                self?.postTableView.reloadData()
                                
                                self?.groupListVC?.navigationController?.present(vc, animated: true, completion: nil)
                            }
                            
                            self?.groupListVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        vc.onUnfollowUser = { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.page = 1
                            strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                        }
                        let rowVC: PanModalPresentable.LayoutType = vc
                        self?.groupListVC?.navigationController?.presentPanModal(rowVC)
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
                    self?.groupListVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
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
            //            cell.moreOptionButton.isHidden = true
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
                vc.isFromGroup = true
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
                let rowVC: PanModalPresentable.LayoutType = vc
                self?.groupListVC?.navigationController?.presentPanModal(rowVC)
            }
            //MARK:- LIKE
            cell.onLike = {[weak self] in
                let islike = self?.itemArray[indexPath.row].is_like == false ? 1 : 2
                self?.doLikeAPI(groupPostId:  self?.itemArray[indexPath.row].groupPostId ?? 0 , islike: islike)
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
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
                }else{
                    let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "UserBlockScreen") as! UserBlockScreen
                    //                vc.modalPresentationStyle = .overCurrentContext
                    vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                    vc.onReportPost = { [weak self] in
                        let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportScreen") as! ReportScreen
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.groupPostId = self?.itemArray[indexPath.row].groupPostId
                        
                        vc.onSuccessReport = { [weak self] in
                            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ReportSuccessScreen") as! ReportSuccessScreen
                            vc.modalPresentationStyle = .overCurrentContext
                            
                            self?.itemArray.remove(at: indexPath.row)
                            self?.postTableView.reloadData()
                            
                            self?.superVC?.navigationController?.present(vc, animated: true, completion: nil)
                        }
                        
                        self?.groupListVC?.navigationController?.present(vc, animated: true, completion: nil)
                    }
                    
                    vc.onUnfollowUser = { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.page = 1
                        strongSelf.getPostAPI(page: strongSelf.page, postType: strongSelf.postType, search: strongSelf.searhText)
                    }
                    let rowVC: PanModalPresentable.LayoutType = vc
                    self?.groupListVC?.navigationController?.presentPanModal(rowVC)
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
                self?.groupListVC?.navigationController?.present(reshareVC, animated: true, completion: nil)
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

 // MARK: - ExpandableLabelDelegate
extension GroupDetailScreen: ExpandableLabelDelegate{
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

//MARK: - TEXTFIELD DELEGATE
extension GroupDetailScreen: UITextFieldDelegate{
    
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
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            self.searhText = nil
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
        }else{
            self.page = 1
            self.searhText = text
            self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
            
        }
    }
}
//MARK: - ADD NEW POST DELEGATE
extension GroupDetailScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        print("Added new post")
        self.page = 1
        //        self.postType = self.getPostType()
        self.getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
    }
}
//MARK: - API calling
extension GroupDetailScreen{
    
    func deletePostAPI(postObj: PostReponse){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            guard let id = postObj.groupPostId else {
                return
            }
            PostService.shared.deletePost(id: id,isGroup: true) { [weak self] (statusCode, response) in
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
    
    //MARK:- DO LIKE API
    func doLikeAPI(groupPostId:Int,islike:Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            //            let parameter = doGroupLikeRequest(group_post_id: groupPostId, islike: islike)
            let parameter = doLikeRequest(post_id: nil, islike: islike, group_post_id: groupPostId)
            
            PostService.shared.doLikeOnPost(parameters: parameter.toJSON(),isGroupLike: true) { (statusCode, response) in
                //                Utility.hideIndicator()
                var isLikeStatus = false
                if islike == 1{
                    isLikeStatus = true
                }else{
                    isLikeStatus = false
                }
                self.changeLikeStatus(groupPostId: groupPostId, isLike:isLikeStatus )
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    
    
    func changeLikeStatus(groupPostId: Int,isLike: Bool){
        if let index = self.itemArray.firstIndex(where: {$0.groupPostId == groupPostId}){
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
    
    
    //MARK:- DO JOIN API
    func doJoinAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let parameter = JoinGroupRequest(group_id: "\(self.groupId ?? 0)", user_id: "\(Utility.getCurrentUserId())")
            GroupService.shared.doJoinGroup(parameters: parameter.toJSON()) { (statusCode, response) in
                //                Utility.hideIndicator()
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:- REMOVE FROM GROUP
    func removeAndDeleteGroup(groupId: Int,userId: Int){
        if Utility.isInternetAvailable(){
            GroupService.shared.removeUserFromGroup(url:removeUserFromGroupURL+"\(groupId)/" + "\(userId)") { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.groupListData?.isJoin = 0
                self?.deleteGroupDelegate?.deleteGroup()
                self?.navigationController?.popViewController(animated: true)
                //                if userId == Utility.getCurrentUserId(){
                //                    for controller in (self?.navigationController!.viewControllers)! as Array {
                //                            if controller is GroupListScreen {
                //                                self?.deleteGroupDelegate?.deleteGroup()
                //                                self?.navigationController!.popToViewController(controller, animated: true)
                //                                break
                //                        }
                //                    }
                //
                //
                ////                    self?.navigationController?.popViewController(animated: true)
                //                }
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
    
    //MARK:- POST API
    func getPostAPI(page: Int,postType: String?,search: String?){
        //        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
                // Utility.showIndicator()
            }
            let data = GetPostRequest(post_type: "1,2,3,4,5", search: search,username: nil, explore: nil, groupId: self.groupId ?? 0)
            PostService.shared.getAllPost(parameters: data.toJSON(),page: page,isGroupPostList: true) { [weak self] (statusCode, response) in
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
                    if self?.itemArray.count == 0{
                        self?.postTableView.isScrollEnabled = false
                        self?.postNotFoundLabel.isHidden = false
                    }else{
                        self?.postTableView.isScrollEnabled = true
                        self?.postNotFoundLabel.isHidden = true
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
    
    func getGroupDetailData(groupId: Int){
        if Utility.isInternetAvailable(){
            GroupService.shared.groupDetail(url:groupDetailURL+"\(groupId)") { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response?.groupDetailData{
                    self?.groupListData = res
                    self?.setUpdata()
                }
                self?.setUpdata()
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
    
    func appendPostDataTableView(data: [PostReponse]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.collapedArray = [Bool](repeating: true, count: self.itemArray.count)
        self.postTableView.insertRows(at: indexPath, with: .bottom)
    }
    
}
//MARK: - CACHE IMAGE
extension GroupDetailScreen{
    
    
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
