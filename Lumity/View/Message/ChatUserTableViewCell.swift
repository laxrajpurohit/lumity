//
//  ChatUserTableViewCell.swift
//  Tendask
//
//  Created by iroid on 15/03/21.
//

import UIKit

class ChatUserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadMessageCount: UILabel!
    @IBOutlet weak var unReadMessageView: UIView!
    @IBOutlet weak var onlineStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setUpData(model:ChatListData){
        Utility.setImage(model.user?.profile_pic, imageView: profileView)
        self.nameLabel.text = "\(model.user?.full_name ?? "")"
        
//        if let serverDate = model.time{
//
//            let createdDate = Utility.getDateTimeFromTimeInterVel(from: serverDate)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
//            let date = dateFormatter.string(from: createdDate)
//
//            if let convertedDate = dateFormatter.date(from: date){
//                dateFormatter.dateFormat = "h:mm a"
//                dateFormatter.timeZone = .current
//                let finaleDate = dateFormatter.string(from: convertedDate)
//                self.timeLabel.text = finaleDate
//            }
//        }
        
        var keyName = Utility.UTCToLocaltimeInterval(date: model.time ?? 0, fromFormat: YYYY_MM_DDHHMMSS, toFormat: MM_DD_YYYY)
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = MM_DD_YYYY
        let dateString = df.string(from: date)
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let yesterdayDate = df.string(from: yesterday)
        if dateString == keyName{
            keyName = Utility.UTCToLocal(serverDate: model.time ?? 0)
        }else if yesterdayDate == keyName{
            keyName = "Yesterday"
        }
        timeLabel.text = keyName
        
        if model.unseen_message == 0{
            unReadMessageView.isHidden = true
        }else{
            unReadMessageView.isHidden = false
        }
        unreadMessageCount.text = "\(model.unseen_message ?? 0)"
        
        if model.is_online ?? false{
            onlineStatusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.8365593553, blue: 0.6070920229, alpha: 1)
        }else{
            onlineStatusImageView.backgroundColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
        }
        if model.type == 1{
            messageLabel.text = model.message
        }else if model.type == 2{
            messageLabel.text = "Photo"
        }else if model.type == 3{
            messageLabel.text = "Book"
        }else if model.type == 4{
            messageLabel.text = "Podcast"
        }else if model.type == 5{
            messageLabel.text = "Youtube"
        }else if model.type == 6{
            messageLabel.text = "Article"
        }else if model.type == 7{
            messageLabel.text = "Reshare"
        }else if model.type == 8{
            messageLabel.text = "Folder"
        }
    }
}



