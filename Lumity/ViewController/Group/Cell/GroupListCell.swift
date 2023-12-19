//
//  GroupListCell.swift
//  Lumity
//
//  Created by Nikunj on 26/09/22.
//

import UIKit

class GroupListCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupBioLabel: UILabel!
    @IBOutlet weak var sendPostSelectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: GroupListData?{
        didSet{
            Utility.setImage(item?.profile, imageView: self.userImageView)
            self.groupNameLabel.text = item?.name ?? ""
            self.groupBioLabel.text = item?.bio ?? ""
        }
    }
}
