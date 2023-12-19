//
//  PasswordStrengthCell.swift
//  Source-App
//
//  Created by Nikunj on 21/04/21.
//

import UIKit

class PasswordStrengthCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var item: PasswordStrengthRequest?{
        didSet{
            self.imageView.image = item?.complete == true ? UIImage(named: "ic_password_right") : UIImage(named: "ic_password_wrong")
            self.label.textColor = item?.complete == true ? Utility.getUIcolorfromHex(hex: "00B107") : Utility.getUIcolorfromHex(hex: "FF5555")
            self.label.text = item?.text
        }
    }
}
