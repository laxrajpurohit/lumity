//
//  UtilityClass.swift
//  Medics2you
//
//  Created by Techwin iMac-2 on 05/03/20.
//  Copyright © 2020 Techwin iMac-2. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Contacts
import SystemConfiguration

class UtilityClass: NSObject {
    static let manager = UtilityClass()
    var userId = ""
    var sessionKey = ""
    var count = 0
    
    func setUserId(userId:String){
        self.userId = userId
    }
    
    func getUserId()->String{
        return self.userId
    }
    
    func setSessionKey(sessionKey:String){
        self.sessionKey = sessionKey
    }
    
    func getSessionKey()->String{
        return self.sessionKey
    }
    
    
    //*******Validation methods**********//
    
    func isValidPassword(testStr:String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: testStr)
    }
    func timeZone() -> String {
        return String (TimeZone.current.identifier)
    }
    // MARK : - CHECK NETWORK CONNECTION
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    

    func alertmsg(_ message: String) {
           let alertView = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
           alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
       }

   
   
}

/// https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout
