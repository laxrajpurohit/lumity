//
//  SelectPostTopFiveCell.swift
//  Source-App
//
//  Created by Nikunj on 12/05/21.
//

import UIKit

class SelectPostTopFiveCell: UITableViewCell {

    @IBOutlet weak var addFromCompletedView: UIView!
    
    var onCompleted: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onCompleted(_ sender: Any) {
        self.onCompleted?()
    }
}
