//
//  CompleteSaveLaterPostScreen.swift
//  Source-App
//
//  Created by Nikunj on 24/06/21.
//

import UIKit
import PanModal

class CompleteSaveLaterPostScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addToCompletedView: UIView!
    
    @IBOutlet weak var optionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var addToCompletedImageView: UIImageView!
    
    var postItemDataDetailData:PostReponse?
    var completePost : (() -> Void)?
    var deletePost : (() -> Void)?
    var postWise: PostWise = .saveForLater
    
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
        if let isCompleted = postItemDataDetailData?.user_is_complete{
            if isCompleted == 1{
                self.addToCompletedImageView.image = UIImage(named: "completedlist_icon")
            }else{
                self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
            }
        }
        self.optionHeightConstant.constant = self.postWise == .completed ? 50 : 100
        self.addToCompletedView.isHidden = self.postWise == .completed ? true : false
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
    
    func completedPost(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = SaveToCompletePostRequest(id: self.postItemDataDetailData?.id, mylibrary_post_id: self.postItemDataDetailData?.mylibrary_post_id)
            MyLibraryService.shared.saveForLaterToComplete(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.dismiss(animated: true) { [weak self] in
                    self?.completePost?()
                }

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
    @IBAction func onCompleted(_ sender: Any) {
            self.addToCompletedImageView.image = UIImage(named: "is_completed_unSelected_icon")
//        }
        
        self.completedPost()// postItemDataDetailData?.user_is_saved ?? 0 , isCompleted: isCompleted)
        
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        
        self.displayDeleteDialogue(obj: postItemDataDetailData!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: - PANMODAL DELEGATE
extension CompleteSaveLaterPostScreen: PanModalPresentable {

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
        return .contentHeight(self.postWise == .completed ? 120 : 170)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(self.postWise == .completed ? 120 : 170)
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
