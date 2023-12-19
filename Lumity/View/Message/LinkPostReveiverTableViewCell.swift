//
//  LinkPostReveiverTableViewCell.swift
//  Source-App
//
//  Created by iroid on 06/06/21.
//

import UIKit
import LinkPresentation
import ExpandableLabel
class LinkPostReveiverTableViewCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var userImgeView: dateSportImageView!
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var linkView: dateSportView!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var linkClickButton: UIButton!
    
    @IBOutlet weak var messageSendTime: UILabel!
    var onLinkClick : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 250, height: 150) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })
//        self.captionLabel.collapsed = fa
        self.captionLabel.text = nil

    }
        
    @IBAction func onLinkClick(_ sender: UIButton) {
        self.onLinkClick?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var item: MessageData?{
        didSet{
            self.messageSendTime.text = Utility.UTCToLocal(serverDate: item?.createdAt ?? 0)
            self.userNameLabel.text = "\(item?.postDetails?.userDetails?.first_name ?? "") \(item?.postDetails?.userDetails?.last_name ?? "")"
            //            if let image = item?.userDetails?.profile_pic{
            Utility.setImage(item?.postDetails?.userDetails?.profile_pic, imageView: self.userImgeView)
            //            }
            self.headLineLabel.text = item?.postDetails?.userDetails?.headline ?? " "
            //            self.hashTagLabel.text = item?.hashtag
//            self.rateLabel.text = "\(item?.rate ?? 0)/5"
            if item?.postDetails?.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.postDetails?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
//                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }

            self.captionLabel.text = item?.postDetails?.caption
            if let date = item?.postDetails?.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.hourLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
            
            self.downloadMetaData(link: item?.postDetails?.link ?? "")
            
            
//            if let meta = item?.postDetails?.linkMeta{
//                Utility.hideLinkLoadView(view: self.linkView)
//                let linkMetaView = LPLinkView(metadata: meta)
//                self.linkView.addSubview(linkMetaView)
//                linkMetaView.metadata = meta
//                self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 180, height: 100) })
//
//            }else{
//                Utility.loadLinkView(view: self.linkView)
//            }
//
            if item?.postDetails?.post_type == 1{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.postDetails?.post_type == 2{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.postDetails?.post_type == 3{
                self.linkClickButton.isHidden  = true
                postTypeImageView.image = UIImage(named: "book_icon")
            }else{
                self.linkClickButton.isHidden  = false
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
                strongSelf.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 250, height: 150) })
            }
        }
    }
    
}
