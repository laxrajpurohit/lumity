//
//  FolderSenderTableViewCell.swift
//  Source-App
//
//  Created by iroid on 06/06/21.
//

import UIKit
import LinkPresentation
class FolderSenderTableViewCell: UITableViewCell {

    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var folderNamelabel: UILabel!
    @IBOutlet weak var showDataView: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var messageSendTime: UILabel!
    var onShare: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.linkView.subviews.forEach({ $0.frame = CGRect(x: 1.5, y: 1.5, width: self.linkView.frame.width - 3, height: 140) })

    }
    
    var item: MessageData?{
        didSet{
//            self.label.text = item?.name
            self.folderNamelabel.text = item?.mylibraryDetails?.name
            self.messageSendTime.text = Utility.UTCToLocal(serverDate: item?.createdAt ?? 0)
            if item?.mylibraryDetails?.postDetails?.post_type == PostType.artical.rawValue || item?.mylibraryDetails?.postDetails?.post_type == PostType.video.rawValue || item?.mylibraryDetails?.postDetails?.post_type == PostType.podcast.rawValue{
                self.linkView.isHidden = false
                self.postImageView.isHidden = true
                
                Utility.hideLinkLoadView(view: self.linkView)
                self.linkView.subviews.forEach({ $0.removeFromSuperview() })
                
                self.downloadMetaData(link: item?.mylibraryDetails?.postDetails?.link ?? "")
            }else{
                self.linkView.isHidden = true
                self.postImageView.isHidden = false
                if let imageUrl = item?.mylibraryDetails?.postDetails?.media{
                    Utility.setImage(imageUrl, imageView: self.postImageView)
                }else{
                    self.postImageView.image = nil
                }
            }
        }
    }
    func downloadMetaData(link: String){
        Utility.loadLinkView(view: self.linkView)
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, linkMetaData) in
            guard let strongSelf = self else {
                return
            }
            Utility.hideLinkLoadView(view: strongSelf.linkView)
            if let meta = linkMetaData{
                let linkMetaView = LPLinkView(metadata: meta)
                strongSelf.linkView.addSubview(linkMetaView)
                linkMetaView.metadata = meta
                strongSelf.linkView.subviews.forEach({ $0.frame = CGRect(x: 0, y: 0, width: 200, height: 200) })
            }
        }
    }
}

