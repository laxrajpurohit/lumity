//
//  PostTypeScreen.swift
//  Source-App
//
//  Created by iroid on 04/04/21.
//

import UIKit

class PostTypeScreen: UIViewController {

    // MARK: - VARIABLE DECLARE
    @IBOutlet weak var postTypeCollectionView: UICollectionView!
    
    // MARK: - OUTLETS
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: false),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: false),PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: false),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: false)]
    
    var superVC: UIViewController?
    var isFromShare: Bool = false
    var shareURL: URL?
    
    var isFromGroup = false
    var groupId:Int?

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDetail()
    }
    func initialDetail(){
        let nib = UINib(nibName: "PostTypeCell", bundle: nil)
        postTypeCollectionView.register(nib, forCellWithReuseIdentifier: "PostTypeCell")
        if self.isFromShare {
            self.postTypeData.remove(at: 2)
        }
        
        if self.isFromGroup{
            self.postTypeData.append(PostTypeModel(postType: 5,title: "Text", image: "text_icon", isSelected: false))
        }
        
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension PostTypeScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTypeCell", for: indexPath) as! PostTypeCell
        cell.item = postTypeData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-8, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isFromShare{
            switch indexPath.row {
            case 0:
               let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
                vc.superVC = self.superVC
                vc.isFromShare = self.isFromShare
                vc.shareLink = self.shareURL
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
                vc.superVC = self.superVC
                vc.isFromShare = self.isFromShare
                vc.shareLink = self.shareURL
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "TextPostScreen") as! TextPostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                if let groupDetailVC = self.superVC as? GroupDetailScreen{
                   vc.completeAddNewPostDelegate = groupDetailVC
               }
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
                vc.superVC = self.superVC
                vc.isFromShare = self.isFromShare
                vc.shareLink = self.shareURL
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            switch indexPath.row {
            case 0:
               let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                self.navigationController?.pushViewController(vc, animated: true)

            case 2:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "TextPostScreen") as! TextPostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                if let groupDetailVC = self.superVC as? GroupDetailScreen{
                   vc.completeAddNewPostDelegate = groupDetailVC
               }
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
                vc.superVC = self.superVC
                vc.groupId = self.groupId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
