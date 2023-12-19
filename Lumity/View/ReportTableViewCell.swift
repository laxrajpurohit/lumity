//
//  ReportTableViewCell.swift
//  Source-App
//
//  Created by iroid on 10/04/21.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item: ReportTitleModel?{
        didSet{
            reportTitleLabel.text = item?.title
        }
    }
    
}
