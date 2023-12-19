//
//  YourAccountTableViewCell.swift
//  Source-App
//
//  Created by iroid on 07/05/21.
//

import UIKit

class YourAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var subTitlelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item: YourAccoutRequest?{
        didSet{
            self.titlelabel.text = item?.title
            self.subTitlelabel.text = item?.subTitle
        }
    }
}
