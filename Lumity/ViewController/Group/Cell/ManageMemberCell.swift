//
//  ManageMemberCell.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class ManageMemberCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var removeBackGroundView: GradientView2!
    
    var onRemoveClick : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
//        self.removeButton.gradientButton("Remove", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 0, cornerRadius: 0)

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
            
            if item?.user_id == Utility.getCurrentUserId(){
                self.removeBackGroundView.isHidden = true
            }else{
                self.removeBackGroundView.isHidden = false
            }
        }
    }
    
    @IBAction func onRemove(_ sender: UIButton) {
        self.onRemoveClick!()
    }
    
}
