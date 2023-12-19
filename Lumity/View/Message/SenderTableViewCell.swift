//
//  SenderTableViewCell.swift
//  Tendask
//
//  Created by iroid on 15/03/21.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageView.layer.cornerRadius = 16
        messageView.layer.maskedCorners = [ .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:MessageData){
        messageLabel.text = data.message
        timeLabel.text = Utility.UTCToLocal(serverDate: data.createdAt ?? 0)
    }
}
