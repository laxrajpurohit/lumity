//
//  ReshareSenderTableViewCell.swift
//  Source-App
//
//  Created by iroid on 07/06/21.
//

import UIKit
import ExpandableLabel
import LinkPresentation
class ReshareSenderTableViewCell: UITableViewCell {

    @IBOutlet weak var reshareUserProfile: dateSportImageView!
    @IBOutlet weak var reShareUserNameLabel: UILabel!
    @IBOutlet weak var reShareHeadlineLabel: UILabel!
    @IBOutlet weak var reShareCaptionLabel: UILabel!
    @IBOutlet weak var reSharePostTimeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postImageLinkViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageMainView: dateSportView!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkClickButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var messageSendTime: UILabel!
    
    var onLinkClick : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if self.item?.postDetails?.media == nil{
            self.postImageMainView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 230, height: 200) })
            self.postImageMainView.subviews.forEach({ $0.removeFromSuperview() })
        }else{
            self.postImageMainView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 230, height: 200) })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onLinkClick(_ sender: UIButton) {
        self.onLinkClick?()
    }
  
    var item: MessageData?{
        didSet{
            self.messageSendTime.text = Utility.UTCToLocal(serverDate: item?.createdAt ?? 0)
            if let data = item?.postDetails?.reshareUserDetails{
                self.reShareUserNameLabel.text = "\(data.first_name ?? "") \(data.last_name ?? "")"
                if let image = data.profile_pic{
                    Utility.setImage(image, imageView: self.reshareUserProfile)
                }
                self.reShareHeadlineLabel.text = data.headline

            }
            if let date = item?.postDetails?.reshare_createdat{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.reSharePostTimeLabel.text  = Utility.timeAgoSinceDate(createdDate)
            }
            self.reShareCaptionLabel.text = item?.postDetails?.reshare_caption
            self.captionLabel.text = item?.postDetails?.caption
            self.userNameLabel.text = "\(item?.postDetails?.userDetails?.first_name ?? "") \(item?.postDetails?.userDetails?.last_name ?? "")"
            if let image = item?.postDetails?.userDetails?.profile_pic{
                Utility.setImage(image, imageView: self.userImageView)
            }
            self.headlineLabel.text = item?.postDetails?.userDetails?.headline ?? " "
//            self.rateLabel.text = "\(item?.rate ?? 0)/5"
            
            if item?.postDetails?.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.postDetails?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }
            
            
            if let date = item?.postDetails?.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
           
           
//            if Utility.getCurrentUserId() == item?.reshareUserDetails?.user_id{
//                self.moreOptionButton.isHidden = true
//            }else{
//                self.moreOptionButton.isHidden = false
//            }
            
            if  item?.postDetails?.post_type == PostType.artical.rawValue ||  item?.postDetails?.post_type == PostType.video.rawValue ||  item?.postDetails?.post_type == PostType.podcast.rawValue{
                self.postImageView.isHidden = true
                self.linkView.isHidden = false
                self.downloadMetaData(link: item?.postDetails?.link ?? "")
            }else{
                if let media = item?.postDetails?.media{
                    Utility.setImage(media, imageView: self.postImageView)
                }
                self.postImageView.isHidden = false
                self.linkView.isHidden = true
                self.postImageLinkViewHeight.constant = 230
            }
            if item?.postDetails?.post_type == 1{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.postDetails?.post_type == 2{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.postDetails?.post_type == 3{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "book_icon")
            }else{
                self.linkClickButton.isHidden = true
                postTypeImageView.image = UIImage(named: "article_icon")
            }
        }
    }
    func downloadMetaData(link: String){
        Utility.loadLinkView(view: self.linkView)
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            guard let strongSelf = self else {
                return
            }
            Utility.hideLinkLoadView(view: strongSelf.linkView)
            if let meta = linkMetaData{
                let linkMetaView = LPLinkView(metadata: meta)
                strongSelf.linkView.addSubview(linkMetaView)
                linkMetaView.metadata = meta
                strongSelf.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 230, height: 200) })
            }
        }
    }
}
