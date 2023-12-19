//
//  SelectPostCell.swift
//  Source-App
//
//  Created by Nikunj on 25/04/21.
//

import UIKit
import LinkPresentation

class SelectPostCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: dateSportImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unselectedView: dateSportView!
    @IBOutlet weak var selectedView: dateSportView!
    @IBOutlet weak var postImageMainView: UIView!
    @IBOutlet weak var linkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })

    }

    var item: PostReponse?{
        didSet{
            if item?.post_type == PostType.artical.rawValue || item?.post_type == PostType.video.rawValue || item?.post_type == PostType.podcast.rawValue{
                self.linkView.isHidden = false
                self.postImageMainView.isHidden = true
                
                Utility.hideLinkLoadView(view: self.linkView)
                self.linkView.subviews.forEach({ $0.removeFromSuperview() })

                if let meta = item?.linkMeta{
                    let linkMetaView = LPLinkView(metadata: meta)
                    self.linkView.addSubview(linkMetaView)
                    linkMetaView.metadata = meta
                    self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150) })
                }else{
                    Utility.loadLinkView(view: self.linkView)
                }
            }else{
                self.linkView.isHidden = true
                self.postImageMainView.isHidden = false
                if let media = item?.localImagePath{
                    print("Load Local")
                    Utility.setImage(media, imageView: self.postImageView)
                }else if let media = item?.media{
                    Utility.setImage(media, imageView: self.postImageView)
                }
            }
            
//            if item?.post_type == PostType.artical.rawValue{
//                articlePostButton.isHidden = false
//            }else{
//                articlePostButton.isHidden = true
//            }
            self.titleLabel.text = item?.title
            self.authorLabel.text = item?.author
            if item?.post_type == PostType.artical.rawValue || item?.post_type == PostType.video.rawValue || item?.post_type == PostType.podcast.rawValue{
                self.titleLabel.text = item?.caption
            }
        }
    }
}
