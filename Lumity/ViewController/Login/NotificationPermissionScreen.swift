//
//  NotificationPermissionScreen.swift
//  Source-App
//
//  Created by Nikunj on 26/03/21.
//

import UIKit
import UserNotifications


class NotificationPermissionScreen: UIViewController {

    //MARK: - ACTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameter = NotificationRequest(daily_motion: "0", reminder_app:"0", new_message: "0", like_post: "0", comment_post: "0", shares_post: "0", tagged_post: "0", new_member_community: "0", saved_post: "0", marked_post: "0",group_like_post: "0",group_comment_post: "0",group_share_post: "0",group_saved_post: "0",group_completed_post: "0",group_new_member: "0",group_new_post: "0",group_added_you: "0")
            ProfileService.shared.updateNotificationPreferences(parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                Utility.setTabRoot()
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        Utility.setTabRoot()
                    }
                }
            }
            
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    //MARK: - ACTIONS
    @IBAction func onTurnOn(_ sender: UIButton) {
        self.registerForRemoteNotification()
    }
    

    @IBAction func onNotAllow(_ sender: UIButton) {
        //MARK:- update Notification Preferences
        updateNotification()
    }
}
