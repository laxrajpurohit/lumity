//
//  GoogleLoginManager.swift
//  motivate
//
//  Created by iroid on 08/05/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol googleLoginManagerDelegate {
    func onGoogleLoginSuccess(user: GIDGoogleUser)
    func onGoogleLoginFailure(error:NSError)
}
class GoogleLoginManager:NSObject{
    static var sharedInstace : GoogleLoginManager?
    var delegate: googleLoginManagerDelegate?
    
    func handleGoogleLoginButtonTap(viewController:UIViewController){
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                self.delegate?.onGoogleLoginFailure(error: error! as NSError)
                return
            }
            guard let user = result?.user else { return }
            self.delegate?.onGoogleLoginSuccess(user: user)
        }
    }
}
//extension GoogleLoginManager : GIDSignInDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//                print(error.localizedDescription)
//                self.delegate?.onGoogleLoginFailure(error: error as NSError)
//            } else {
//                print(error.localizedDescription)
//                self.delegate?.onGoogleLoginFailure(error: error as NSError)
//            }
//            return
//        }
//        
//        self.delegate?.onGoogleLoginSuccess(user: user)
//    }
//}
