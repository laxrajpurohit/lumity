//
//  ViewController.swift
//  Source-App
//
//  Created by Nikunj on 24/03/21.
//

import UIKit

class ViewController: UIViewController {
    var timer = Timer()
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.initializedDetails), userInfo: nil, repeats: false)
        appVerion()
        // Do any additional setup after loading the view.
    }
    
    @objc func applicationDidBecomeActive() {
        // handle event
        appVerion()
    }
    
    @objc func initializedDetails(){
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityGuidelinesScreen") as! CommunityGuidelinesScreen
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityScreen") as! CommunityScreen
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "LocationPermissionScreen") as! LocationPermissionScreen
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "NotificationPermissionScreen") as! NotificationPermissionScreen
//        self.navigationController?.pushViewController(control, animated: true)
//        return
//        LocationPermissionScreen
        
//        let control = STORYBOARD.bookList.instantiateViewController(withIdentifier: "BookListScreen") as! BookListScreen
////        control.superVC = self
//        self.navigationController?.pushViewController(control, animated: true)
//        return
        print(Utility.getUserData()?.toJSON())
        if Utility.getUserData() == nil{
            let control = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if Utility.getUserData()?.interest_type == 0{
            let control = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else{
            if !appDelegate.openFromDeepLink{
                Utility.setTabRoot()
            }
        }
        
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "OTPScreen") as! OTPScreen
//        self.navigationController?.pushViewController(control, animated: true)
        
//        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "CompleteProfileRequiredScreen") as! CompleteProfileRequiredScreen
//        self.navigationController?.pushViewController(control, animated: true)
//        LocationPermissionScreen
       }
    
    func forceAppUpdateVersionAlert(message:String){
        let alert = UIAlertController(title: "Update Available", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Update",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        let myUrl = "https://apps.apple.com/us/app/lumity-app/id1565191495"
                                        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                        
                                        // or outside scope use this
                                        guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
                                            return
                                        }
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                      }))
        self.present(alert, animated: true, completion: nil)
    }

    func appVerion(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            //Utility.showIndicator()
            let data = AppVersionRequest(version: appVersion)
            LoginService.shared.appVerion(parameters: data.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                print(response.toJSON())
                if let data = response.appVersionResponse{
                    if data.is_update ?? false{
                        self.forceAppUpdateVersionAlert(message: data.message ?? "")
                    }else{
                        self.timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.initializedDetails), userInfo: nil, repeats: false)
                    }
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
}

