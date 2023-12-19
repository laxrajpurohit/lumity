//
//  AppDelegate.swift
//  Lumity
//
//  Created by Nikunj on 02/09/21.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImageLinkPlugin
import GoogleSignIn
import Firebase
import Messages
import NotificationBannerSwift
import FirebaseMessaging
import FirebaseDynamicLinks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var fcmToken = ""
    var openFromDeepLink: Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
//        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
//        for family in UIFont.familyNames {
//
//            let sName: String = family as String
//            print("family: \(sName)")
//
//            for name in UIFont.fontNames(forFamilyName: sName) {
//                print("name: \(name as String)")
//            }
//        }
        
        application.registerForRemoteNotifications()
//        self.notificationClick(id: "10")
        Messaging.messaging().delegate = self
//        Utility.setViewControllerRoot()
        
        let config = GIDConfiguration(clientID: GOOGLE_CLIENT_ID)
                
        GIDSignIn.sharedInstance.configuration = config

        
        SDImageLoadersManager.shared.addLoader(SDImageLinkLoader.shared)
        SDWebImageManager.defaultImageLoader = SDImageLoadersManager.shared
        Utility.setViewControllerRoot()
        return true
    }
    
//
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        print("Web link::::\(userActivity.webpageURL)")
//        guard let urlString = userActivity.webpageURL else {
//            return false
//        }
//        let str = urlString.absoluteString
//        let newStr = str.replacingOccurrences(of: dummyText, with: "")
//        guard let newURL = URL(string: newStr) else {
//            return false
//        }
//        DynamicLinks.dynamicLinks().matchesShortLinkFormat(newURL)
//        let handled = DynamicLinks.dynamicLinks()
//            .handleUniversalLink(newURL) { dynamiclink, error in
////                var postId
//
//                if newStr.contains(PATH_POST){
//                    if let range = newStr.range(of: "POST?ID=") {
//                        let postId = newStr[range.upperBound...]
//                        print(postId) // prints "123.456.7891"
//                    }
//                }else if newStr.contains("ReSharepostId"){
//                    if let range = newStr.range(of: "?ReSharepostId=") {
//                        let postId = newStr[range.upperBound...]
//                        print(postId) // prints "123.456.7891"
//                    }
//                }
//
//                // ...
//                print(dynamiclink)
//                print("Dynamic link match type when come from appstore: \(dynamiclink?.matchType.rawValue)")
//
//                //            let lastPath = self.getYoutubeId(postUrl: dynamiclink?.url?.absoluteString ?? "")
//                //            print(lastPath)
//
//                let url = dynamiclink?.url
////                let postId = url?["postId"]  // "147"
//                if  Utility.getUserData() != nil{
//
////                    if let postId  = url?["postId"]{
//                    if newStr.contains(PATH_POST){
//                        guard let range = newStr.range(of: "POST?ID=") else {
//                            return
//                        }
//                        let postId = newStr[range.upperBound...]
//                        let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
//                        let navVC = UINavigationController(rootViewController: tabVC)
//                        let postDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
//                        postDetailVC.postId = Int(postId) ?? 0
//                        navVC.setViewControllers([tabVC,postDetailVC], animated: false)
//                        navVC.navigationBar.isHidden = true
//                        navVC.interactivePopGestureRecognizer?.isEnabled = false
//                        appDelegate.window?.rootViewController = navVC
//                        appDelegate.window?.makeKeyAndVisible()
//                        self.openFromDeepLink = true
//                        //                    }else if let reSharepostId = url?["reSharepostId"]{
//                    }else if newStr.contains("ReSharepostId"){
//                        guard let range = newStr.range(of: "?ReSharepostId=") else {
//                            return
//                        }
//                        let reSharepostId = newStr[range.upperBound...]
//
//                        let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
//                        let navVC = UINavigationController(rootViewController: tabVC)
//                        let reShareDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
//                        reShareDetailVC.postId = Int(reSharepostId) ?? 0
//                        navVC.setViewControllers([tabVC,reShareDetailVC], animated: false)
//                        navVC.navigationBar.isHidden = true
//                        navVC.interactivePopGestureRecognizer?.isEnabled = false
//                        appDelegate.window?.rootViewController = navVC
//                        appDelegate.window?.makeKeyAndVisible()
//                        self.openFromDeepLink = true
//                    }
//
//
//                }
//            }
//
//      return handled
//    }
    
   
    
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
//                     annotation: Any) -> Bool {
//      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//        // Handle the deep link. For example, show the deep-linked content or
//        // apply a promotional offer to the user's account.
//        // ...
//        return true
//      }
//      return false
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlString = url.absoluteString
        print(urlString)
        if urlString.contains("fromShareVC"){
            if let sessionData = UserDefaults(suiteName: "group.com.source.mobile.app"){
                UserDefaults.standard.removeSuite(named: "group.com.source.mobile.app")
                guard let data = sessionData.dictionary(forKey: "data") else {
                    return false
                }
                if let imageData = data["imgData"] as? Data{
                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    let navVC = UINavigationController(rootViewController: tabVC)

                    let homeVC = STORYBOARD.home.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
                    let postVC = STORYBOARD.post.instantiateViewController(withIdentifier: "BookPostScreen") as! BookPostScreen
                    postVC.shareImage = UIImage(data: imageData)
                    postVC.superVC = homeVC
                    postVC.fromShare = true
                    tabVC.hidesBottomBarWhenPushed = false
                    navVC.setViewControllers([tabVC,postVC], animated: false)
                    navVC.navigationBar.isHidden = true
                    navVC.interactivePopGestureRecognizer?.isEnabled = false
                    appDelegate.window?.rootViewController = navVC
                    appDelegate.window?.makeKeyAndVisible()
                }else if let sharedURL = data["url"] as? String{
                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    let navVC = UINavigationController(rootViewController: tabVC)

                    let homeVC = STORYBOARD.home.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
                    let postVC = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
                    if let url = URL(string: sharedURL){
                        postVC.shareURL = url
                    }
                    postVC.superVC = homeVC
                    postVC.isFromShare = true
                    tabVC.hidesBottomBarWhenPushed = false
                    navVC.setViewControllers([tabVC,postVC], animated: false)
                    navVC.navigationBar.isHidden = true
                    navVC.interactivePopGestureRecognizer?.isEnabled = false
                    appDelegate.window?.rootViewController = navVC
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectSocket()
    }
    
    
    func connectSocket(){
        if let userData = Utility.getUserData(){
            SocketHelper.shared.connectSocket(completion: { val in
                if(val){
                    print("socket connected")
                    var parameter = [String: Any]()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // your code here
                        parameter = ["senderId": userData.user_id ?? 0,"isOnline": 1] as [String:Any]
                        SocketHelper.Events.UpdateStatusToOnline.emit(params: parameter)
                    }
                }else{
                    print("socket did't connected")
                }
            })
        }else{
            print("data getting nil")
        }
    }
    func applicationWillResignActive(_ application: UIApplication){
        if Utility.getUserData() != nil{
            SocketHelper.shared.disconnectSocket()
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
            
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        let state = UIApplication.shared.applicationState
        if state == .active{
            let senderId = userInfo["senderId"] as? String
            let notificationId = userInfo["notification_id"] as? String
            if  Utility.getUserData() != nil{
                if let type = userInfo["type"] as? String{
                    if type == "8"{
                        let messagView = MessageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
                        let banner = NotificationBanner(customView: messagView)
                        banner.bannerHeight = 105 + (topSafeArea > 20 ? 25 : 0)
                        banner.applyStyling()
                        banner.show()
                        messagView.messageLabel.text = userInfo["user_message"] as? String
                        messagView.userName.text = userInfo["fullName"] as? String
                        Utility.setImage(userInfo["avatar"] as? String ?? "", imageView: messagView.userImageView)
                        banner.onTap = {
                            let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                            let navVC = UINavigationController(rootViewController: tabVC)
                            let messageListVC = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageListScreen") as! MessageListScreen
                            let messageDetailVC = STORYBOARD.message.instantiateViewController(withIdentifier: "ChatDetailScreen") as! ChatDetailScreen
                            messageDetailVC.receiverId = Int(senderId ?? "0") ?? 0
                            navVC.setViewControllers([tabVC,messageListVC,messageDetailVC], animated: false)
                            navVC.navigationBar.isHidden = true
                            navVC.interactivePopGestureRecognizer?.isEnabled = false
                            appDelegate.window?.rootViewController = navVC
                            appDelegate.window?.makeKeyAndVisible()
                        }
                        return
                    }else if type == "9" || type == "10"{
                        self.notificationClick(id: notificationId ?? "0")
                    }
                }
            }
        }
        // Change this to your preferred presentation option
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        if  Utility.getUserData() != nil{
            if let type = userInfo["type"] as? String{
                let postId = userInfo["post_id"] as? String
                let userId = userInfo["user_id"] as? String
                let senderId = userInfo["senderId"] as? String
                let groupId = userInfo["group_id"] as? String
                let groupPostId =  userInfo["group_post_id"] as? String
                let notificationId = userInfo["notification_id"] as? String
                let isReshare = userInfo["reshare"] as? String
                
                if type == "1"{
//                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
//                    let navVC = UINavigationController(rootViewController: tabVC)
//                    tabVC.userId = Int(userId ?? "0") ?? 0
//                    navVC.setViewControllers([tabVC], animated: false)
//                    navVC.navigationBar.isHidden = true
//                    navVC.interactivePopGestureRecognizer?.isEnabled = false
//                    appDelegate.window?.rootViewController = navVC
//                    tabVC.selectedIndex = 3
//                    appDelegate.window?.makeKeyAndVisible()
                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    let navVC = UINavigationController(rootViewController: tabVC)
                    let profileListVC = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
                    profileListVC.userId = Int(userId ?? "0") ?? 0
                    navVC.setViewControllers([tabVC,profileListVC], animated: false)
                    navVC.navigationBar.isHidden = true
                    navVC.interactivePopGestureRecognizer?.isEnabled = false
                    appDelegate.window?.rootViewController = navVC
                    appDelegate.window?.makeKeyAndVisible()
                    
                  }else if type == "2" || type == "3" || type == "6" || type == "7"{
                    if isReshare == "true"{
//                    if (isReshare != nil){
                        let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                        let navVC = UINavigationController(rootViewController: tabVC)
                        let reShareDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                        reShareDetailVC.postId = Int(postId ?? "0") ?? 0
                        navVC.setViewControllers([tabVC,reShareDetailVC], animated: false)
                        navVC.navigationBar.isHidden = true
                        navVC.interactivePopGestureRecognizer?.isEnabled = false
                        appDelegate.window?.rootViewController = navVC
                        appDelegate.window?.makeKeyAndVisible()
                    }else{
                        let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                        let navVC = UINavigationController(rootViewController: tabVC)
                        let postDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                        postDetailVC.postId = Int(postId ?? "0") ?? 0
                        navVC.setViewControllers([tabVC,postDetailVC], animated: false)
                        navVC.navigationBar.isHidden = true
                        navVC.interactivePopGestureRecognizer?.isEnabled = false
                        appDelegate.window?.rootViewController = navVC
                        appDelegate.window?.makeKeyAndVisible()
                    }
                  
                  }else if type == "4"{
                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    let navVC = UINavigationController(rootViewController: tabVC)
                    let reShareDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                    reShareDetailVC.postId = Int(postId ?? "0") ?? 0
                    navVC.setViewControllers([tabVC,reShareDetailVC], animated: false)
                    navVC.navigationBar.isHidden = true
                    navVC.interactivePopGestureRecognizer?.isEnabled = false
                    appDelegate.window?.rootViewController = navVC
                    appDelegate.window?.makeKeyAndVisible()
                  }else if type == "8"{
                    let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                    let navVC = UINavigationController(rootViewController: tabVC)
                    let messageListVC = STORYBOARD.message.instantiateViewController(withIdentifier: "MessageListScreen") as! MessageListScreen
                    let messageDetailVC = STORYBOARD.message.instantiateViewController(withIdentifier: "ChatDetailScreen") as! ChatDetailScreen
                    messageDetailVC.receiverId = Int(senderId ?? "0") ?? 0
                    navVC.setViewControllers([tabVC,messageListVC,messageDetailVC], animated: false)
                    navVC.navigationBar.isHidden = true
                    navVC.interactivePopGestureRecognizer?.isEnabled = false
                    appDelegate.window?.rootViewController = navVC
                    appDelegate.window?.makeKeyAndVisible()
                  }else if type == "9" || type == "10"{
                    self.notificationClick(id: notificationId ?? "0")
                  }else if type == "11"{
                      let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                      let navVC = UINavigationController(rootViewController: tabVC)
                      let groupListVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupListScreen") as! GroupListScreen
                      let groupDetailVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupDetailScreen") as! GroupDetailScreen
                      groupDetailVC.groupListVC = groupListVC
                      groupDetailVC.groupId = Int(groupId ?? "0") ?? 0
                      navVC.setViewControllers([tabVC,groupListVC,groupDetailVC], animated: false)
                      navVC.navigationBar.isHidden = true
                      navVC.interactivePopGestureRecognizer?.isEnabled = false
                      appDelegate.window?.rootViewController = navVC
                      appDelegate.window?.makeKeyAndVisible()
                  }else if type == "12" || type == "14"{
                      if isReshare == "true"{
                          let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                          let navVC = UINavigationController(rootViewController: tabVC)
                          let groupListVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupListScreen") as! GroupListScreen
                          let groupDetailVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupDetailScreen") as! GroupDetailScreen
                          let reSharePostDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                          groupDetailVC.groupListVC = groupListVC
                          groupDetailVC.groupId = Int(groupId ?? "0") ?? 0
                          reSharePostDetailVC.groupPostId = Int(groupPostId ?? "0") ?? 0
                          navVC.setViewControllers([tabVC,groupListVC,groupDetailVC,reSharePostDetailVC], animated: false)
                          navVC.navigationBar.isHidden = true
                          navVC.interactivePopGestureRecognizer?.isEnabled = false
                          appDelegate.window?.rootViewController = navVC
                          appDelegate.window?.makeKeyAndVisible()
                      }else{
                          let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                          let navVC = UINavigationController(rootViewController: tabVC)
                          let  groupListVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupListScreen") as! GroupListScreen
                          let groupDetailVC = STORYBOARD.group.instantiateViewController(withIdentifier: "GroupDetailScreen") as! GroupDetailScreen
                          groupDetailVC.groupListVC = groupListVC
                          let postDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                          groupDetailVC.groupId = Int(groupId ?? "0") ?? 0
                          postDetailVC.groupPostId = Int(groupPostId ?? "0") ?? 0
                          navVC.setViewControllers([tabVC,groupListVC,groupDetailVC,postDetailVC], animated: false)
                          navVC.navigationBar.isHidden = true
                          navVC.interactivePopGestureRecognizer?.isEnabled = false
                          appDelegate.window?.rootViewController = navVC
                          appDelegate.window?.makeKeyAndVisible()
                      }
                     
                  }
            }
        }
        completionHandler()
    }
    
//
    
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        Messaging.messaging().apnsToken = deviceToken as Data
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults().set(token, forKey: "DEVICE_TOKEN")
        if Utility.getUserData() != nil{
            self.registerForPush()
        }
    }
}
extension AppDelegate : MessagingDelegate{
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        self.fcmToken = fcmToken ?? ""
        //        let dataDict:[String: String] = ["token": fcmToken]
        //        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
//MARK:- API METHOD
extension AppDelegate {
    func registerForPush(){
        if Utility.isInternetAvailable(){
            var fcmToken = ""
            if let token = Messaging.messaging().fcmToken {
                print("FCM token: \(token)")
                fcmToken = token
            }
            let data = RegisterForPushRequest(device_id: DEVICE_UNIQUE_IDETIFICATION, device_type: "ios", device_token: fcmToken)
            print(data.toJSON())
            LoginService.shared.registerForPush(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                if let res = response{
                    print(res.toJSON())
                }
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
//                Utility.hideIndicator()
                //                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
//            Utility.hideIndicator()
        }
    }
    
    func notificationClick(id:String){
        if Utility.isInternetAvailable(){
        NotificationService.shared.notificationClick(notificationId: id) { status, Response in
            print("success")
        } failure: { error in
            print(error)
        }
        }else{
            print("Internet not working")
        }

    }
}

//extension URL {
//    subscript(queryParam:String) -> String? {
//        guard let url = URLComponents(string: self.absoluteString) else { return nil }
//        return url.queryItems?.first(where: { $0.name == queryParam })?.value
//    }
//}
//MARK: - For Dynamic Link
extension AppDelegate {
    
    // Handle links received as Universal Links when the app is already installed
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL, let host = url.host else { return false }
        print("Dynamic link host: \(host)")
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
            
            guard error == nil, let dynamicLink = dynamiclink, let urlString = dynamicLink.url?.absoluteString else { return }
            
//            if isAppInTestMode {
                print("Dyanmic link url: \(urlString)")
                print("Dynamic link match type: \(dynamicLink.matchType.rawValue)")
//            }
            
            self.handleDynamicLink(dynamiclink!)
        }

      return handled
    }
    
    // This method is called when your app is opened for the first time after installation. with above method (application:openURL:options:)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            
            guard let urlString = dynamicLink.url?.absoluteString  else { return false }
            
//            if isAppInTestMode {
                print("Dyanmic link url: \(urlString)")
                print("Dynamic link match type when come from appstore: \(dynamicLink.matchType.rawValue)")
//            }
            
            self.handleDynamicLink(dynamicLink)
            return true
        }
        
        return false
    }
    
    // Handle incoming dynamic link
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        
        guard let url = dynamicLink.url else { return }
        
//        if isAppInTestMode {
//            print("Your incoming link parameter is \(url.absoluteString)")
//        }
        
        // 1
        guard dynamicLink.matchType == .unique || dynamicLink.matchType == .default else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
        
        
        if components.path == PATH_POST {
            
            /*
             if let shareTypeQueryItem = queryItems.first(where: {$0.name == SHARE_TYPE}) {
             guard let shareType = shareTypeQueryItem.value else {return}
             print("shareType \(shareType)")
             shareDeepLinkData["is_type"] = Int(shareType)
             
             }
             */
            if let shareTypeQueryItem = queryItems.first(where: {$0.name == POST_ID}) {
                guard let postId = shareTypeQueryItem.value else {return}
                print("postId \(postId)")
                
                let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                let navVC = UINavigationController(rootViewController: tabVC)
                let postDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "PostDetailScreen") as! PostDetailScreen
                postDetailVC.postId = Int(postId) ?? 0
                navVC.setViewControllers([tabVC,postDetailVC], animated: false)
                navVC.navigationBar.isHidden = true
                navVC.interactivePopGestureRecognizer?.isEnabled = false
                appDelegate.window?.rootViewController = navVC
                appDelegate.window?.makeKeyAndVisible()
                self.openFromDeepLink = true
                
            }
            if let shareTypeQueryItem = queryItems.first(where: {$0.name == POST_RESHARE_ID}) {
                guard let userId = shareTypeQueryItem.value else {return}
                print("userId \(userId)")
                //                shareDeepLinkData["user_id"] = Int(userId)
                
                let tabVC = STORYBOARD.tabbar.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
                let navVC = UINavigationController(rootViewController: tabVC)
                let reShareDetailVC = STORYBOARD.home.instantiateViewController(withIdentifier: "ReSharePostDetailScreen") as! ReSharePostDetailScreen
                reShareDetailVC.postId = Int(userId) ?? 0
                navVC.setViewControllers([tabVC,reShareDetailVC], animated: false)
                navVC.navigationBar.isHidden = true
                navVC.interactivePopGestureRecognizer?.isEnabled = false
                appDelegate.window?.rootViewController = navVC
                appDelegate.window?.makeKeyAndVisible()
                self.openFromDeepLink = true
            }
        }
    }
    
}
