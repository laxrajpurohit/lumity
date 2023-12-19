//
//  NotificationPreferencesScreen.swift
//  Source-App
//
//  Created by iroid on 08/05/21.
//

import UIKit

class NotificationPreferencesScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var dailyMotivationalSwitch: UISwitch!
    @IBOutlet weak var appOpenSwitch: UISwitch!
    @IBOutlet weak var newMessageSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    var notificationSettingData :NotificationSettingResponse?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDataSet()
    }
    
    func initialDataSet(){
        getNotification()
        enableSaveButton(isEnable: false)
    }
    
    func setNotificationData(){
        dailyMotivationalSwitch.isOn = notificationSettingData?.daily_motion ?? true
        appOpenSwitch.isOn = notificationSettingData?.reminder_app ?? true
        newMessageSwitch.isOn = notificationSettingData?.new_message ?? true
        
    }
    
    
    func enableSaveButton(isEnable: Bool){
        self.saveButton.removeGradient(selectedGradientView: self.saveButton)
        isEnable == true ?  self.saveButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.saveButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        self.saveButton.isUserInteractionEnabled = isEnable
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        updateNotification()
    }
    
    @IBAction func ondailyMotivationalSwitch(_ sender: UISwitch) {
        notificationSettingData?.daily_motion  = dailyMotivationalSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onAppOpenSwitch(_ sender: UISwitch) {
        notificationSettingData?.tagged_post  = appOpenSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    @IBAction func onNewMessageSwitch(_ sender: UISwitch) {
        notificationSettingData?.tagged_post  = newMessageSwitch.isOn
        enableSaveButton(isEnable: true)
    }
    
    @IBAction func onInteractionWithCommunity(_ sender: UIButton) {
        let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "InteractionWithCommunityScreen") as! InteractionWithCommunityScreen
        control.notificationSettingData = notificationSettingData
        self.navigationController?.pushViewController(control, animated: true)
    }
    
    @IBAction func onInteractionWithGroup(_ sender: UIButton) {
        let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "GroupNotificationSettingScreen") as! GroupNotificationSettingScreen
        control.notificationSettingData = notificationSettingData
        self.navigationController?.pushViewController(control, animated: true)
    }
}
extension NotificationPreferencesScreen{
    //MARK:- Notification Preferences
    func getNotification(){
        if Utility.isInternetAvailable(){
            //        Utility.showIndicator()
            ProfileService.shared.getNotificationData { statusCode, response in
                
                Utility.hideIndicator()
                
                if let res = response{
                    self.notificationSettingData = res
                    self.setNotificationData()
                }
                
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK:- update Notification Preferences
    func updateNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = NotificationRequest(daily_motion: dailyMotivationalSwitch.isOn ? "1" : "0", reminder_app: appOpenSwitch.isOn ? "1" : "0", new_message:  newMessageSwitch.isOn ? "1" : "0", like_post: notificationSettingData?.like_post ?? true ? "1":"0", comment_post: notificationSettingData?.comment_post ?? true ? "1":"0", shares_post: notificationSettingData?.shares_post ?? true ? "1":"0", tagged_post: notificationSettingData?.tagged_post ?? true ? "1":"0", new_member_community: notificationSettingData?.new_member_community ?? true ? "1":"0", saved_post: notificationSettingData?.saved_post ?? true ? "1":"0", marked_post: notificationSettingData?.marked_post ?? true ? "1":"0",group_like_post: notificationSettingData?.group_like_post ?? true ? "1":"0",group_comment_post: notificationSettingData?.group_comment_post ?? true ? "1":"0",group_share_post: notificationSettingData?.group_share_post ?? true ? "1":"0",group_saved_post: notificationSettingData?.group_saved_post ?? true ? "1":"0",group_completed_post: notificationSettingData?.group_completed_post ?? true ? "1":"0",group_new_member: notificationSettingData?.group_new_member ?? true ? "1":"0",group_new_post:  notificationSettingData?.group_new_post ?? true ? "1":"0",group_added_you: notificationSettingData?.group_added_you ?? true ? "1":"0")
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
