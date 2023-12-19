//
//  UserPostCell.swift
//  Source-App
//
//  Created by Nikunj on 16/05/21.
//

import UIKit

class UserPostCell: UITableViewCell {

    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postImageView: dateSportImageView!
    
    var onUser: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: NotificationResponse?{
        didSet{
            if let img = item?.post_details?.media{
                Utility.setImage(img, imageView: self.postImageView)
            }
            
            Utility.setImage(item?.notification_user_detail?.profile_pic ?? "", imageView: self.userImageView)
            
            var string = ""
            
            if item?.post_details?.post_type == 3{
                 string = "\(item?.notification_user_detail?.first_name ?? "") \(item?.notification_user_detail?.last_name ?? "") \(item?.message ?? "") "
            }else{
                 string = "\(item?.notification_user_detail?.first_name ?? "") \(item?.notification_user_detail?.last_name ?? "") \(item?.message ?? ""). "
            }
            
            if item?.post_details?.post_type == 5{
                self.postImageView.isHidden = true
            }else{
                self.postImageView.isHidden = false
            }
            
            guard let date = item?.created_at else{
                return
            }
            let createdDate = Utility.timeAgoSinceDate(Utility.getDateTimeFromTimeInterVel(from: date))
            string += createdDate
            
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 16)!], range: (string as NSString).range(of: "\(item?.notification_user_detail?.first_name ?? "") \(item?.notification_user_detail?.last_name ?? "")"))
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.lightGray], range: (string as NSString).range(of: "\(createdDate)"))
            
            self.messageLabel.attributedText = attributedString
        }
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
}
