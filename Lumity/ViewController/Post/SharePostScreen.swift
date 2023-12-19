//
//  SharePostScreen.swift
//  Source-App
//
//  Created by Nikunj on 16/04/21.
//

import UIKit
import ExpandableLabel
import LinkPresentation

class SharePostScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var reshareUserNameLabel: UILabel!
    @IBOutlet weak var reShareUserImageView: dateSportImageView!
    @IBOutlet weak var reSharecaptionPlaceHolder: UILabel!
    @IBOutlet weak var reShareCaptionTextView: UITextView!
    @IBOutlet weak var reshareUseHeadLineLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var captionLabel: ExpandableLabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var intrestedCollectionView: UICollectionView!
    @IBOutlet weak var intrestCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var linkView: dateSportView!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var postImageHeightConstant: NSLayoutConstraint!
    
    // MARK: - VARIABLE DECLARE
    var postObject: PostReponse?
    var itemArray: [String] = []
    var completeAddNewPostDelegate: EnterNewPostDelegate?
    var isEdit: Bool = false
    var superVC: UIViewController?

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
    }
    

    func initializeDetails(){
        self.postButton.gradientButton("Post", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)
        self.reShareCaptionTextView.delegate = self
        self.intrestedCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        if let currantUserData = Utility.getUserData(){
            Utility.setImage(currantUserData.profile_pic, imageView: self.reShareUserImageView)
            self.reshareUserNameLabel.text = "\(currantUserData.first_name ?? "") \(currantUserData.last_name ?? "")"
            self.reshareUseHeadLineLabel.text = currantUserData.headline ?? ""
        }
        if let item = postObject{
            self.userNameLabel.text = "\(item.userDetails?.first_name ?? "") \(item.userDetails?.last_name ?? "")"
            if let image = item.userDetails?.profile_pic{
                Utility.setImage(image, imageView: self.userImageView)
            }
            self.headlineLabel.text = item.userDetails?.headline ?? " "
            self.rateLabel.text = "\(item.rate ?? 0)/5"
            
            
            
            if item.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }
            
            if let date = item.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
           
            if let arr = item.interest,item.interest?.count ?? 0 > 0{
                self.itemArray = arr
                self.intrestedCollectionView.reloadData()
                self.intrestCollectionViewHeight.constant = 40
            }else{
                self.intrestCollectionViewHeight.constant = 30
            }
            if item.post_type == 1{
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item.post_type == 2{
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item.post_type == 3{
                postTypeImageView.image = UIImage(named: "book_icon")
            }else if item.post_type == 5{
                postTypeImageView.image = UIImage(named: "text_icon")
            }else{
                postTypeImageView.image = UIImage(named: "article_icon")
            }
            let attributedString = NSAttributedString(string: "read more", attributes: [NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "000000"),NSAttributedString.Key.font: self.captionLabel.font!])
            self.captionLabel.delegate = self
            self.captionLabel.shouldCollapse = true
            self.captionLabel.collapsedAttributedLink = attributedString
            self.captionLabel.textReplacementType = .character
            self.captionLabel.collapsed = false
            self.captionLabel.numberOfLines = 2
            self.captionLabel.text = item.caption
            
            if item.post_type == 1 ||  item.post_type == 4 || item.post_type == 2{
                if !self.linkView.subviews.contains(where: {$0.tag == item.id ?? 0}){
                    if let link = item.link{
                        self.loadLinkView(link: link)
                    }
                }
                linkView.isHidden = false
                postImageView.isHidden = true
                postImageHeightConstant.constant = 200
            }else if item.post_type == 5{
                linkView.isHidden = true
                postImageView.isHidden = true
                postImageHeightConstant.constant = 0
            }else{
                linkView.isHidden = true
                postImageView.isHidden = false
                postImageHeightConstant.constant = 400
                
                if let media = item.media{
                    Utility.setImage(media, imageView: self.postImageView)
                }
            }
        }
        if self.isEdit{
            self.setEditPost()
        }
    }
    
    func setEditPost(){
        if let data = self.postObject?.reshare_caption{
            self.reShareCaptionTextView.text = data
            self.reSharecaptionPlaceHolder.isHidden = (self.reShareCaptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count) > 0
        }
    }
    
    func loadLinkView(link: String){
//        self.view.addSubview(activityIndicatorView)
//        activityIndicatorView.startAnimating()
        Utility.loadLinkView(view: self.linkView)
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, metaData) in
            guard let strongSelf = self else {
                return
            }
            guard let meta = metaData else {
                return
            }
            if self?.postObject?.link == link{
                let linkMetaView = LPLinkView(metadata: meta)
                linkMetaView.tag = self?.postObject?.id ?? 0
                strongSelf.linkView.addSubview(linkMetaView)
                linkMetaView.frame = CGRect(x: 0, y: 0, width: screenWidth - 62, height: 200)//strongSelf.linkView.bounds
            }
            Utility.hideLinkLoadView(view: strongSelf.linkView)

//            activityIndicatorView.stopAnimating()
//            strongSelf.linkView.borderColor = .clear
        }
    }
    //MARK:- POST API
    func postAPI(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
//            var requestData: [String: Any] = [:]
//            if let groupId = self.postObject?.groupPostId{
//                requestData = GroupResharePostRequest(group_post_id: groupId, caption: self.reShareCaptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), is_edit: self.isEdit ? 1 : 0).toJSON()
//            }else if let postId = self.postObject?.id{
//                let data = ResharePostRequest(post_id: postId, caption: self.reShareCaptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines),is_edit: self.isEdit ? 1 : 0)
//            }
            
            let data = ResharePostRequest(group_post_id: self.postObject?.groupPostId,post_id: self.postObject?.id, caption: self.reShareCaptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines),is_edit: self.isEdit ? 1 : 0)

            
            
//            let data = ResharePostRequest(post_id: self.postObject?.id, caption: self.reShareCaptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines),is_edit: self.isEdit ? 1 : 0)
            PostService.shared.resharePost(parameters: data.toJSON(),isFromGroup: self.postObject?.groupPostId == nil ? false : true) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let strongSelf = self else{
                    return
                }
                if strongSelf.navigationController == nil{
                    strongSelf.completeAddNewPostDelegate?.uploadNewPost()
                    strongSelf.dismiss(animated: true)
                }else{
                    for controller in strongSelf.navigationController!.viewControllers as Array {
                        if controller is HomeScreen {
                            self?.completeAddNewPostDelegate?.uploadNewPost()
                            strongSelf.navigationController!.popToViewController(controller, animated: true)
                            break
                        }else if controller is ProfileTabbarScreen {
                            self?.completeAddNewPostDelegate?.uploadNewPost()
                            strongSelf.navigationController!.popToViewController(controller, animated: true)
                            break
                        }else if controller is GroupDetailScreen {
                            self?.completeAddNewPostDelegate?.uploadNewPost()
                            strongSelf.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            } failure: {[weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }

    // MARK: - ACTIONS
    @IBAction func onPost(_ sender: Any) {
        self.postAPI()
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: - TEXTVIEW DELEGATE
extension SharePostScreen : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.reSharecaptionPlaceHolder.isHidden = textView.text.count > 0
    }
}

//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension SharePostScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intrestedCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row]
        cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // self.intrestCollectionViewHeight.constant = collectionView.contentSize.height

        let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.itemArray[indexPath.row])
        return CGSize(width: width + 16, height: 32)
    }
}
extension SharePostScreen: ExpandableLabelDelegate{
    func willCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
//        self.postTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        self.captionLabel.collapsed = false
        self.captionLabel.numberOfLines = 0
    }
}
