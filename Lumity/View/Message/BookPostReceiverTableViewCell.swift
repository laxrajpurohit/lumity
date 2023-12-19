//
//  BookPostReceiverTableViewCell.swift
//  Source-App
//
//  Created by iroid on 06/06/21.
//

import UIKit
import ExpandableLabel
class BookPostReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var captionLabel: ExpandableLabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var messageSendTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    var item: MessageData?{
        didSet{
            messageSendTime.text = Utility.UTCToLocal(serverDate: item?.createdAt ?? 0)
            self.userNameLabel.text = "\(item?.postDetails?.userDetails?.first_name ?? "") \(item?.postDetails?.userDetails?.last_name ?? "")"
            if let image = item?.postDetails?.userDetails?.profile_pic{
                Utility.setImage(image, imageView: self.userImageView)
            }
            self.captionLabel.text = item?.postDetails?.caption
            self.headlineLabel.text = item?.postDetails?.userDetails?.headline ?? " "
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
            if let media = item?.postDetails?.media{
                Utility.setImage(media, imageView: self.postImageView)
            }
            if item?.postDetails?.post_type == 1{
                postTypeImageView.image = UIImage(named: "podcast_icon")
            }else if item?.postDetails?.post_type == 2{
                postTypeImageView.image = UIImage(named: "video_icon")
            }else if item?.postDetails?.post_type == 3{
                postTypeImageView.image = UIImage(named: "book_icon")
            }else{
                postTypeImageView.image = UIImage(named: "article_icon")
            }
        }
    }
}


