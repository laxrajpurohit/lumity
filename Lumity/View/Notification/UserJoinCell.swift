//
//  UserJoinCell.swift
//  Source-App
//
//  Created by Nikunj on 16/05/21.
//

import UIKit

class UserJoinCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var joinBtnBGView: dateSportView!
    @IBOutlet weak var joinButton: UIButton!
    
    var onJoin: (() -> Void)?
    var onUser: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var item: NotificationResponse?{
        didSet{
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
            
            if item?.notification_user_detail?.join_status == 1{
                self.setJoinStatus(isJoin: true)
            }else if item?.notification_user_detail?.join_status == 0{
                self.setJoinStatus(isJoin: false)
            }else{
                self.setJoinStatus(isJoin: false)
            }
            if item?.type == 11{
                self.joinBtnBGView.isHidden = true
            }else{
                self.joinBtnBGView.isHidden = false
            }
            
        }
    }
    
//    func setJoinStatus(isJoin: Bool){
//        if isJoin{
//            self.joinBtnBGView.backgroundColor = .white
//            self.joinButton.setTitle("Joined", for: .normal)
//            self.joinButton.setTitleColor(.black, for: .normal)
//            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "707070")
//        }else{
//            self.joinBtnBGView.backgroundColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
//            self.joinButton.setTitle("Join", for: .normal)
//            self.joinButton.setTitleColor(.white, for: .normal)
//            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
//        }
//    }
    
    func setJoinStatus(isJoin: Bool){
        if isJoin{
            self.joinBtnBGView.backgroundColor = .white
            self.joinButton.setTitle("Joined", for: .normal)
            self.joinButton.setTitleColor(.black, for: .normal)
            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "707070")
            self.joinBtnBGView.borderWidth = 1
            removeGradient(selectedGradientView: self.joinBtnBGView)
        }else{
            
//            self.joinBtnBGView.backgroundColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
            self.joinButton.setTitle("Join", for: .normal)
            self.joinButton.setTitleColor(.white, for: .normal)
            self.joinBtnBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            self.joinBtnBGView.borderWidth = 0
//            self.joinBtnBGView.borderColor = Utility.getUIcolorfromHex(hex: "5BB5BE")
        }
    }
    
    @IBAction func onUser(_ sender: Any) {
        self.onUser?()
    }
    
    @IBAction func onJoin(_ sender: Any) {
        self.onJoin?()
    }
}
