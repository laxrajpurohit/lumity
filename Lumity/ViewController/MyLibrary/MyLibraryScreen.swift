//
//  MyLibraryScreen.swift
//  Source-App
//
//  Created by iroid on 31/03/21.
//

import UIKit
import PanModal

class MyLibraryScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    var superVC: TabBarScreen?
    var itemArray: [MyLibraryListResponse] = []
    var page: Int = 1
    var meta: Meta?
    var hasMorePage:Bool = false
    var isEdit: Bool = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.myListAPI(page: self.page)
    }
    
    func initializeDetails(){
        self.collectionView.register(UINib(nibName: "MyLibraryCell", bundle: nil), forCellWithReuseIdentifier: "MyLibraryCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.myListAPI(page: self.page)
    }
    
    func setButtons(){
        if self.isEdit{
            self.backButton.isHidden = true
            self.editButton.setTitle(nil, for: .normal)
            self.editButton.setImage(UIImage(named: "ic_plus"), for: .normal)
        }else{
            self.backButton.isHidden = true
            self.editButton.setImage(nil, for: .normal)
            self.editButton.setTitle("Edit", for: .normal)
        }
//        self.collectionView.reloadData()
    }

    //MARK: - LIST API
    func myListAPI(page: Int){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = MyLibraryListRequest(page: page)
            MyLibraryService.shared.myLibraryList(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
                self?.hasMorePage = true
                Utility.hideIndicator()
                if let res = response.myLibraryListResponse{
                    if page == 1{
                        self?.itemArray = res
                        self?.collectionView.reloadData()
                    }else{
                        self?.appendDataCollectionView(data: res)
                    }
                }
                self?.startDownload()
                if let metaResponse = response.meta{
                    self?.meta = metaResponse
                }
            } failure: { [weak self] (error) in
                guard let strongSelf = self else{
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
    
    func downloadMetaData(link: String,id: Int){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            if let index = self?.itemArray.firstIndex(where: {$0.id == id}){
                self?.itemArray[index].postDetails?.linkMeta = linkMetaData
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadItems(at: [IndexPath(item: index + 2, section: 0)])//.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
            self?.startDownload()
        }
    }
    
    func startDownload(){
        guard let item = self.itemArray.first(where: {$0.postDetails?.linkMeta == nil && ($0.postDetails?.post_type == PostType.artical.rawValue || $0.postDetails?.post_type == PostType.video.rawValue || $0.postDetails?.post_type == PostType.podcast.rawValue)}) else {
            return
        }
        if let link = item.postDetails?.link,let id = item.id{
            self.downloadMetaData(link: link,id: id)
        }else{
            self.startDownload()
        }
    }
    
    func appendDataCollectionView(data: [MyLibraryListResponse]){
        var indexPath: [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(item: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.collectionView.insertItems(at: indexPath)
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
                        self.myListAPI(page: self.page)
                    }
                }
            }
        }
    }
    
    func deletePost(obj: MyLibraryListResponse){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = MyLibraryDeleteRequest(mylibrary_id: obj.id)
            MyLibraryService.shared.deleteMyLibraryAPI(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
                strongSelf.page = 1
                strongSelf.myListAPI(page: strongSelf.page)
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
    
    func displayDeleteDialogue(obj: MyLibraryListResponse){
        let alertController = UIAlertController(title:"Delete '\(obj.name ?? "")' Playlist?" , message: "Are you sure you want to Delete the '\(obj.name ?? "")' Playlist?", preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action) in
            self?.deletePost(obj: obj)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.isEdit = false
        self.setButtons()
    }
    
    @IBAction func onPlus(_ sender: Any) {
//        if self.isEdit{
            self.backButton.isHidden = true
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "AddNewPlaylistScreen") as! AddNewPlaylistScreen
            vc.superVC = self
            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            self.isEdit = true
//            self.setButtons()
//        }
    }
}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension MyLibraryScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MyLibraryCell", for: indexPath) as! MyLibraryCell
        if indexPath.row == 0{
            cell.label.text = "Save for Later"
            cell.showDataView.isHidden = true
            cell.folderOptionButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.completedAndSaveForLaterImageView.isHidden = false
            cell.completedAndSaveForLaterImageView.image = UIImage(named:"Save_For_Later")
            cell.mainView.backgroundColor = Utility.getUIcolorfromHex(hex: "E5E1DF")
        }else if indexPath.row == 1{
            cell.label.text = "Completed"
            cell.showDataView.isHidden = true
            cell.deleteButton.isHidden = true
            cell.folderOptionButton.isHidden = true
            cell.completedAndSaveForLaterImageView.isHidden = false
            cell.completedAndSaveForLaterImageView.image = UIImage(named:"Completed_icon")
            cell.mainView.backgroundColor = Utility.getUIcolorfromHex(hex: "E5E1DF")
//            cell.postImageView.image = UIImage(named: "Completed_icon")
        }else{
            cell.mainView.backgroundColor = .white
            cell.folderOptionButton.isHidden = false
            cell.showDataView.isHidden = false
            cell.deleteButton.isHidden = true
            cell.item = self.itemArray[indexPath.row - 2]
            cell.label.text = self.itemArray[indexPath.row - 2].name
            cell.completedAndSaveForLaterImageView.isHidden = true
            cell.onShare = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "folderOptionScreen") as! folderOptionScreen
                vc.myLibraryDataDetailData =  strongSelf.itemArray[indexPath.row - 2]
                let rowVC: PanModalPresentable.LayoutType = vc
                vc.onDelete = {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    print(strongSelf.itemArray)
                    print(strongSelf.itemArray.count)
//                    strongSelf.itemArray.remove(at: indexPath.row - 2)
//                    strongSelf.collectionView.reloadData()
                }
                vc.onEditFolder = {[weak self] (data) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.itemArray[indexPath.row - 2] = data
                    strongSelf.collectionView.reloadData()
                }
                
                vc.onSendMessage = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let vc = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageSuggectionUserScreen") as! MessageSuggectionUserScreen
                    vc.myLibraryListResponse = strongSelf.itemArray[indexPath.row - 2]
                    vc.messageNavigationType = MessageNavigationType.myLibraryScreen.rawValue
                    vc.postType = 8
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
//                    strongSelf.deletePostAlert(postObj: strongSelf.itemArray[indexPath.row])
                }
                self?.superVC?.navigationController?.presentPanModal(rowVC)
            }
            
            cell.onDelete = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.displayDeleteDialogue(obj: strongSelf.itemArray[indexPath.row - 2])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "SaveForLaterPostScreen") as! SaveForLaterPostScreen
            vc.postWise = .saveForLater
            vc.superVC = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "SaveForLaterPostScreen") as! SaveForLaterPostScreen
            vc.postWise = .completed
            vc.superVC = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "PlayListDetailScreen") as! PlayListDetailScreen
            vc.myLibraryObj = self.itemArray[indexPath.row - 2]
            vc.userId = Utility.getCurrentUserId()
            vc.superVC = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftSpace = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
        let rightSpace = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right
        let cellSpacing = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let numberOFRows : CGFloat =  2
        let scWidth : CGFloat = screenWidth - (leftSpace + rightSpace)
        let totalSpace : CGFloat = cellSpacing * (numberOFRows - 1)
        let width = (scWidth - totalSpace) / numberOFRows
        return CGSize(width: width, height: 200)
    }
}
//MARK: - ADD NEW POST DELEGATE
extension MyLibraryScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.myListAPI(page: self.page)
    }
}
