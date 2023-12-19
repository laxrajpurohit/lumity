//
//  NotificationScreen.swift
//  Source-App
//
//  Created by Nikunj on 16/05/21.
//

import UIKit

class NotificationScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VARIABLE DECLARE
    var hasMorePage: Bool =  false
    var page: Int = 1
    var meta: Meta?
    var itemArray: [NotificationResponse] = []
    var superVC: TabBarScreen?
    let refreshControl = UIRefreshControl()
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.pullRefreshHomeList(_:)), for: .valueChanged)
        self.tableView.register(UINib(nibName: "UserJoinCell", bundle: nil), forCellReuseIdentifier: "UserJoinCell")
        self.tableView.register(UINib(nibName: "UserLinkPostCell", bundle: nil), forCellReuseIdentifier: "UserLinkPostCell")
        self.tableView.register(UINib(nibName: "UserPostCell", bundle: nil), forCellReuseIdentifier: "UserPostCell")
        self.page = 1
        self.getNotification(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - ACTIONS
    @objc func pullRefreshHomeList(_ sender: Any){
        self.page = 1
        self.getNotification(page: 1)
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                        self.getNotification(page: self.page)
                    }
                }
            }
        }
    }
    
    func getNotification(page: Int){
        if Utility.isInternetAvailable(){
            if !self.refreshControl.isRefreshing{
                //Utility.showIndicator()
            }
//            Utility.showIndicator()
            NotificationService.shared.getNotifications(page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.stopPulling()
                self?.hasMorePage = true
                if let res = response.notificationResponse{
                    if self?.page == 1{
                        self?.itemArray = res
                        self?.tableView.reloadData()
                    }else{
                        self?.appendDataTableView(data: res)
                    }
                }
                if let meta = response.meta{
                    self?.meta = meta
                }
                self?.startDownload()
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
    
    func appendDataTableView(data: [NotificationResponse]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.tableView.insertRows(at: indexPath, with: .bottom)
    }
    
    func downloadMetaData(link: String,id: Int){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            if let index = self?.itemArray.firstIndex(where: {$0.id == id}){
                self?.itemArray[index].post_details?.linkMeta = linkMetaData
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        let loc = self?.tableView.contentOffset
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        self?.tableView.contentOffset = loc ?? .zero
                    }
                }
            }
            self?.startDownload()
        }
    }
    
    func startDownload(){
        guard let item = self.itemArray.first(where: {$0.post_details?.linkMeta == nil && ($0.post_details?.post_type == PostType.artical.rawValue || $0.post_details?.post_type == PostType.video.rawValue || $0.post_details?.post_type == PostType.podcast.rawValue)}) else {
            return
        }
        if let link = item.post_details?.link,let id = item.id{
            self.downloadMetaData(link: link,id: id)
        }else{
            self.startDownload()
        }
    }
    
    func addJoinUser(userId: Int,status: Int,id: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
              
                Utility.hideIndicator()
                self?.changeJoinStatus(userId: userId,status: status,id: id)
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
    func stopPulling(){
        self.refreshControl.endRefreshing()
    }
    func changeJoinStatus(userId: Int,status: Int,id: Int){
        if let index = self.itemArray.firstIndex(where: {$0.id == id}){
            self.itemArray[index].notification_user_detail?.join_status = status
            self.tableView.reloadData()
        }
    }

}
//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension NotificationScreen: UITableViewDelegate,UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.itemArray[indexPath.row].type ?? 0 {
        case NotificationType.newMemberCommunity.rawValue:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserJoinCell", for: indexPath) as! UserJoinCell
            cell.item = self.itemArray[indexPath.row]
            cell.onJoin = { [weak self] in
                let status = self?.itemArray[indexPath.row].notification_user_detail?.join_status == 0 ? 1 : 0
                self?.addJoinUser(userId: self?.itemArray[indexPath.row].notification_user_detail?.user_id ?? 0,status: status,id: self?.itemArray[indexPath.row].id ?? 0)
            }
            cell.onUser = { [weak self] in
                let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                vc.userId = self?.itemArray[indexPath.row].notification_user_detail?.user_id
                vc.superVC = self?.superVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case NotificationType.liked.rawValue,NotificationType.commented.rawValue,NotificationType.share.rawValue,NotificationType.saveYourPost.rawValue,NotificationType.completeYourPost.rawValue:
            let item = self.itemArray[indexPath.row].post_details
            if item?.post_type == PostType.artical.rawValue || item?.post_type == PostType.video.rawValue || item?.post_type == PostType.podcast.rawValue{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserLinkPostCell", for: indexPath) as! UserLinkPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.onLink = { [weak self] in
                    let vc = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                    vc.linkUrl = self?.itemArray[indexPath.row].post_details?.link ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                cell.onUser = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    vc.userId = self?.itemArray[indexPath.row].notification_user_detail?.user_id
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }else{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.onUser = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    vc.userId = self?.itemArray[indexPath.row].notification_user_detail?.user_id
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
        case NotificationType.groupCreate.rawValue:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserJoinCell", for: indexPath) as! UserJoinCell
            cell.item = self.itemArray[indexPath.row]
            return cell
        case NotificationType.groupPostCreate.rawValue,NotificationType.groupSaveYourPost.rawValue, NotificationType.groupReSharePost.rawValue :
            let item = self.itemArray[indexPath.row].post_details

            if item?.post_type == PostType.artical.rawValue || item?.post_type == PostType.video.rawValue || item?.post_type == PostType.podcast.rawValue{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserLinkPostCell", for: indexPath) as! UserLinkPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.onLink = { [weak self] in
                    let vc = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                    vc.linkUrl = self?.itemArray[indexPath.row].post_details?.link ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                cell.onUser = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    vc.userId = self?.itemArray[indexPath.row].notification_user_detail?.user_id
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }else{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
                cell.item = self.itemArray[indexPath.row]
                cell.onUser = { [weak self] in
                    let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    vc.userId = self?.itemArray[indexPath.row].notification_user_detail?.user_id
                    vc.superVC = self?.superVC
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                return cell
            }
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.itemArray[indexPath.row].type ?? 0 {
        case NotificationType.newMemberCommunity.rawValue:
            break
        case NotificationType.liked.rawValue,NotificationType.commented.rawValue,NotificationType.share.rawValue,NotificationType.saveYourPost.rawValue,NotificationType.completeYourPost.rawValue:
            if self.itemArray[indexPath.row].post_details?.reshare == true{
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                vc.postId = self.itemArray[indexPath.row].post_details?.id ?? 0
                vc.postDetailData = self.itemArray[indexPath.row].post_details
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                vc.postId = self.itemArray[indexPath.row].post_details?.id ?? 0
                vc.postDetailData = self.itemArray[indexPath.row].post_details
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
            break
        case NotificationType.groupCreate.rawValue:
            let vc = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupDetailScreen") as! GroupDetailScreen
            vc.groupId = self.itemArray[indexPath.row].group_id
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case NotificationType.groupPostCreate.rawValue,NotificationType.groupSaveYourPost.rawValue, NotificationType.groupReSharePost.rawValue :
            if self.itemArray[indexPath.row].post_details?.reshare == true{
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                vc.postId = self.itemArray[indexPath.row].post_details?.id ?? 0
                vc.postDetailData = self.itemArray[indexPath.row].post_details
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                vc.groupPostId = self.itemArray[indexPath.row].group_post_id ?? 0
                vc.postDetailData = self.itemArray[indexPath.row].post_details
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            break
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
//        let label = UILabel()
//        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//        label.text = "Notification Times"
//        label.font = UIFont(name: "Calibri-Bold", size: 22)//.systemFont(ofSize: 16)
//        headerView.backgroundColor = .white
//        headerView.addSubview(label)
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
