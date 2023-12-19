
//
//  HomePostCell.swift
//  Source-App
//
//  Created by Nikunj on 04/04/21.
//

import UIKit
import ExpandableLabel
import LinkPresentation

class TextPostTableViewCell: UITableViewCell {

    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var reshareButton: UIButton!
    @IBOutlet weak var reshareCountButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var postImageButton: UIButton!
    
//    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var intrestedCollectionView: UICollectionView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var intrestCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var startImageView: UIImageView!
    
    
    var onMore : (() -> Void)?
    var onShare: (() -> Void)?
    
    var onLike : (() -> Void)?
    var onLikeCount: (() -> Void)?
    
    var onReShare : (() -> Void)?
    var onReShareCount: (() -> Void)?
    
    var onComment : (() -> Void)?
    var onCommentCount: (() -> Void)?
    var onUser : (() -> Void)?
    var onPostImage:(()-> Void)?
    var onReadMore:(()-> Void)?
    
    var metaData: LPLinkMetadata?
    
    var itemArray: [String] = []
    
    var superVC: TabBarScreen?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.intrestedCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.intrestedCollectionView.delegate = self
        self.intrestedCollectionView.dataSource = self
//        self.loadViewFromLink()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        self.onComment?()
    }
    
    @IBAction func onReadMore(_ sender: UIButton) {
        self.onReadMore?()
    }
    
    @IBAction func onCommentCount(_ sender: Any) {
//        self.onReShareCount?()
        
    }
    
    @IBAction func onPostImage(_ sender: UIButton) {
        self.onPostImage?()
    }
    var item: PostReponse?{
        didSet{
            self.userNameLabel.text = "\(item?.userDetails?.first_name ?? "") \(item?.userDetails?.last_name ?? "")"
            if let image = item?.userDetails?.profile_pic{
                Utility.setImage(image, imageView: self.userImageView)
            }
            self.headlineLabel.text = item?.userDetails?.headline ?? " "
            if item?.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }
            
            if let date = item?.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
            if let media = item?.localImagePath{
                print("Load Local")
                Utility.setImage(media, imageView: self.postImageView)
            }else if let media = item?.media{
                Utility.setImage(media, imageView: self.postImageView)
            }
            if let isLike = item?.is_like{
                if isLike{
                    likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                }else{
                    likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
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
            
//            if Utility.getCurrentUserId() == item?.user_id{
//                self.moreOptionButton.isHidden = true
//            }else{
//                self.moreOptionButton.isHidden = false
//            }
            if item?.post_type == 1{
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.post_type == 2{
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.post_type == 3{
                postTypeImageView.image = UIImage(named: "book_icon")
            }else if item?.post_type == 5{
                self.postTypeImageView.image = UIImage(named: "text_icon")
            }else{
                postTypeImageView.image = UIImage(named: "article_icon")
            }

            
        }
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
    
//    func loadViewFromLink(){
//
//        let dispatchGroup = DispatchGroup()
//        DispatchQueue.main.async(group: dispatchGroup) {
//            dispatchGroup.enter()
//            let mdProvider = LPMetadataProvider()
//            mdProvider.startFetchingMetadata(for: URL(string: "https://www.educba.com/html-vs-php/")!) { (metadata, error) in
//                if let metadata = metadata {
//                    self.metaData = metadata
//                }
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
//            guard let strongSelf = self else{
//                return
//            }
//            guard let meta = self?.metaData else{
//                return
//            }
//            let linkMetaView = LPLinkView(metadata: meta)
//            strongSelf.linkView.addSubview(linkMetaView)
//            linkMetaView.frame = strongSelf.linkView.bounds
//        }
//    }
    
}

extension TextPostTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intrestedCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row]
        cell.label.font = UIFont(name: "Calibri-Bold", size: 12)!
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // self.intrestCollectionViewHeight.constant = collectionView.contentSize.height

        let width = Utility.labelWidth(height: 32, font: UIFont(name: "Calibri-Bold", size: 12)!, text: self.itemArray[indexPath.row])
        return CGSize(width: width + 16, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.itemArray[indexPath.row]
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
        vc.searhText = data
        vc.superVC = self.superVC
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
