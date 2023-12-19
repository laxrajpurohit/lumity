//
//  ExploreIntrestCell.swift
//  Source-App
//
//  Created by Nikunj on 17/04/21.
//

import UIKit

class ExploreIntrestCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: InterestsListData?{
        didSet{
            self.label.text = item?.name
            Utility.setImage(item?.image, imageView:self.imageView)
        }
    }

}
