//
//  GroupInviteMemberCell.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class GroupInviteMemberCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
                Utility.setImage(item?.profile_pic, imageView: self.userImageView)
               
//            }
            self.userNameLabel.text = "\(item?.first_name ?? "") \(item?.last_name ?? "")"
//            if let headLine = item?.headline{
//                self.bioLabel.text = headLine
//            }else{
//                self.bioLabel.text = item?.bio
//            }
            
       
           
            
        }
    }
    
}
