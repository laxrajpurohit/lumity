//
//  VolumeTableViewCell.swift
//  GoogleBooksAPIProject
//
//  Created by Maria Saveleva on 02/03/2019.
//  Copyright © 2019 Maria Saveleva. All rights reserved.
//

import UIKit

class VolumeTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var volumeTitleLabel: UILabel!
    @IBOutlet weak var autherNameLabel: UILabel!
    
    var item:Volume?{
        didSet{
            self.volumeTitleLabel.text = item?.title
            self.autherNameLabel.text = "by \(item?.authors?.first ?? "")"
            Utility.setImage(item?.image, imageView:  bookImageView)
        }
    }
    
    var youTubeVideoData:YouTubeVideoData?{
        didSet{
            self.volumeTitleLabel.text = youTubeVideoData?.title
            self.autherNameLabel.text = "\(youTubeVideoData?.description ?? "")"
            Utility.setImage(youTubeVideoData?.image, imageView:  bookImageView)
        }
    }
    
}
