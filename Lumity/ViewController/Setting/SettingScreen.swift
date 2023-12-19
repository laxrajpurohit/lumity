//
//  SettingScreen.swift
//  Source-App
//
//  Created by iroid on 05/05/21.
//

import UIKit
import NotificationBannerSwift

class SettingScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var itemArray: [SettingRequest] = []
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDetail()
    }
    
    func setItemArray(){
        self.itemArray.append(SettingRequest(image: "ic_setting_user", title: "Your Account"))
        self.itemArray.append(SettingRequest(image: "ic_setting_notification", title: "Notification Preferences"))
//        self.itemArray.append(SettingRequest(image: "learning_icon", title: "Tutorial"))
        self.itemArray.append(SettingRequest(image: "ic_setting_block", title: "Blocked Accounts"))
        self.itemArray.append(SettingRequest(image: "ic_setting_invite", title: "Invite Friends"))
        self.itemArray.append(SettingRequest(image: "ic_setting_contact", title: "Contact Lumity"))
        self.itemArray.append(SettingRequest(image: "privacy_icon", title: "Privacy"))
        self.itemArray.append(SettingRequest(image: "ic_setting_community", title: "Community Guidelines"))
        self.itemArray.append(SettingRequest(image: "ic_setting_like_post", title: "Liked Posts"))
        self.itemArray.append(SettingRequest(image: "ic_setting_rateapp", title: "Rate our App"))
        self.itemArray.append(SettingRequest(image: "ic_setting_user", title: "Delete Account"))
        self.tableViewHeight.constant = CGFloat(70 * self.itemArray.count)

    }
    
    func initialDetail(){
        self.settingTableView.register(UINib(nibName: "SettingOptionsCell", bundle: nil), forCellReuseIdentifier: "SettingOptionsCell")
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.setItemArray()
    }
    
    func showLogOutOptions() {
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.logOutApi()
                                      }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func deleteAccountAlert() {
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete your account? All of your information and content will be deleted.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.deleteUserApi()
                                      }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func goLoginScreen(){
        Utility.removeLocalData()
        Utility.setLoginRoot()
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        self.showLogOutOptions()
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension SettingScreen: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.settingTableView.dequeueReusableCell(withIdentifier: "SettingOptionsCell", for: indexPath) as! SettingOptionsCell
        cell.item = self.itemArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "YourAccountScreen") as! YourAccountScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 1{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "NotificationPreferencesScreen") as! NotificationPreferencesScreen
            self.navigationController?.pushViewController(control, animated: true)
        }
//        else if indexPath.row == 2{
//            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
//            control.linkUrl = tutorialURL
//            self.navigationController?.pushViewController(control, animated: true)
//        }
        else if indexPath.row == 2{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "BlockScreen") as! BlockScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 3{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "InviteScreen") as! InviteScreen
          self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 4{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "ContactSourceScreen") as! ContactSourceScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 5{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "PrivacyScreen") as! PrivacyScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 6{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "SettingCommunityGuidelinesScreen") as! SettingCommunityGuidelinesScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 7{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "LikePostScreen") as! LikePostScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 8{
            if let url = URL(string: "https://apps.apple.com/us/app/source-app/id1565191495") {
                UIApplication.shared.open(url)
            }
        }else if indexPath.row == 9{
            self.deleteAccountAlert()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
//MARK: - API
extension SettingScreen {
    func logOutApi(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = LogoutRequest(deviceId: DEVICE_UNIQUE_IDETIFICATION)
            LoginService.shared.logout(parameters: data.toJSON()){ [weak self] (statusCode, response) in
                Utility.hideIndicator()
                //                if let res = response{
                SocketHelper.shared.disconnectSocket()
                self?.goLoginScreen()
                //                }
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func deleteUserApi(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            LoginService.shared.deleteUserAccount{ [weak self] (statusCode, response) in
                Utility.hideIndicator()
                //                if let res = response{
                SocketHelper.shared.disconnectSocket()
                self?.goLoginScreen()
                //                }
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
