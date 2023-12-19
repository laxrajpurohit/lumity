//
//  ReceiverPhotoTableViewCell.swift
//  Tendask
//
//  Created by iroid on 18/03/21.
//

import UIKit

class ReceiverPhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data:MessageData){
        timeLabel.text = Utility.UTCToLocal(serverDate: data.createdAt ?? 0)
        Utility.setImage(data.message, imageView: photoImageView)
    
    }
}
