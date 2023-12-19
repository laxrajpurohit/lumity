//
//  ShareMyLibraryPostScreen.swift
//  Source-App
//
//  Created by Nikunj on 22/06/21.
//

import UIKit
import PanModal


class ShareMyLibraryPostScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var saveToLaterIcon: UIImageView!
    @IBOutlet weak var addToCompletedImageView: UIImageView!
    
    var postItemDataDetailData:PostReponse?
    var deletePost : (() -> Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        panModalSetNeedsLayoutUpdate()
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 16
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.initailDetail()
        // Do any additional setup after loading the view.
    }
    
    func initailDetail(){
        if let isSave = postItemDataDetailData?.user_is_saved{
            if isSave == 1{
                self.saveToLaterIcon.image = UIImage(named: "is_save_selected_icon")
            }else{
                self.saveToLaterIcon.image = UIImage(named: "save_to_ater_icon")
            }
        }
        if let isCompleted = postItemDataDetailData?.user_is_complete{
            if isCompleted == 1{
                self.addToCompletedImageView.image = UIImage(named: "completedlist_icon")
            }else{
                self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
            }
        }
        
    }
    
    func displayDeleteDialogue(obj: PostReponse){
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "Are you sure you want to delete this item from your playlist?", preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true) { [weak self] in
                self?.deletePost?()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveForLater(postId: Int,isSave: Int?,isCompleted:Int?){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = MyLibraryCompletePostRequest(mylibrary_id: self.postItemDataDetailData?.mylibrary_id, post_id: self.postItemDataDetailData?.id, is_saved: isSave, is_complete: isCompleted)
            MyLibraryService.shared.saveCompletedPost(parameters: data.toJSON()) { (stausCode, response) in
                Utility.hideIndicator()
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onSaveOrLater(_ sender: Any) {
        var isSave = 0
        if postItemDataDetailData?.user_is_saved == 0{
            isSave = 1
            postItemDataDetailData?.user_is_saved = 1
            self.saveToLaterIcon.image = UIImage(named: "is_save_selected_icon")
        }else{
            isSave = 0
            postItemDataDetailData?.user_is_saved = 0
            self.saveToLaterIcon.image = UIImage(named: "save_to_ater_icon")
        }
            
        self.saveForLater(postId: postItemDataDetailData?.id ?? 0, isSave: isSave , isCompleted: nil)//postItemDataDetailData?.user_is_complete ?? 0)
    }
    
    @IBAction func onCompleted(_ sender: Any) {
        
        var isCompleted = 0
        if postItemDataDetailData?.user_is_complete == 0{
            isCompleted = 1
            postItemDataDetailData?.user_is_complete = 1
            self.addToCompletedImageView.image = UIImage(named: "completedlist_icon")
        }else{
            isCompleted = 0
            postItemDataDetailData?.user_is_complete = 0
            self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
        }
        
        self.saveForLater(postId: postItemDataDetailData?.id ?? 0, isSave: nil, isCompleted: isCompleted)// postItemDataDetailData?.user_is_saved ?? 0 , isCompleted: isCompleted)
        
    }
    
    
    @IBAction func onDelete(_ sender: UIButton) {
        
        self.displayDeleteDialogue(obj: postItemDataDetailData!)
    }
}
//MARK: - PANMODAL DELEGATE
extension ShareMyLibraryPostScreen: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(230)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(230)
    }
    
    var allowsExtendedPanScrolling: Bool{
        return true
    }
    
    var showDragIndicator: Bool{
        return false
    }
    
    
//    var panModalBackgroundColor: UIColor{
//        return Utility.getUIcolorfromHex(hex: "eaeaea")
//    }
}
