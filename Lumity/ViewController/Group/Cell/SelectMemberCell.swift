//
//  SelectMemberCell.swift
//  Lumity
//
//  Created by Nikunj on 27/09/22.
//

import UIKit

class SelectMemberCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var onRemoveClick : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: UserInterestList?{
        didSet{
            self.userNameLabel.text = "\(item?.first_name ?? "") \(item?.last_name ?? "")"
        }
    }
    
    @IBAction func onRemove(_ sender: UIButton) {
        self.onRemoveClick!()
    }
}
