//
//  SaveForLaterPostScreen.swift
//  Source-App
//
//  Created by Nikunj on 26/04/21.
//

import UIKit
import PanModal

class SaveForLaterPostScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: true),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: true),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: true)]
    
    var isEdit: Bool = false
    var page: Int = 1
    var searhText: String?
    var itemArray: [PostReponse] = []
    var postType: Int = 1
    var hasMorePage: Bool = false
    var meta: Meta?
    var selectedIndex = 0
    var postWise: PostWise = .saveForLater //[1 => Save for later,2 => Completed]
    var superVC: TabBarScreen?

//MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.titleLabel.text = self.postWise == .completed ? "Completed" : "Saved for Later"
        self.filterCollectionView.register(UINib(nibName: "PostTypeFilterCell", bundle: nil), forCellWithReuseIdentifier: "PostTypeFilterCell")
        self.postCollectionView.register(UINib(nibName: "MyLibraryPostCell", bundle: nil), forCellWithReuseIdentifier: "MyLibraryPostCell")
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.postCollectionView.delegate = self
        self.postCollectionView.dataSource = self
        self.getPostAPI(page: self.page)
        self.searchTextfield.clearButtonMode = .always
        self.searchTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postCollectionView.reloadData()
    }
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            self.searhText = nil
            //            self.postType = nil
            self.getPostAPI(page: self.page)//getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
        }else{
            self.page = 1
            self.searhText = text
            self.getPostAPI(page: self.page)//getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
            
        }
    }
    
    func setEditButton(){
        if self.isEdit{
            //FIXME:- ADD POST CHANGES
//            if self.postWise == .saveForLater{
//                self.editButton.isHidden = true
//            }else{
                self.editButton.isHidden = false
                self.editButton.setTitle(nil, for: .normal)
                self.editButton.setImage(UIImage(named: "ic_plus"), for: .normal)
//            }
        }else{
//            if self.postWise == .saveForLater{
//                self.editButton.isHidden = false
//                self.editButton.setTitle("Edit", for: .normal)
//                self.editButton.setImage(nil, for: .normal)
//            }else{
                self.editButton.isHidden = false
                self.editButton.setTitle("Edit", for: .normal)
                self.editButton.setImage(nil, for: .normal)
//            }
           
        }
    }
    
    func displayDeleteDialogue(obj: PostReponse){
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
    
    func deletePost(obj: PostReponse){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = CustomePostDeleteRequest(mylibrary_id: self.postWise == .saveForLater ? -1 : -2, mylibrary_post_id: obj.id)
            MyLibraryService.shared.deleteCustomeAPI(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
                strongSelf.page = 1
                strongSelf.getPostAPI(page: strongSelf.page)
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
                        self.getPostAPI(page: self.page)
                    }
                }
            }
        }
    }
    
    func getPostAPI(page: Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = MyLibraryPostRequest(user_id: nil,mylibrary_id: self.postWise ==  .saveForLater ? -1 : -2, post_type: self.postTypeData[self.selectedIndex].postType, page: page,search: self.searhText,isFromCompleted: nil)
            MyLibraryService.shared.myLibraryPostList(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let data = response.postListResponse,(response.postListResponse?.count ?? 0) > 0{
                    if page == 1{
                        self?.itemArray = data
                        self?.checkImageFromDirectory()
                        self?.postCollectionView.reloadData()
                    }else{
                        self?.appendDataCollectionView(data: data)
                    }
                    self?.startImageDownload()
                    self?.startDownload()
                }else{
                    if page == 1{
                        self?.itemArray = []
                        self?.postCollectionView.reloadData()
                    }
                }
                if let metaResponse = response.meta{
                    self?.meta = metaResponse
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
    
    func appendDataCollectionView(data: [PostReponse]){
        var indexPath: [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(item: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.checkImageFromDirectory()
        self.postCollectionView.insertItems(at: indexPath)
    }
    
    func downloadMetaData(link: String,id: Int){
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            if let index = self?.itemArray.firstIndex(where: {$0.id == id}){
                self?.itemArray[index].linkMeta = linkMetaData
                DispatchQueue.main.async { [weak self] in
                    self?.postCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])//.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
            self?.startDownload()
        }
    }
    
    func startDownload(){
        guard let item = self.itemArray.first(where: {$0.linkMeta == nil && ($0.post_type == PostType.artical.rawValue || $0.post_type == PostType.video.rawValue || $0.post_type == PostType.podcast.rawValue)}) else {
            return
        }
        if let link = item.link,let id = item.id{
            self.downloadMetaData(link: link,id: id)
        }else{
            self.startDownload()
        }
    }

    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
//        if self.isEdit{
//            self.isEdit = false
//            self.setEditButton()
//            self.postCollectionView.reloadData()
//        }else{
            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    @IBAction func onEdit(_ sender: Any) {
//        if self.isEdit{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "MyLibraryPostTypeScreen") as! MyLibraryPostTypeScreen
            vc.superVC = self
            vc.postWise = self.postWise
            vc.superVC = self
            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            self.isEdit = true
//            self.setEditButton()
//            self.postCollectionView.reloadData()
//        }
    }
}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension SaveForLaterPostScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.postCollectionView{
            return self.itemArray.count
        }
        return postTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.postCollectionView{
            let cell = self.postCollectionView.dequeueReusableCell(withReuseIdentifier: "MyLibraryPostCell", for: indexPath) as! MyLibraryPostCell
            cell.deleteView.isHidden = true
            cell.item = self.itemArray[indexPath.row]
            cell.shareButton.isHidden = false
//                self.postWise == .completed
            cell.onSharePost = { [weak self] in
                let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "CompleteSaveLaterPostScreen") as! CompleteSaveLaterPostScreen
                let rowVC: PanModalPresentable.LayoutType = vc
                vc.postWise = self?.postWise == .completed ? .completed:.saveForLater
                vc.postItemDataDetailData = self?.itemArray[indexPath.row]
                vc.completePost = { [weak self] in
                    self?.page = 1
                    self?.getPostAPI(page: 1)
                }
                vc.deletePost = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.deletePost(obj: strongSelf.itemArray[indexPath.row])
                }
                
                self?.superVC?.navigationController?.presentPanModal(rowVC)
            }
            cell.onLinkClick = {[weak self ] in
                let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
                control.linkUrl = self?.itemArray[indexPath.row].link ?? ""
                self?.navigationController?.pushViewController(control, animated: true)
            }
            cell.onDelete = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.displayDeleteDialogue(obj: strongSelf.itemArray[indexPath.row])
            }
            return cell
        }
        let cell = self.filterCollectionView.dequeueReusableCell(withReuseIdentifier: "PostTypeFilterCell", for: indexPath) as! PostTypeFilterCell
        cell.setItemMyLibrary = postTypeData[indexPath.row]
        if selectedIndex == indexPath.row{
            cell.postTypeView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            cell.postTypeView.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.postCollectionView{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "MyLibraryPostDetailScreen") as! MyLibraryPostDetailScreen
            vc.postObj = self.itemArray[indexPath.row]
            vc.postWise = self.postWise
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let data = postTypeData[indexPath.row]
            if data.isSelected ?? false{
                data.isSelected = false
            }else{
                data.isSelected = true
            }
            self.postTypeData[indexPath.row] = data
            self.selectedIndex = indexPath.row
            self.filterCollectionView.reloadData()
            
            self.page = 1
            self.getPostAPI(page: self.page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.postCollectionView{
            let leftSpace = (self.postCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
            let rightSpace = (self.postCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right
            let cellSpacing = (self.postCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
            let numberOFRows : CGFloat =  2
            let scWidth : CGFloat = screenWidth - (leftSpace + rightSpace)
            let totalSpace : CGFloat = cellSpacing * (numberOFRows - 1)
            let width = (scWidth - totalSpace) / numberOFRows
            return CGSize(width: width, height: selectedIndex == 0 ? 320:285) //320
        }
        return CGSize(width: collectionView.frame.width/4, height: 46)
    }
}
//MARK: - TEXTFIELD DELEGATE
extension SaveForLaterPostScreen: UITextFieldDelegate{
    
    
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
}
//MARK: - ADD NEW POST DELEGATE
extension SaveForLaterPostScreen: EnterNewPostDelegate{
    func uploadNewPost() {
        self.page = 1
        self.getPostAPI(page: self.page)
    }
}
//MARK: - CACHE IMAGE{
extension SaveForLaterPostScreen{
    

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
                    
                    if let index =  strongSelf.itemArray.firstIndex(where: {$0.id == id}){
                        strongSelf.itemArray[index].localImagePath = imgURL
                        strongSelf.postCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                        strongSelf.startImageDownload()
                    }
                }else{
                    strongSelf.startImageDownload()
                }
            }
        }
    }
    
    func checkImageFromDirectory(){
        for i in self.itemArray{
            if i.post_type == PostType.book.rawValue{
                if let fileName = URL(string: i.media ?? "")?.lastPathComponent{
                    if let localURL = Utility.getFileFromDocumentDirectory(fileName: fileName){
                        if let index = self.itemArray.firstIndex(where: {$0.id == i.id}){
                            self.itemArray[index].localImagePath = localURL
                        }
                    }
                }
            }
        }
    }
}
