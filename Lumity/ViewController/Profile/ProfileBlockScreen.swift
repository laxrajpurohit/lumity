//
//  ProfileBlockScreen.swift
//  Source-App
//
//  Created by Nikunj on 02/06/21.
//

import UIKit
import PanModal

class ProfileBlockScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var blockLabel: UILabel!
    
    // MARK: - VARIABLE DECLARE
    var isFromReShare = false
    var userResponse: LoginResponse?
    var onBlockUser: (() -> Void)?
    
    // MARK: - FUNCTIONS
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
        if let data = self.userResponse{
            self.blockLabel.text = "Block \(data.first_name ?? "") \(data.last_name ?? "")"
        }
    }

    // MARK: - ACTIONS
    @IBAction func onBlock(_ sender: Any) {
        if let data = self.userResponse{
            self.showConfirmationAlert(message: "Are you sure you want to block \(data.first_name ?? "") \(data.last_name ?? "")?", type: 2)
        }
    }
    
    func showConfirmationAlert(message:String,type:Int) {
        let alert = UIAlertController(title: APP_NAME, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: { [weak self] (action) in
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        guard let data = strongSelf.userResponse else {
                                            return
                                        }
                                        if strongSelf.isFromReShare == true{
                                            strongSelf.addJoinUser(userId: data.user_id ?? 0, status: 4)
                                        }else{
                                            strongSelf.addJoinUser(userId: data.user_id ?? 0, status: 4)
                                        }
                                        
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addJoinUser(userId: Int,status: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                guard let stronSelf = self else { return }
                stronSelf.dismiss(animated: true, completion: {
                    stronSelf.onBlockUser!()
                })
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
 // MARK: - PRESENT VIEW
extension ProfileBlockScreen: PanModalPresentable {

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
        return .contentHeight(130)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(130)
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
