//
//  MyLibraryPostDetailScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/04/21.
//

import UIKit
import LinkPresentation
import Cosmos

class MyLibraryPostDetailScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var postViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var intrestCollectionView: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rattingImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var instrestedButtonView: dateSportView!
    @IBOutlet weak var rattingView: CosmosView!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var postedByLabel: UILabel!
    
    var postObj: PostReponse?
    var postWise: PostWise = .completed
    var itemArray: [String] = []
    var isEdit: Bool = false
    var intrestArray: [InterestsListData] = []
    var isFromOtherUserProfile = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetail()

        // Do any additional setup after loading the view.
    }
    
    func initializeDetail(){
        self.rattingView.settings.minTouchRating = 0
        self.intrestCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.editButton.isHidden = self.postWise == .saveForLater
        self.intrestCollectionView.delegate = self
        self.intrestCollectionView.dataSource = self
        self.setEditUI()
        if let data = self.postObj{
            if data.post_type == PostType.artical.rawValue || data.post_type == PostType.video.rawValue || data.post_type == PostType.podcast.rawValue{
                self.postViewWidth.constant = screenWidth - 100
                self.linkView.isHidden = false
                if let meta = data.linkMeta{
                    let linkMetaView = LPLinkView(metadata: meta)
                    self.linkView.addSubview(linkMetaView)
                    linkMetaView.metadata = meta
                    self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: self.postViewWidth.constant, height: self.linkView.frame.height) })
                }else{
                    if let link = data.link{
                        Utility.loadLinkView(view: self.linkView)
                        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
                            guard let linkMeta = linkMetaData else{
                                return
                            }
                            let linkMetaView = LPLinkView(metadata: linkMeta)
                            self?.linkView.addSubview(linkMetaView)
                            linkMetaView.metadata = linkMeta
                            self?.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: self?.postViewWidth.constant ?? 0, height: self?.linkView.frame.height ?? 0) })
                            if let strongSelf = self{
                                Utility.hideLinkLoadView(view: strongSelf.linkView!)
                            }
                        }
                    }
                }
            }else{
                self.postViewWidth.constant = 150
                self.linkView.isHidden = true
                if let imageUrl = data.media{
                    Utility.setImage(imageUrl, imageView: self.postImageView)
                }
            }
            
            self.itemArray = data.interest?.first == "" ? [] : data.interest ?? []
            self.intrestCollectionView.reloadData()
            self.titleLabel.text = data.title
            self.authorLabel.text = data.author
            self.captionTextView.text = data.caption
          //  self.rateLabel.text = "\(data.rate ?? 0)/5"
            
            if data.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
                self.rattingImageView.isHidden = true
            }else{
//                self.rateLabel.text = "\(data.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
//                self.rattingImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
                self.rattingImageView.isHidden = true
            }
            
            
            self.rattingView.rating = Double(data.rate ?? 0)
            if data.post_type == PostType.artical.rawValue {
                linkButton.isHidden = false
            }else{
                linkButton.isHidden = true
            }
            
            for i in self.itemArray{
                let data = InterestsListData(interest_id: nil, name: i)
                self.intrestArray.append(data)
            }
            if let user = data.userDetails{
                let string = "- Posted By \(user.first_name ?? "") \(user.last_name ?? "")"
                let attributedString = NSMutableAttributedString(string: string)
                attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri", size: 18)!], range: (string as NSString).range(of: string))
                attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 18)!], range: (string as NSString).range(of: "- Posted By"))
                
                self.postedByLabel.attributedText = attributedString
            }else{
                self.postedByLabel.text = nil
            }
            
        }
       
        self.editButton.isHidden = isFromOtherUserProfile ? true:false
        
        if isFromOtherUserProfile || self.postWise == .saveForLater{
            self.editButton.isHidden = true
        }else{
            //Client want to hide edit button
            self.editButton.isHidden = true
        }

    }
    
    func setEditButton(){
        if self.isEdit{
            self.editButton.setTitle("Done", for: .normal)
        }else{
            self.editButton.setTitle("Edit", for: .normal)
        }
    }
    
    func setEditUI(){
        if self.isEdit{
            captionTextView.isUserInteractionEnabled = true
            instrestedButtonView.isHidden = false
            rattingView.isHidden = false
            rattingImageView.isHidden = true
            rateLabel.isHidden = true
        }else{
            captionTextView.isUserInteractionEnabled = false
            instrestedButtonView.isHidden = true
            rattingView.isHidden = true
            rattingImageView.isHidden = false
            rateLabel.isHidden = false
        }
        
    }
    
    //MARK: - ACTIONS
    @IBAction func onIntreset(_ sender: Any) {
        let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "MyLibraryIntrestScreen") as! MyLibraryIntrestScreen
        vc.selectedTagIntrestedArray = self.intrestArray
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onBack(_ sender: Any) {
        if self.isEdit{
            self.isEdit = false
            self.setEditButton()
            self.setEditUI()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
   
    @IBAction func onArticleLank(_ sender: UIButton) {
        let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
        control.linkUrl = self.postObj?.link ?? ""
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        if self.editButton.titleLabel?.text == "Done"{
            self.editPostAPI()
        }else{
            self.isEdit = !self.isEdit
            self.setEditButton()
            setEditUI()
        }
    }
}
//MARK: - COLLCETIONVIEW DELEGATE & DATASOURCE
extension MyLibraryPostDetailScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intrestCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row]
        cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.itemArray[indexPath.row]
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
        vc.searhText = data
//        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.itemArray[indexPath.row])
        return CGSize(width: width + 16, height: 32)
    }
}
//MARK: - Edit post api
extension MyLibraryPostDetailScreen{
    
    func editPostAPI(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            var arr: String = ""
            if !self.intrestArray.allSatisfy({$0.interest_id == nil}){
                arr = self.intrestArray.map { String($0.interest_id ?? 0) }.joined(separator: ",")
            }
            let data = MyLibraryCustomePostEditRequest(mylibrary_post_id: "\(self.postObj?.id ?? 0)", post_type: "\(self.postObj?.post_type ?? 0)", title: nil, author: nil, link: nil, hashtag: nil, media_url: nil, rate: "\(Int(self.rattingView.rating))", caption: self.captionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), isPublic: "0", isPrivate: "0", interest_id: arr == "" ? nil : arr)
            MyLibraryService.shared.editCustomePost(parameters: data.toJSON(), imageData: nil) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
                strongSelf.postObj?.caption = self?.captionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                strongSelf.postObj?.rate = Int(self?.rattingView.rating ?? 0)
                var arr: [String] = []
                for i in strongSelf.intrestArray{
                    arr.append(i.name ?? "")
                }
                strongSelf.postObj?.interest = arr
                strongSelf.navigationController?.popViewController(animated: true)
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
    
}
//MARK: - SELECT NEW INTREST
extension MyLibraryPostDetailScreen: SelectedIntrestDelegate{
    func getIntrestData(data: [InterestsListData]) {
        var arr: [String] = []
        for i in data{
            arr.append(i.name ?? "")
        }
        self.itemArray = arr
        self.intrestArray = data
        self.intrestCollectionView.reloadData()
    }
}
