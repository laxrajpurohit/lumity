//
//  LinkPostCell.swift
//  Source-App
//
//  Created by Nikunj on 07/04/21.
//

import UIKit
import LinkPresentation
import ExpandableLabel
import SDWebImage

class LinkPostCell: UITableViewCell {
    
    
    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var userImgeView: dateSportImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var linkView: dateSportView!
    @IBOutlet weak var intresetCollectionView: UICollectionView!
    @IBOutlet weak var intrestCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var reshareButton: UIButton!
    @IBOutlet weak var reshareCountButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var linkClickButton: UIButton!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView!
    
    @IBOutlet weak var readMoreLineView: UIView!

    
    var onMore : (() -> Void)?
    var onShare: (() -> Void)?
    
    var onLike : (() -> Void)?
    var onLikeCount: (() -> Void)?
    
    var onReShare : (() -> Void)?
    var onReShareCount: (() -> Void)?
    
    var onComment : (() -> Void)?
    var onCommentCount: (() -> Void)?
    
    var onLinkClick : (() -> Void)?
    
    var itemArray: [String] = []
    var onUser : (() -> Void)?

    var onReadMore:(()-> Void)?
    
    var superVC: TabBarScreen?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.intresetCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.intresetCollectionView.delegate = self
        self.intresetCollectionView.dataSource = self
//        self.readMoreButton.gradientButton("Read More", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //            self.linkMetaView?.frame =  self.linkView.bounds
//        for i in self.linkView.subviews{
//            if i.tag != linkTag{
//                i.frame = CGRect(x: 0, y: 0, width: (screenWidth - 50), height: 200)
//            }
//        }
//        for i in self.linkView.subviews{
//            if i.tag != linkTag{
//                i.removeFromSuperview()
//            }
//        }
        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 50), height: 200) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })
//        self.captionLabel.collapsed = fa
        self.captionLabel.text = nil

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
    
    @IBAction func onReadMore(_ sender: UIButton) {
        self.onReadMore?()
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
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
    @IBAction func onLinkClick(_ sender: UIButton) {
        self.onLinkClick?()
    }
    @IBAction func onCommentCount(_ sender: Any) {
        //            self.onReShareCount?()
        
    }
    
    var item: PostReponse?{
        didSet{
            self.userNameLabel.text = "\(item?.userDetails?.first_name ?? "") \(item?.userDetails?.last_name ?? "")"
            //            if let image = item?.userDetails?.profile_pic{
            Utility.setImage(item?.userDetails?.profile_pic, imageView: self.userImgeView)
            //            }
            self.headLineLabel.text = item?.userDetails?.headline ?? " "
            //            self.hashTagLabel.text = item?.hashtag
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
                self.hourLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
            //            if let media = item?.link{
            //                self.loadLinkView(link: media)
            //            }
            if let arr = item?.interest ,item?.interest?.count ?? 0 > 0{
                self.itemArray = arr
                //                    DispatchQueue.main.async {
                self.intresetCollectionView.reloadData()
                self.intrestCollectionViewHeight.constant = 40
                //                    }
                self.intresetCollectionView.isHidden = false
                
            }else{
                self.intrestCollectionViewHeight.constant = 30
                self.intresetCollectionView.isHidden = true
            }
            
            
            if let meta = item?.linkMeta{
                Utility.hideLinkLoadView(view: self.linkView)
                let linkMetaView = LPLinkView(metadata: meta)
                self.linkView.addSubview(linkMetaView)
                linkMetaView.metadata = meta
                self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: (screenWidth - 50), height: 200) })
                
            }else{
                Utility.loadLinkView(view: self.linkView)
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
            
//            if Utility.getCurrentUserId() == item?.user_id{
//                self.moreOptionButton.isHidden = true
//            }else{
//                self.moreOptionButton.isHidden = false
//            }
            if item?.post_type == 1{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.post_type == 2{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.post_type == 3{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "book_icon")
            }else{
                self.linkClickButton.isHidden  = false
                postTypeImageView.image = UIImage(named: "article_icon")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension LinkPostCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
        
        let cell = self.intresetCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
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
        //self.intrestCollectionViewHeight.constant = collectionView.contentSize.height
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
