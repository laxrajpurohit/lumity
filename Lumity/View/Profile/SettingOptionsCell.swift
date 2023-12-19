//
//  SettingOptionsCell.swift
//  Source-App
//
//  Created by Nikunj on 05/05/21.
//

import UIKit

class SettingOptionsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: SettingRequest?{
        didSet{
            self.imageView?.image = UIImage(named: item?.image ?? "")
            self.label.text = item?.title
        }
    }
    
}
