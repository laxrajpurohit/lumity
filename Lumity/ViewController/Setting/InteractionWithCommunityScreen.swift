//
//  InteractionWithCommunityScreen.swift
//  Source-App
//
//  Created by iroid on 08/05/21.
//

import UIKit

class InteractionWithCommunityScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var likeSwitch: UISwitch!
    @IBOutlet weak var commentsOnYourPostSwitch: UISwitch!
    @IBOutlet weak var sharesOfYourPostSwitch: UISwitch!
    @IBOutlet weak var taggedYouInPostSwitch: UISwitch!
    @IBOutlet weak var newMemberSwitch: UISwitch!
    @IBOutlet weak var savedYourPostLaterSwitch: UISwitch!
    @IBOutlet weak var markedYourPostAsCompletedSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveView: UIView!
    
    var notificationSettingData :NotificationSettingResponse?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    func initialDetail(){
        likeSwitch.isOn = notificationSettingData?.like_post ?? true
        commentsOnYourPostSwitch.isOn = notificationSettingData?.comment_post ?? true
        sharesOfYourPostSwitch.isOn = notificationSettingData?.shares_post ?? true
        taggedYouInPostSwitch.isOn = notificationSettingData?.tagged_post ?? true
        newMemberSwitch.isOn = notificationSettingData?.new_member_community ?? true
        savedYourPostLaterSwitch.isOn = notificationSettingData?.saved_post ?? true
        markedYourPostAsCompletedSwitch.isOn = notificationSettingData?.marked_post ?? true
        enableSaveButton(isEnable: false)
//       self.saveView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
    }
    
    func enableSaveButton(isEnable: Bool){
        self.saveView.removeGradient(selectedGradientView: self.saveView)
        isEnable == true ?  self.saveView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.saveView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        self.saveButton.isUserInteractionEnabled = isEnable
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onLikeOnYourPostSwitch(_ sender: UISwitch) {
        
        notificationSettingData?.like_post  = likeSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    @IBAction func onCommentOnYorPostSwitch(_ sender: UISwitch) {
        notificationSettingData?.comment_post  = commentsOnYourPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    @IBAction func onShareOfYourPostSwitch(_ sender: UISwitch) {
        notificationSettingData?.shares_post  = sharesOfYourPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onTaggedSwitch(_ sender: UISwitch) {
        notificationSettingData?.tagged_post  = taggedYouInPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    @IBAction func onNewMemberSwitch(_ sender: UISwitch) {
        notificationSettingData?.new_member_community  = newMemberSwitch.isOn
        enableSaveButton(isEnable: true)
    }
   
    @IBAction func onSavedYourPostForLaterSwitch(_ sender: UISwitch) {
        notificationSettingData?.saved_post  = savedYourPostLaterSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onMarkedYourPostAsCompletedSwitch(_ sender: UISwitch) {
        notificationSettingData?.marked_post  = commentsOnYourPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        updateNotification()
    }
}
extension InteractionWithCommunityScreen{
    //MARK:- Notification Preferences
//    func getNotification(){
//        if Utility.isInternetAvailable(){
//            //        Utility.showIndicator()
//            ProfileService.shared.getNotificationData { statusCode, response in
//
//                Utility.hideIndicator()
//
//                if let res = response{
//                    self.notificationSettingData = res
//                    self.setNotificationData()
//                }
//
//            } failure: { (error) in
//                Utility.hideIndicator()
//                Utility.showAlert(vc: self, message: error)
//            }
//
//        }else{
//            Utility.hideIndicator()
//            Utility.showNoInternetConnectionAlertDialog(vc: self)
//        }
//    }
    
    //MARK:- update Notification Preferences
    func updateNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = NotificationRequest(daily_motion:  notificationSettingData?.daily_motion ?? true ? "1":"0", reminder_app: notificationSettingData?.reminder_app ?? true ? "1":"0", new_message: notificationSettingData?.new_message ?? true ? "1":"0" , like_post:likeSwitch.isOn ? "1" : "0", comment_post: commentsOnYourPostSwitch.isOn ? "1" : "0", shares_post: sharesOfYourPostSwitch.isOn ? "1" : "0", tagged_post: taggedYouInPostSwitch.isOn ? "1" : "0", new_member_community: newMemberSwitch.isOn ? "1" : "0", saved_post:savedYourPostLaterSwitch.isOn ? "1" : "0", marked_post: markedYourPostAsCompletedSwitch.isOn ? "1" : "0",group_like_post: notificationSettingData?.group_like_post ?? true ? "1":"0",group_comment_post: notificationSettingData?.group_comment_post ?? true ? "1":"0",group_share_post: notificationSettingData?.group_share_post ?? true ? "1":"0",group_saved_post: notificationSettingData?.group_saved_post ?? true ? "1":"0",group_completed_post: notificationSettingData?.group_completed_post ?? true ? "1":"0",group_new_member: notificationSettingData?.group_new_member ?? true ? "1":"0",group_new_post:  notificationSettingData?.group_new_post ?? true ? "1":"0",group_added_you: notificationSettingData?.group_added_you ?? true ? "1":"0")
            ProfileService.shared.updateNotificationPreferences(parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                self.navigationController?.popViewController(animated: true)
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
