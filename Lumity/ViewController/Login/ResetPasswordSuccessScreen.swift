//
//  ResetPasswordSuccessScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit

class ResetPasswordSuccessScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - ACTIONS
    @IBAction func onLogin(_ sender: Any) {
//        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
        
        for controller in self.navigationController!.viewControllers as Array {
              if controller is LoginEmailScreen {
                  self.navigationController!.popToViewController(controller, animated: false)
                  break
              }else if controller is  YourAccountScreen{
                self.navigationController!.popToViewController(controller, animated: false)
                break
              }else if controller is LoginPhoneScreen{
                self.navigationController!.popToViewController(controller, animated: false)
                break
              }
          }
    }
    
}
