//
//  MyLibraryPostTypeScreen.swift
//  Source-App
//
//  Created by Nikunj on 24/04/21.
//

import UIKit

class MyLibraryPostTypeScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var postTypeCollectionView: UICollectionView!
    
    var postTypeData:[PostTypeModel] = [PostTypeModel(postType: 1,title: "Podcast", image: "podcast_icon", isSelected: false),PostTypeModel(postType: 2,title: "Video", image: "video_icon", isSelected: false),PostTypeModel(postType: 3,title: "Book", image: "book_icon", isSelected: false),PostTypeModel(postType: 4,title: "Article", image: "article_icon", isSelected: false)]

    
    var myLibraryObj: MyLibraryListResponse?
    var postWise: PostWise?
    var superVC: UIViewController?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDetail()
    }
    
    func initialDetail(){
        let nib = UINib(nibName: "PostTypeCell", bundle: nil)
        self.postTypeCollectionView.register(nib, forCellWithReuseIdentifier: "PostTypeCell")
       
        
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension MyLibraryPostTypeScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        switch indexPath.row {
        case 0:
           let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PodcastPostScreen") as! PodcastPostScreen
            vc.myLibraryObj = self.myLibraryObj
            vc.superVC = self.superVC
            vc.postWise = self.postWise
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "VideoPostScreen") as! VideoPostScreen
            vc.myLibraryObj = self.myLibraryObj

            vc.superVC = self.superVC
            vc.postWise = self.postWise
             self.navigationController?.pushViewController(vc, animated: true)

        case 2:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
            vc.myLibraryObj = self.myLibraryObj

            vc.superVC = self.superVC
            vc.postWise = self.postWise
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "ArticlePostScreen") as! ArticlePostScreen
            vc.myLibraryObj = self.myLibraryObj

             vc.superVC = self.superVC
            vc.postWise = self.postWise
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
