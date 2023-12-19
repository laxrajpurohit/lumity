//
//  CommentCell.swift
//  Source-App
//
//  Created by Nikunj on 04/04/21.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var onLike : (() -> Void)?
    var onMore : (() -> Void)?
    var onLikeCount : (() -> Void)?
    var onUser : (() -> Void)?
    var onClickReply: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      //  self.replyButton.gradientButton("Reply", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    var item:PostCommentReponse?{
//        didSet{
//            userNameLabel.text = item?.username
//            self.userNameLabel.text = "\(item?.userDetails?.first_name ?? "") \(item?.userDetails?.last_name ?? "")"
//            Utility.setImage(item?.userDetails?.profile_pic, imageView: self.userImageView)
//            self.headlineLabel.text = item?.userDetails?.headline ?? " "
//            commentTextLabel.text = item?.comment
//            likeCountLabel.text = "\(item?.like_count ?? 0)"
//            if let date = item?.created_at{
//                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
//                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
//            }
//            if let isLike = item?.is_like{
//                if isLike{
//                    likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
//                }else{
//                    likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
//                }
//            }
//
////            if Utility.getCurrentUserId() == item?.user_id{
////                self.moreButton.isHidden = true
////            }else{
////                self.moreButton.isHidden = false
////            }
//        }
//    }
    
    var item: CommentResponse?{
        didSet{
            userNameLabel.text = item?.username
            self.userNameLabel.text = "\(item?.userDetails?.first_name ?? "") \(item?.userDetails?.last_name ?? "")"
            Utility.setImage(item?.userDetails?.profile_pic, imageView: self.userImageView)
            self.headlineLabel.text = item?.userDetails?.headline ?? " "
            commentTextLabel.text = item?.comment
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(labelDidGetTapped))

            self.commentTextLabel.isUserInteractionEnabled = true
            self.commentTextLabel.addGestureRecognizer(tap)
            
            
            likeCountLabel.text = "\(item?.like_count ?? 0)"
            if let date = item?.created_at{
                let createdDate = Utility.getDateTimeFromTimeInterVel(from: date)
                self.timeLabel.text = Utility.timeAgoSinceDate(createdDate)
            }
            if let isLike = item?.is_like{
                if isLike{
                    likeButton.setImage(UIImage(named: "like_selected_icon"), for: .normal)
                }else{
                    likeButton.setImage(UIImage(named: "like_thumb_icon"), for: .normal)
                }
            }
            
//            if Utility.getCurrentUserId() == item?.user_id{
//                self.moreButton.isHidden = true
//            }else{
//                self.moreButton.isHidden = false
//            }
        }
    }
    
    @objc func labelDidGetTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        Utility.successAlert(message: "Comment Copied Successfully")
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        self.onLike?()
    }
    
    @IBAction func onMore(_ sender: UIButton) {
        self.onMore?()
    }
    
    @IBAction func onLikeCount(_ sender: UIButton) {
        self.onLikeCount?()
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
    @IBAction func onReply(_ sender: Any) {
        self.onClickReply?()
    }
}
