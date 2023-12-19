//
//  UserLinkPostCell.swift
//  Source-App
//
//  Created by Nikunj on 16/05/21.
//

import UIKit
import LinkPresentation

class UserLinkPostCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var linkView: dateSportView!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    var onLink : (() -> Void)?
    var onUser: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 120, height: 100) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    var item: NotificationResponse?{
        didSet{
            if let meta = item?.post_details?.linkMeta{
                Utility.hideLinkLoadView(view: self.linkView)
                let linkMetaView = LPLinkView(metadata: meta)
                self.linkView.addSubview(linkMetaView)
                linkMetaView.metadata = meta
                self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 120, height: 100) })
            }else{
                Utility.loadLinkView(view: self.linkView)
            }
            Utility.setImage(item?.notification_user_detail?.profile_pic ?? "", imageView: self.userImageView)
            var string = "\(item?.notification_user_detail?.first_name ?? "") \(item?.notification_user_detail?.last_name ?? "") \(item?.message ?? ""). "
            
            
            guard let date = item?.created_at else{
                return
            }
            let createdDate = Utility.timeAgoSinceDate(Utility.getDateTimeFromTimeInterVel(from: date))
            string += createdDate
            
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 16)!], range: (string as NSString).range(of: "\(item?.notification_user_detail?.first_name ?? "") \(item?.notification_user_detail?.last_name ?? "")"))
            
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 16)!,NSAttributedString.Key.foregroundColor : UIColor.lightGray], range: (string as NSString).range(of: createdDate))
            
            self.messageLabel.attributedText = attributedString

            
            if item?.post_details?.post_type == PostType.artical.rawValue{
                self.linkButton.isHidden = false
            }else{
                self.linkButton.isHidden = true
            }
        }
    }
    
    @IBAction func onLink(_ sender: Any) {
        self.onLink?()
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
}
