//
//  UserListMessageTableViewCell.swift
//  Source-App
//
//  Created by iroid on 06/06/21.
//

import UIKit

class UserListMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var onlineStatusImageView: dateSportImageView!
    @IBOutlet weak var sendMessageSelectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item: UserInterestList?{
        didSet{
//            if let image = item?.profile_pic, != ""{
                Utility.setImage(item?.profile_pic, imageView: self.profileImageView)
//            }
            self.nameLabel.text = "\(item?.first_name ?? "") \(item?.last_name ?? "")"
            if let headLine = item?.headline{
                self.headlineLabel.text = headLine
            }else{
                self.headlineLabel.text = item?.bio
            }
            if item?.is_online ?? false{
                onlineStatusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.8365593553, blue: 0.6070920229, alpha: 1)
            }else{
                onlineStatusImageView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
            }
          
//            if Utility.getCurrentUserId() == item?.user_id{
//                joinMainView.isHidden = true
//            }else{
//                joinMainView.isHidden = false
//            }
        }
    }
}
