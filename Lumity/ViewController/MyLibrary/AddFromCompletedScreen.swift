//
//  AddFromCompletedScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/04/21.
//

import UIKit

class AddFromCompletedScreen: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: true),PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: false),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: false),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: false)]
    
    var isEdit: Bool = false
    var page: Int = 1
    var itemArray: [PostReponse] = []
    var postType: Int = 1
    var hasMorePage: Bool = false
    var meta: Meta?
    var selectedIndex = 0
    var postWise: PostWise = .completed //[1 => Save for later,2 => Completed]
    var playListName: String?
    var idArray: [Int] = []
    var myLibraryObj: MyLibraryListResponse?
    var delegate: EnterNewPostDelegate?

//MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    func initializeDetails(){
        self.titleLabel.text = self.postWise == .completed ? "Add from Completed" : "Saved for Later"
        self.filterCollectionView.register(UINib(nibName: "PostTypeFilterCell", bundle: nil), forCellWithReuseIdentifier: "PostTypeFilterCell")
        self.postCollectionView.register(UINib(nibName: "SelectPostCell", bundle: nil), forCellWithReuseIdentifier: "SelectPostCell")
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.postCollectionView.delegate = self
        self.postCollectionView.dataSource = self
        self.getPostAPI(page: self.page)
    }
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.page = 1
            //            self.postType = nil
            self.getPostAPI(page: self.page)//getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
        }else{
            self.page = 1
            self.getPostAPI(page: self.page)//getPostAPI(page: self.page, postType: self.postType, search: self.searhText)
            
        }
    }
    
    //MARK: - API
    func savePostAPI(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let ids = self.idArray.map { String($0) }.joined(separator: ",")
            let data = CreatePlayListStorePostRequest(name: self.playListName, post_id: ids)
            MyLibraryService.shared.createPlaylistStorePost(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let strongSelf = self else {
                    return
                }
                for controller in strongSelf.navigationController!.viewControllers as Array {
                    if controller is MyLibraryScreen {
                        strongSelf.delegate?.uploadNewPost()
                        strongSelf.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
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
    
    func editPostAPI(libraryId: Int){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let postIds = self.idArray.map { String($0) }.joined(separator: ",")
//            let data = CreatePlayListStorePostRequest(name: self.playListName, post_id: ids)
            let data = MyLibraryCustomePostRequest(upload_type: "1", mylibrary_id: "\(libraryId)", post_id: postIds, post_type: nil, title: nil, author: nil, link: nil, hashtag: nil, media_url: nil, rate: nil, caption: nil, isPublic: "0", isPrivate: "0", interest_id: nil)
            MyLibraryService.shared.customePost(parameters: data.toJSON(), imageData: nil) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.delegate?.uploadNewPost()
                self?.navigationController?.popViewController(animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            Utility.showIndicator()
            let data = MyLibraryPostRequest(user_id: nil,mylibrary_id: self.myLibraryObj?.id ?? 0, post_type: self.postTypeData[self.selectedIndex].postType, page: page,search: nil,isFromCompleted: self.postWise == .saveForLater ? -1 : -2)
            MyLibraryService.shared.myLibraryPostList(parameters: data.toJSON(),page: page) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.hasMorePage = true
                if let data = response.postListResponse,(response.postListResponse?.count ?? 0) > 0{
                    if page == 1{
                        self?.itemArray = data
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        if self.idArray.isEmpty{
            Utility.showAlert(vc: self, message: "Please select at least one post.")
        }else{
            if let id = self.myLibraryObj?.id{
                self.editPostAPI(libraryId: id)
            }else{
                self.savePostAPI()
            }
        }
    }
}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension AddFromCompletedScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.postCollectionView{
            return self.itemArray.count
        }
        return self.postTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.postCollectionView{
            let cell = self.postCollectionView.dequeueReusableCell(withReuseIdentifier: "SelectPostCell", for: indexPath) as! SelectPostCell
            cell.item = self.itemArray[indexPath.row]
//            cell.onLinkClick = {[weak self ] in
//                let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
//                control.linkUrl = self?.itemArray[indexPath.row].link ?? ""
//                self?.navigationController?.pushViewController(control, animated: true)
//            }
            cell.selectedView.isHidden = self.idArray.contains(self.itemArray[indexPath.row].mylibrary_post_id ?? 0) ? false : true

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
            guard let id = self.itemArray[indexPath.row].mylibrary_post_id else {
                return
            }
            if let index = self.idArray.firstIndex(where: {$0 == id}){
                self.idArray.remove(at: index)
            }else{
                self.idArray.append(id)
            }
            
            self.postCollectionView.reloadData()
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
            return  CGSize(width: width, height: self.selectedIndex == 0 ? 320 : 270)
        }
        return CGSize(width: collectionView.frame.width/4, height: 46)
    }
}
//MARK: - TEXTFIELD DELEGATE
extension AddFromCompletedScreen: UITextFieldDelegate{
    
    
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
//MARK: - CACHE IMAGE{
extension AddFromCompletedScreen{
    

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
                        strongSelf.postCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                        strongSelf.startImageDownload()
                    }
                }else{
                    strongSelf.startImageDownload()
                }
            }
        }
    }
}