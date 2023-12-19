//
//  PostTypeCell.swift
//  Source-App
//
//  Created by iroid on 04/04/21.
//

import UIKit

class PostTypeCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUpData(){
        
    }
    
    var item: PostTypeModel?{
        didSet{
            titleLabel.text = item?.title
            postImageView.image = UIImage(named: item?.image ?? "")
        }
    }
}
