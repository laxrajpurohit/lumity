//
//  PostTypeFilterCell.swift
//  Source-App
//
//  Created by iroid on 04/04/21.
//

import UIKit

class PostTypeFilterCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTypeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var item: PostTypeModel?{
        didSet{
            
            if item?.isSelected ?? false{
                postTypeView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }else{
                postTypeView.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
            }
            titleLabel.text = item?.title
            postImageView.image = UIImage(named: item?.image ?? "")
        }
    }
    
    var setItemMyLibrary: PostTypeModel?{
        didSet{
            
//            if item?.isSelected ?? false{
//                postTypeView.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.7843137255, blue: 0.9568627451, alpha: 1)
//            }else{
//                postTypeView.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
//            }
            titleLabel.text = setItemMyLibrary?.title
            postImageView.image = UIImage(named: setItemMyLibrary?.image ?? "")
        }
    }

}
