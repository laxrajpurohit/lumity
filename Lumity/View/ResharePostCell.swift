//
//  ResharePostCell.swift
//  Source-App
//
//  Created by iroid on 16/04/21.
//

import UIKit
import ExpandableLabel
import LinkPresentation

class ResharePostCell: UITableViewCell {

    @IBOutlet weak var reshareUserProfile: dateSportImageView!
    @IBOutlet weak var reShareUserNameLabel: UILabel!
    @IBOutlet weak var reShareHeadlineLabel: UILabel!
    @IBOutlet weak var reShareCaptionLabel: UILabel!
    @IBOutlet weak var reSharePostTimeLabel: UILabel!
    
    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var reshareReadMoreButton: UIButton!
    
    @IBOutlet weak var reShareReadMoreLineView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var reshareButton: UIButton!
    @IBOutlet weak var reshareCountButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var intrestedCollectionView: UICollectionView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var intrestCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageLinkViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageMainView: dateSportView!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var reshareSubPostView: dateSportView!
    @IBOutlet weak var linkClickButton: UIButton!
    
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var readMoreLineView: UIView!
    
    @IBOutlet weak var startImageView: UIImageView!
    
    var onMore : (() -> Void)?
    var onShare: (() -> Void)?
    
    var onLike : (() -> Void)?
    var onLikeCount: (() -> Void)?
    
    var onReShare : (() -> Void)?
    var onReShareCount: (() -> Void)?
    
    var onComment : (() -> Void)?
    var onCommentCount: (() -> Void)?
    var onSubPost: (() -> Void)?
    var onLinkClick : (() -> Void)?
    var metaData: LPLinkMetadata?
    
    var itemArray: [String] = []
    
    var superVC: HomeScreen?
    var onUser : (() -> Void)?
    var onSubUser : (() -> Void)?
    var onPostImage:(()-> Void)?
    var onReadMore:(()-> Void)?
    var reshareReadMore: (() -> Void)?
    
    var tabBarVC: TabBarScreen?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.intrestedCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.intrestedCollectionView.delegate = self
        self.intrestedCollectionView.dataSource = self
//        self.readMoreButton.gradientButton("Read More", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)
        
//        self.reshareReadMoreButton.gradientButton("Read More", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.item?.post_type == 5{
            self.postImageMainView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 70), height: 0) })
        } else if self.item?.media == nil && self.item?.post_type == PostType.book.rawValue{
            self.postImageMainView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 70), height: 200) })
            self.postImageMainView.subviews.forEach({ $0.removeFromSuperview() })
        }else{
            self.postImageMainView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 70), height: 350) })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
    @IBAction func onSubUser(_ sender: Any) {
        self.onSubUser?()
    }
    
    @IBAction func onMore(_ sender: Any) {
        self.onMore?()
    }
    
    @IBAction func onShare(_ sender: Any) {
        self.onShare?()
    }

    @IBAction func onLike(_ sender: Any) {
        self.onLike?()
    }
    
    @IBAction func onLikeCount(_ sender: Any) {
        self.onLikeCount?()
    }
    
    @IBAction func onReShare(_ sender: Any) {
        self.onReShare?()
    }
    
    @IBAction func onReShareCount(_ sender: Any) {
        self.onReShareCount?()
        
    }
    @IBAction func onComment(_ sender: Any) {
//        self.onReShare?()
        self.onComment?()
    }
    @IBAction func onLinkClick(_ sender: UIButton) {
        self.onLinkClick?()
    }
    
    @IBAction func onCommentCount(_ sender: Any) {
//        self.onReShareCount?()
        
    }
    
    @IBAction func onSubPost(_ sender: Any) {
        self.onSubPost?()
    }
    @IBAction func onPostImage(_ sender: UIButton) {
        self.onPostImage?()
    }
    
    @IBAction func onReadMore(_ sender: UIButton) {
        self.onReadMore?()
    }
    
    @IBAction func onReshareReadMore(_ sender: Any) {
        self.reshareReadMore?()
    }
    
    var item: PostReponse?{
        didSet{
            if let data = item?.reshareUserDetails{
                self.reShareUserNameLabel.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
                if let image = data.profile_pic{
                    Utility.setImage(image, imageView: self.reshareUserProfile)
                }
                self.reShareHeadlineLabel.text = data.headline

            }
            if let date = item?.reshare_createdat{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.reSharePostTimeLabel.text  = Utility.timeAgoSinceDate(createdDate)
            }
//            self.reShareCaptionLabel.text = item?.reshare_caption
            
            self.userNameLabel.text = "\(item?.userDetails?.first_name ?? "") \(item?.userDetails?.last_name ?? "")"
            if let image = item?.userDetails?.profile_pic{
                Utility.setImage(image, imageView: self.userImageView)
            }
            self.headlineLabel.text = item?.userDetails?.headline ?? " "
//            self.rateLabel.text = "\(item?.rate ?? 0)/5"
            
            if item?.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
//                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }
            
            
            if let date = item?.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
           
            if let isLike = item?.is_like{
                if isLike{
                    self.likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                }else{
                    self.likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
                }
            }
            
            self.likeCountLabel.text = "\(item?.like_count ?? 0)"
            self.commentCountLabel.text = "\(item?.comment_count ?? 0)"
            self.shareCountLabel.text = "\(item?.reshare_count ?? 0)"
            
            if let arr = item?.interest,item?.interest?.count ?? 0 > 0{
                self.itemArray = arr
                self.intrestedCollectionView.reloadData()
                self.intrestCollectionViewHeight.constant = 40
                self.intrestedCollectionView.isHidden = false
            }else{
                self.intrestCollectionViewHeight.constant = 30
                self.intrestedCollectionView.isHidden = true
            }
            
//            if Utility.getCurrentUserId() == item?.reshareUserDetails?.user_id{
//                self.moreOptionButton.isHidden = true
//            }else{
//                self.moreOptionButton.isHidden = false
//            }
            if item?.post_type == 5{
                self.postImageView.isHidden = true
                self.linkView.isHidden = true
                self.postImageLinkViewHeight.constant = 0
            }else if  item?.post_type == PostType.artical.rawValue ||  item?.post_type == PostType.video.rawValue ||  item?.post_type == PostType.podcast.rawValue{
                if let meta = item?.linkMeta{
                    Utility.hideLinkLoadView(view: self.postImageMainView)
                    let linkMetaView = LPLinkView(metadata: meta)
                    self.linkView.addSubview(linkMetaView)
                    linkMetaView.metadata = meta
                    self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 70), height: 200) })
                    self.postImageView.isHidden = true
                    self.postImageLinkViewHeight.constant = 200
                    self.linkView.isHidden = false
                    
                }else{
                    Utility.loadLinkView(view: self.postImageMainView)
                }
            }else{
                if let media = item?.localImagePath{
                    print("Load Local")
                    Utility.setImage(media, imageView: self.postImageView)
                }else if let media = item?.media{
                    Utility.setImage(media, imageView: self.postImageView)
                }
                self.postImageView.isHidden = false
                self.linkView.isHidden = true
                self.postImageLinkViewHeight.constant = 350
            }
            if item?.post_type == 1{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.post_type == 2{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.post_type == 3{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "book_icon")
            }else if item?.post_type == 5{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "text_icon")
            }else{
                self.linkClickButton.isHidden = false
                postTypeImageView.image = UIImage(named: "article_icon")
            }
        }
        
        
       
      
    }
    
}
extension ResharePostCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intrestedCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row]
        cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        self.intrestCollectionViewHeight.constant = collectionView.contentSize.height

        let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.itemArray[indexPath.row])
        return CGSize(width: width + 16, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.itemArray[indexPath.row]
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
        vc.searhText = data
        vc.superVC = self.tabBarVC
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
