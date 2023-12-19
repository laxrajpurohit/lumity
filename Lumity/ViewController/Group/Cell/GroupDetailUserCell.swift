//
//  GroupDetailUserCell.swift
//  Lumity
//
//  Created by iMac on 24/10/22.
//

import UIKit

class GroupDetailUserCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupBioLabel: UILabel!
    @IBOutlet weak var groupMemberCountLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var editGroupButton: UIButton!
    
    var onEdit:(()->Void)? = nil
    var onInvite:(()->Void)? = nil
    var onViewProfile:(()->Void)? = nil
    var onMember:(()->Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        inviteButton.gradientButton("Invite", startColor: #colorLiteral(red: 0.4160000086, green: 0.4079999924, blue: 0.949000001, alpha: 1), endColor: #colorLiteral(red: 0.97299999, green: 0.4670000076, blue: 0.5920000076, alpha: 1), borderWidth: 1, cornerRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        self.onEdit?()
    }
    
    @IBAction func onInvite(_ sender: UIButton) {
        self.onInvite?()
    }
    
    @IBAction func onMember(_ sender: UIButton) {
        self.onMember?()
    }
    
    @IBAction func onProfileView(_ sender: UIButton) {
        self.onViewProfile?()
    }
    
}
