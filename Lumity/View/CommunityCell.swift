//
//  CommunityCell.swift
//  Source-App
//
//  Created by Nikunj on 26/03/21.
//

import UIKit

class CommunityCell: UITableViewCell {

    @IBOutlet weak var userImageView: dateSportImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var joinBtnBGView: dateSportView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinMainView: UIView!
    var onJoin: (() -> Void)?
    
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
            if let headLine = item?.headline{
                self.bioLabel.text = headLine
            }else{
                self.bioLabel.text = item?.bio
            }
            
            let string = "Interests: \(item?.interest ?? "")"
            let attributedString = NSMutableAttributedString(string: string)
            let allrange = (string as NSString).range(of: string)
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri", size: 16)!], range: allrange)
            let interestRange = (string as NSString).range(of: "Interests:")
            attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 16)!], range: interestRange)
            self.interestLabel.attributedText = attributedString
            if item?.join_status == 1{
                self.setJoinStatus(isJoin: true)
            }else if item?.join_status == 0{
                self.setJoinStatus(isJoin: false)
            }else{
                self.setJoinStatus(isJoin: false)
            }
            if Utility.getCurrentUserId() == item?.user_id{
                joinMainView.isHidden = true
            }else{
                joinMainView.isHidden = false
            }
        }
    }
    
    @IBAction func onJoin(_ sender: Any) {
        self.onJoin?()
    }
            
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
    
//    func removeGradient(selectedGradientView:UIView){
//        selectedGradientView.layer.sublayers = selectedGradientView.layer.sublayers?.filter { theLayer in
//                !theLayer.isKind(of: CAGradientLayer.classForCoder())
//          }
//    }
}
