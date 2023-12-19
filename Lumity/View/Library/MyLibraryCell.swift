//
//  MyLibraryCell.swift
//  Source-App
//
//  Created by Nikunj on 24/04/21.
//

import UIKit
import LinkPresentation

class MyLibraryCell: UICollectionViewCell {

    @IBOutlet weak var mainView: dateSportView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var showDataView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var folderOptionButton: UIButton!
    @IBOutlet weak var completedAndSaveForLaterImageView: UIImageView!
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 1.5, y: 1.5, width: self.linkView.frame.width - 3, height: 140) })

    }
    
    var item: MyLibraryListResponse?{
        didSet{
            self.label.text = item?.name
            if item?.postDetails?.post_type == PostType.artical.rawValue || item?.postDetails?.post_type == PostType.video.rawValue || item?.postDetails?.post_type == PostType.podcast.rawValue{
                self.linkView.isHidden = false
                self.postImageView.isHidden = true
                
                Utility.hideLinkLoadView(view: self.linkView)
                self.linkView.subviews.forEach({ $0.removeFromSuperview() })
                if let meta = item?.postDetails?.linkMeta{
                    let linkMetaView = LPLinkView(metadata: meta)
                    self.linkView.addSubview(linkMetaView)
                    linkMetaView.metadata = meta
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: strongSelf.linkView.frame.width, height: 140) })
                    }
                }else{
                    Utility.loadLinkView(view: self.linkView)
                }
            }else{
                self.linkView.isHidden = true
                self.postImageView.isHidden = false
                if let imageUrl = item?.postDetails?.media{
                    Utility.setImage(imageUrl, imageView: self.postImageView)
                }else{
                    self.postImageView.image = nil
                }
            }
        }
    }
    @IBAction func onShare(_ sender: Any) {
        self.onShare?()
    }
    
    @IBAction func onDelete(_ sender: Any) {
        self.onDelete?()
    }
}
