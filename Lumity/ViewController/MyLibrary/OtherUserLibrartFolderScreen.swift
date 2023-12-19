//
//  OtherUserLibrartFolderScreen.swift
//  Source-App
//
//  Created by iroid on 12/05/21.
//

import UIKit

class OtherUserLibrartFolderScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    var superVC: TabBarScreen?
    var itemArray: [MyLibraryListResponse] = []
    var page: Int = 1
    var meta: Meta?
    var hasMorePage:Bool = false
    var userId = 0
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func initializeDetails(){
        self.collectionView.register(UINib(nibName: "MyLibraryCell", bundle: nil), forCellWithReuseIdentifier: "MyLibraryCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.otherUserLibratyListAPI(page: self.page)
    }
    
    //MARK: - LIST API
    func otherUserLibratyListAPI(page: Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = otherUserLibraryListRequest(page: page, user_id: userId)
            MyLibraryService.shared.otherUserLibraryList(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
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
                    self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])//.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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
                        self.otherUserLibratyListAPI(page: self.page)
                    }
                }
            }
        }
    }
    
    func displayDeleteDialogue(obj: MyLibraryListResponse){
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "Are you sure you want to Delete?", preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            self?.deletePost(obj: obj)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
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
                strongSelf.otherUserLibratyListAPI(page: strongSelf.page)
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
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension OtherUserLibrartFolderScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MyLibraryCell", for: indexPath) as! MyLibraryCell
     
            cell.folderOptionButton.isHidden = true
            cell.showDataView.isHidden = false
            cell.item = self.itemArray[indexPath.row]
            cell.label.text = self.itemArray[indexPath.row].name
            cell.completedAndSaveForLaterImageView.isHidden = true
//            cell.onDelete = { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                strongSelf.displayDeleteDialogue(obj: strongSelf.itemArray[indexPath.row])
//            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "PlayListDetailScreen") as! PlayListDetailScreen
        vc.myLibraryObj = self.itemArray[indexPath.row]
        vc.isFromOtherUserProfile = true
        vc.userId = self.userId
        self.navigationController?.pushViewController(vc, animated: true)

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
extension OtherUserLibrartFolderScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.otherUserLibratyListAPI(page: self.page)
    }
}
