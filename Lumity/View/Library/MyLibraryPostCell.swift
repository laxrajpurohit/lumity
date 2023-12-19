//
//  MyLibraryPostCell.swift
//  Source-App
//
//  Created by Nikunj on 24/04/21.
//

import UIKit
import LinkPresentation

class MyLibraryPostCell: UICollectionViewCell {
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var postImageMainView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var autherName: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var articlePostButton: UIButton!
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var autherLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstant: NSLayoutConstraint!
    
    var onSharePost: (() -> Void)?
    var onDelete: (() -> Void)?
    var onLinkClick: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//            self.linkMetaView?.frame =  self.linkView.bounds
        self.postImageMainView.isHidden = true
        self.linkView.isHidden = true
        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150) })
        self.linkView.subviews.forEach({ $0.removeFromSuperview() })
       
        
    }
    @IBAction func onShare(_ sender: Any) {
        self.onSharePost?()
    }
    
    @IBAction func onDelete(_ sender: Any) {
        self.onDelete?()
    }
    
    @IBAction func onAeticle(_ sender: Any) {
        self.onLinkClick?()
    }
    
    var item: PostReponse?{
        didSet{
            
            if item?.post_type == PostType.book.rawValue{
                self.titleLabelHeight.constant = 20
                self.autherLabelHeight.constant = 19
                self.titleTopConstant.constant = 15
            }else{
                self.titleLabelHeight.constant = 0
                self.autherLabelHeight.constant = 0
                self.titleTopConstant.constant = 0
            }
            
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
            self.autherName.text = item?.author
            self.captionLabel.text = item?.caption
//            self.rateLabel.text = "\(item?.rate ?? 0)/5"
            if item?.rate == 0{
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }else{
                self.rateLabel.text = "\(item?.rate ?? 0)/5"
//                self.rateLabel.isHidden = false
//                self.startImageView.isHidden = false
                
                self.rateLabel.isHidden = true
                self.startImageView.isHidden = true
            }
        }
    }
}
