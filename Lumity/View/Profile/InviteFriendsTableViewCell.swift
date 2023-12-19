//
//  InviteFriendsTableViewCell.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.inviteButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
