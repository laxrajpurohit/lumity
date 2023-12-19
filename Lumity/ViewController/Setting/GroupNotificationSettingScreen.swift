//
//  GroupNotificationSetting.swift
//  Lumity
//
//  Created by iMac on 14/11/22.
//

import UIKit

class GroupNotificationSettingScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var likeSwitch: UISwitch!
    @IBOutlet weak var commentsOnYourPostSwitch: UISwitch!
    @IBOutlet weak var sharesOfYourPostSwitch: UISwitch!
    @IBOutlet weak var addedYouToGroupSwitch: UISwitch!
    @IBOutlet weak var newMemberSwitch: UISwitch!
    @IBOutlet weak var savedYourPostLaterSwitch: UISwitch!
    @IBOutlet weak var markedYourPostAsCompletedSwitch: UISwitch!
    @IBOutlet weak var newPostSwitch: UISwitch!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var notificationSettingData :NotificationSettingResponse?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    func initialDetail(){
        likeSwitch.isOn = notificationSettingData?.group_like_post ?? true
        commentsOnYourPostSwitch.isOn = notificationSettingData?.group_comment_post ?? true
        sharesOfYourPostSwitch.isOn = notificationSettingData?.group_share_post ?? true
//        taggedYouInPostSwitch.isOn = notificationSettingData?.tagged_post ?? true
        newMemberSwitch.isOn = notificationSettingData?.group_new_member ?? true
        savedYourPostLaterSwitch.isOn = notificationSettingData?.group_saved_post ?? true
        markedYourPostAsCompletedSwitch.isOn = notificationSettingData?.group_completed_post ?? true
        newPostSwitch.isOn = notificationSettingData?.group_new_post ?? true
        addedYouToGroupSwitch.isOn = notificationSettingData?.group_added_you ?? true
        enableSaveButton(isEnable: false)
        
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
        
        notificationSettingData?.group_like_post  = likeSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onCommentOnYorPostSwitch(_ sender: UISwitch) {
        notificationSettingData?.group_comment_post  = commentsOnYourPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    @IBAction func onShareOfYourPostSwitch(_ sender: UISwitch) {
        notificationSettingData?.group_share_post  = sharesOfYourPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onAddedYouToGroup(_ sender: UISwitch) {
        notificationSettingData?.group_added_you  = addedYouToGroupSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onNewMemberSwitch(_ sender: UISwitch) {
        notificationSettingData?.group_new_member  = newMemberSwitch.isOn
        enableSaveButton(isEnable: true)
    }
   
    @IBAction func onSavedYourPostForLaterSwitch(_ sender: UISwitch) {
        notificationSettingData?.group_saved_post  = savedYourPostLaterSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onMarkedYourPostAsCompletedSwitch(_ sender: UISwitch) {
        notificationSettingData?.group_completed_post  =  markedYourPostAsCompletedSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    
    @IBAction func onNewPost(_ sender: UISwitch) {
        notificationSettingData?.group_new_post  = newPostSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        self.updateNotification()
    }
}
extension GroupNotificationSettingScreen{
    //MARK: - update Notification Preferences
    func updateNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = NotificationRequest(daily_motion:  notificationSettingData?.daily_motion ?? true ? "1":"0", reminder_app: notificationSettingData?.reminder_app ?? true ? "1":"0", new_message: notificationSettingData?.new_message ?? true ? "1":"0" , like_post: notificationSettingData?.like_post ?? true ? "1" : "0", comment_post:  notificationSettingData?.comment_post ?? true ? "1" : "0", shares_post:  notificationSettingData?.shares_post ?? true ? "1" : "0", tagged_post:  notificationSettingData?.tagged_post ?? true ? "1" : "0", new_member_community: notificationSettingData?.new_member_community ?? true ? "1" : "0", saved_post: notificationSettingData?.saved_post ?? true ? "1" : "0", marked_post:  notificationSettingData?.marked_post ?? true ? "1" : "0",group_like_post: likeSwitch.isOn ? "1" : "0",group_comment_post: commentsOnYourPostSwitch.isOn ? "1" : "0",group_share_post: sharesOfYourPostSwitch.isOn ? "1" : "0",group_saved_post: savedYourPostLaterSwitch.isOn ? "1" : "0",group_completed_post:markedYourPostAsCompletedSwitch.isOn ? "1" : "0",group_new_member: newMemberSwitch.isOn ? "1" : "0",group_new_post:  newPostSwitch.isOn ? "1":"0",group_added_you: addedYouToGroupSwitch.isOn ? "1":"0")
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
