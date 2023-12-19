//
//  TopFivePostCell.swift
//  Source-App
//
//  Created by Nikunj on 11/05/21.
//

import UIKit
import LinkPresentation

class TopFivePostCell: UITableViewCell {

    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: dateSportImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var postViewWidth: NSLayoutConstraint!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var swapeImageView: UIImageView!
    var onLinkClick : (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 120, height: 150) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: PostReponse?{
        didSet{
            if item?.post_type == PostType.artical.rawValue || item?.post_type == PostType.video.rawValue || item?.post_type == PostType.podcast.rawValue{
                self.linkView.isHidden = false
                self.postImageView.isHidden = true
                self.linkView.subviews.forEach({ $0.removeFromSuperview() })
                self.postViewWidth.constant = 120
                if let meta = item?.linkMeta{
                    Utility.hideLinkLoadView(view: self.linkView)
                    let linkMetaView = LPLinkView(metadata: meta)
                    self.linkView.addSubview(linkMetaView)
                    linkMetaView.metadata = meta
                    self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 120, height: 150) })
                }else{
                    Utility.loadLinkView(view: self.linkView)
                }
            }else{
                self.linkView.isHidden = true
                self.postImageView.isHidden = false
                self.postViewWidth.constant = 90
                if let media = item?.localImagePath{
                    print("Load Local")
                    Utility.setImage(media, imageView: self.postImageView)
                }else if let media = item?.media{
                    Utility.setImage(media, imageView: self.postImageView)
                }
            }
            if item?.rate == 0{
                self.rateLabel.isHidden = true
                self.starImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.starImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.starImageView.isHidden = true
            }
            
            self.titleLabel.text = item?.title
            self.autherLabel.text = item?.author
           // self.positionLabel.text = "\((item?.position ?? 0) + 1)"
            self.notesLabel.text = item?.caption
            if item?.post_type == 4{
                self.linkButton.isHidden = false
            }else{
                self.linkButton.isHidden = true
            }
        }
    }
    
    @IBAction func onLink(_ sender: Any) {
        self.onLinkClick?()
    }
}
