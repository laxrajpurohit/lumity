//
//  UserBlockScreen.swift
//  Source-App
//
//  Created by Nikunj on 04/04/21.
//

import UIKit
import PanModal

// UserBlockScreen: UIViewController subclass to manage user block/unfollow/report actions.
class UserBlockScreen: UIViewController {
    
    // IBOutlet declarations: UI components connected from Storyboard.
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    
    // Variables for data management and control.
    var postItemDataDetailData:PostReponse?
    var isCheckFollowStatus = 2
    var isFromReShare = false
    var onReportPost: (() -> Void)?
    var onUnfollowUser: (() -> Void)?
    
    // ViewDidLoad: Initial setup when view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        panModalSetNeedsLayoutUpdate()
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 16
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        initailDetail()
    }
    
    // initailDetail: Sets up initial labels for follow and block actions.
    func initailDetail(){
        if let data = self.postItemDataDetailData{
            if isFromReShare{
                self.followLabel.text = "Unfollow \(data.reshareUserDetails?.first_name ?? "") \(data.reshareUserDetails?.last_name ?? "")"
                self.blockLabel.text = "Block \(data.reshareUserDetails?.first_name ?? "") \(data.reshareUserDetails?.last_name ?? "")"
            }else{
                self.followLabel.text = "Unfollow \(data.userDetails?.first_name ?? "") \(data.userDetails?.last_name ?? "")"
                self.blockLabel.text = "Block \(data.userDetails?.first_name ?? "") \(data.userDetails?.last_name ?? "")"
            }
            
        }
    }
    
    // MARK: - Actions for various button presses in the UI.
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUnFollow(_ sender: Any) {
        if let data = self.postItemDataDetailData{
            if isFromReShare{
                self.showConfirmationAlert(message: "Are you sure you want to unfollow \(data.reshareUserDetails?.first_name ?? "") \(data.reshareUserDetails?.last_name ?? "")?", type: 3)
            }else{
                self.showConfirmationAlert(message: "Are you sure you want to unfollow \(data.userDetails?.first_name ?? "") \(data.userDetails?.last_name ?? "")?", type: 3)
            }
            
        }
        
    }
    @IBAction func onBlock(_ sender: Any) {
        if let data = self.postItemDataDetailData{
            if isFromReShare{
                self.showConfirmationAlert(message: "Are you sure you want to block \(data.reshareUserDetails?.first_name ?? "") \(data.reshareUserDetails?.last_name ?? "")?", type: 2)
            }else{
                self.showConfirmationAlert(message: "Are you sure you want to block \(data.userDetails?.first_name ?? "") \(data.userDetails?.last_name ?? "")?", type: 2)
            }
        }
        
    }
    @IBAction func onReport(_ sender: Any) {
        self.showConfirmationAlert(message: "Are you sure you want to report this post?", type: 1)
    }
    
    //MARK: - AddJoinUser: Adds or updates user join status.
    func addJoinUser(userId: Int,status: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                //                if status == 2{
                //                    self?.isCheckFollowStatus = 1
                //                }else{
                //                    self?.isCheckFollowStatus = 2
                //                }
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.onUnfollowUser?()
                })
                
                ////                self?.changeJoinStatus(userId: userId,status: status)
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
    
    // MARK: -  Shows a confirmation alert based on the action type.
    func showConfirmationAlert(message:String,type:Int) {
        let alert = UIAlertController(title: APP_NAME, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        if type == 1{
                                            self.dismiss(animated: true, completion: { [weak self] in
                                                self?.onReportPost?()
                                            })
                                        }else if type == 3{
                                            if self.isFromReShare{
                                                self.addJoinUser(userId: self.postItemDataDetailData?.reshareUserDetails?.user_id ?? 0, status: 2)
                                            }else{
                                                self.addJoinUser(userId: self.postItemDataDetailData?.user_id ?? 0, status: 2)
                                            }
                                            
                                        }else if type == 2{
                                            if self.isFromReShare{
                                                self.addJoinUser(userId: self.postItemDataDetailData?.reshareUserDetails?.user_id ?? 0, status: 4)
                                            }else{
                                                self.addJoinUser(userId: self.postItemDataDetailData?.user_id ?? 0, status: 4)
                                            }
                                            
                                        }
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
//MARK: - PanModalPresentable Presentable
extension UserBlockScreen: PanModalPresentable {

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
        return .contentHeight(240)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(240)
    }
    
    var allowsExtendedPanScrolling: Bool{
        return true
    }
    
    var showDragIndicator: Bool{
        return false
    }
}
