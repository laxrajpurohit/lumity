//
//  Utility.swift
//  Iroid
//
//  Created by iroid on 30/03/18.
//  Copyright © 2018 iroidiroid. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import CoreLocation
import MBProgressHUD
import NVActivityIndicatorView
import LinkPresentation
import SDWebImageLinkPlugin
import NotificationBannerSwift

class Utility: NSObject {
    
    class func showAlert(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: APPLICATION_NAME, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showActionAlert(vc: UIViewController,message: String)
    {
        
        let alertController = UIAlertController(title: APPLICATION_NAME, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        vc.present(alertController, animated: true, completion: nil)
    }
    // MARK:- user defaults fxns
    class func setUDVal( val : Any , forKey : String) {
        UserDefaults.standard.set(val, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    class func showNoInternetConnectionAlertDialog(vc: UIViewController) {
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "It seems you are not connected to the internet. Kindly connect and try again", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertSomethingWentWrong(vc: UIViewController) {
        let alertController = UIAlertController(title: APPLICATION_NAME, message: "Oops! Something went wrong. Kindly try again later", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
  
    class func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    class func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
  
    class func checkForEmptyString(valueString: String) -> Bool {
        if valueString.isEmpty {
            return true
        }else{
            return false
        }
    }
    
    class func removeUserData(){
        UserDefaults.standard.removeObject(forKey: USER_DATA)
//        UserDefaults.standard.removeObject(forKey: USER_PROFILE)
    }
    
    class func saveUserData(data: [String: Any]){
        UserDefaults.standard.setValue(data, forKey: USER_DATA)
    }
    
    class func getUserData() -> LoginResponse?{
        if let data = UserDefaults.standard.value(forKey: USER_DATA) as? [String: Any]{
            let dic = LoginResponse(JSON: data)
            return dic
        }
        return nil
    }
    
    class func getAccessToken() -> String?{
        if let token = getUserData()?.auth?.accessToken{
            return token
        }
        return nil
    }
    
    class func setTabRoot(){
   
        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
        let navVC = UINavigationController(rootViewController: control)
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
        appDelegate.window?.rootViewController = navVC
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    class func setViewControllerRoot(){
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = main.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navVC = UINavigationController(rootViewController: vc)
        navVC.interactivePopGestureRecognizer?.isEnabled = false
        appDelegate.window?.rootViewController = navVC
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    class func getCurrentUserId() -> Int {
        if let data = UserDefaults.standard.value(forKey: USER_DATA) as? [String: Any]{
            let dic = LoginResponse(JSON: data)
            return dic?.user_id ?? 0
        }
        return  0
    }
    
    //    class func getCurrentUserProfilePicture() -> String {
    //        let userDictionary = (UserDefaults.standard.object(forKey: USER_DETAILS) as? NSMutableDictionary)!
    //        return userDictionary.object(forKey: PROFILE_PIC) as! String
    //    }
    
    class func showIndicator() {
        //         AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = false
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        SwiftLoader.show(title: "Loading...", animated: true)
//        MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 100, height: 100)).show(animated: true)
//        MBProgressHUD().show(animated: true)
//        let hud = MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
////        hud.mode = MBProgressHUD.areAnimationsEnabled
//        hud.contentColor = .black
//        MBBackgroundView.UI
//        hud.show(animated: true)
//        hud?.label.text = "Loading"
//        doSomethingInBackground(withProgressCallback: { progress in
//            hud?.progress = progress
//        }, completionCallback: {
//            hud?.hide(animated: true)
//        })
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)

        hud.bezelView.color = UIColor.black // Your backgroundcolor

        hud.bezelView.style = .solidColor // you should change the bezelview style to solid color.
        hud.contentColor = .white

    }
    
    class func hideIndicator() {
        //        AppDelegate().sharedDelegate().window?.isUserInteractionEnabled = true
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        SwiftLoader.hide()
        MBProgressHUD.hide(for: appDelegate.window!, animated: true)
    }
    
    
 class func logoutUserFromApp() {
      
     
      let defaults = UserDefaults.standard
      let dictionary = defaults.dictionaryRepresentation()
      dictionary.keys.forEach { key in
          defaults.removeObject(forKey: key)
      }
//    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//    if #available(iOS 13.0, *) {
//        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        let initialViewController = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginScreen") as! LoginScreen
//        let navi = UINavigationController.init(rootViewController: initialViewController)
//        navi.isNavigationBarHidden = true
//        appDelegate.window?.rootViewController = navi
//        appDelegate.window?.makeKeyAndVisible()
//        
//    } else {
//        // Fallback on earlier versions
//    }
      
  }
    
    class func setLoginRoot(){
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginOptionScreen") as! LoginOptionScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.interactivePopGestureRecognizer?.isEnabled = false
        appDelegate.window?.rootViewController = navVC
        appDelegate.window?.makeKeyAndVisible()
    }
  func resetDefaults() {
         let defaults = UserDefaults.standard
         let dictionary = defaults.dictionaryRepresentation()
         dictionary.keys.forEach { key in
             defaults.removeObject(forKey: key)
         }
     }
    //MARK: reachability
    class func isInternetAvailable() -> Bool
    {
        var  isAvailable : Bool
        isAvailable = true
        let reachability = Reachability()!
        if(reachability.connection == .none)
        {
            isAvailable = false
        }
        else
        {
            isAvailable = true
        }
        
        return isAvailable
        
    }
    
    func AddSubViewtoParentView(parentview: UIView! , subview: UIView!)
    {
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
        
    }
    class func removeNullsFromDictionary(origin:[String:AnyObject]) -> NSMutableDictionary{
        var destination:NSMutableDictionary = [:]
        for key in origin.keys {
            if origin[key] != nil && !(origin[key] is NSNull)
            {
                if origin[key] is [String:AnyObject]
                {
                    destination[key] = self.removeNullsFromDictionary(origin: origin[key] as! [String:AnyObject]) as AnyObject
                } else if origin[key] is [AnyObject]
                {
                    let orgArray = origin[key] as! [AnyObject]
                    var destArray: [AnyObject] = []
                    for item in orgArray {
                        if item is [String:AnyObject]
                        {
                            destArray.append(self.removeNullsFromDictionary(origin: item as! [String:AnyObject]) as AnyObject)
                        } else
                        {
                            destArray.append(item)
                        }
                    }
                    destination[key] = destArray as AnyObject
                }
                else {
                    destination[key] = origin[key]
                    if key == "description" {
                        destination[key] = "" as AnyObject
                    }
                }
            } else {
                
                destination[key] = "" as AnyObject
            }
        }
        return destination
    }
    class func openWhatsapp(Number:String){
            var fullMob = Number
            fullMob = fullMob.replacingOccurrences(of: " ", with: "")
            fullMob = fullMob.replacingOccurrences(of: "+", with: "")
            fullMob = fullMob.replacingOccurrences(of: "-", with: "")
            let urlWhats = "whatsapp://send?phone=\(fullMob)"
            
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = NSURL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        })
                    } else {
    //                    AppTool.showAlertView(vc: self, titleString: "Error", messageString: "WhatsApp Not Found on your device")
                        // Handle a problem
                    }
                }
            }
        }
    class func getCountryPhoneCode (_ country : String) -> String
    {
        let countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
//                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
//                                  "AI":"1",
//                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
//                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
//                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
//                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
//                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
//                                  "DM":"1",
//                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
//                                  "GD":"1",
                                  "GP":"590",
//                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
//                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
//                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
//                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
//                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
//                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
//                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
//                                  "KN":"1",
//                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
//                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
//        if countryDictionary[country] != nil {
//            return countryDictionary[country]!
            for (kind, numbers) in countryDictionary {
                if numbers == country{
                    return kind
                }
            }
//        }
            
//        else {
//            return ""
//        }
        return ""
    }
    
    
    
    
    class func decorateTags(_ stringWithTags: String?) -> NSMutableAttributedString? {
        var error: Error? = nil
        //For "Vijay #Apple Dev"
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: "#(\\w+)", options: [])
        } catch {
        }
        //For "Vijay @Apple Dev"
        //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
        let matches = regex?.matches(in: stringWithTags ?? "", options: [], range: NSRange(location: 0, length: stringWithTags?.count ?? 0))
        var attString = NSMutableAttributedString(string: stringWithTags ?? "")
        
        let stringLength = stringWithTags?.count ?? 0
        for match in matches! {
            let wordRange = match.range(at: 0)
            let word = (stringWithTags as NSString?)?.substring(with: wordRange)
        
            let foregroundColor = Utility.getUIcolorfromHex(hex: "5527BD")
            attString.addAttribute(.foregroundColor, value: foregroundColor, range: wordRange)
            
            print("Found tag \(word ?? "")")
        }
        return attString
    }
    
    class func getUIcolorfromHex(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    
  
    
    //    class func getCompressImageData(_ originalImage: UIImage?) -> Data?
    //    {
    //        let imageData = originalImage?.lowestQualityJPEGNSData
    //        print(imageData)
    //        return imageData as! Data
    //    }
    class func getCompressImageData(_ originalImage: UIImage?) -> Data? {
        // UIImage *largeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        let largeImage: UIImage? = originalImage
        
        var compressionRatio: Double = 1
        var resizeAttempts: Int = 3
//        var imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
        var imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        print(String(format: "Starting Size: %lu", UInt(imgData?.count ?? 0)))
        
        if (imgData?.count)! > 1000000 {
            resizeAttempts = 4
        } else if (imgData?.count)! > 400000 && (imgData?.count)! <= 1000000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 100000 && (imgData?.count)! <= 400000 {
            resizeAttempts = 2
        } else if (imgData?.count)! > 40000 && (imgData?.count)! <= 100000 {
            resizeAttempts = 1
        } else if (imgData?.count)! > 10000 && (imgData?.count)! <= 40000 {
            resizeAttempts = 1
        }
        
        print("resizeAttempts \(resizeAttempts)")
        
        while resizeAttempts > 0 {
            resizeAttempts -= 1
            print("Image was bigger than 400000 Bytes. Resizing.")
            print(String(format: "%i Attempts Remaining", resizeAttempts))
            compressionRatio = compressionRatio * 0.6
            print("compressionRatio \(compressionRatio)")
            print(String(format: "Current Size: %lu", UInt(imgData?.count ?? 0)))
//            imgData = UIImageJPEGRepresentation(largeImage!, CGFloat(compressionRatio))
            imgData = largeImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
            print(String(format: "New Size: %lu", UInt(imgData?.count ?? 0)))
        }
        
        //Set image by comprssed version
        let savedImage = UIImage(data: imgData!)
        
        //Check how big the image is now its been compressed and put into the UIImageView
        // *** I made Change here, you were again storing it with Highest Resolution ***
        
//        var endData = UIImageJPEGRepresentation(savedImage!, CGFloat(compressionRatio))
        var endData = savedImage!.jpegData(compressionQuality: CGFloat(compressionRatio))
        //NSData *endData = UIImagePNGRepresentation(savedImage);
        
        print(String(format: "Ending Size: %lu", UInt(endData?.count ?? 0)))
        
        return endData
    }
    class func getTime(date:String) -> String{
           let currentDate = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           formatter.timeZone = TimeZone(abbreviation: "UTC")
           let postDate = formatter.date(from: date)!
            let timeFromNow = currentDate.offset(from: postDate)
           return timeFromNow
       }
    class func setImage(_ imageUrl: String!, imageView: UIImageView!) {
        if imageUrl != nil && !(imageUrl == "") {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            imageView.sd_setShowActivityIndicatorView(true)
//            imageView.sd_setIndicatorStyle(.gray)
            imageView!.sd_setImage(with: URL(string: imageUrl! ), placeholderImage: UIImage(named: "placeholder"))
        }
        else
        {
//            placeholder
//            placeholder_image
            imageView?.image = UIImage(named: "placeholder")
        }
    }

//    class func getMilSecondDateString(milisecond:Int,dateFormate:String)->String{
//        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat =  dateFormate
//        print(dateFormatter.string(from: dateVar))
//        return dateFormatter.string(from: dateVar)
//    }
    
    //MARK:- Convert Emoji String to Image..
      
      class func image() -> UIImage? {
          let size = CGSize(width: 40, height: 40)
          UIGraphicsBeginImageContextWithOptions(size, false, 0)
          UIColor.white.set()
          let rect = CGRect(origin: .zero, size: size)
          UIRectFill(CGRect(origin: .zero, size: size))
          (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image
      }
    
    class func silentModeSoundOn(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
        }
    }
    class func setMonth(strMonth: String) -> String
    {
        let strMonth=strMonth.lowercased();
        var strSpanishMonth = "" ;
        if strMonth == ("january") || strMonth == "enero" {
            strSpanishMonth="Enero"
        }
        else if strMonth == "february" || strMonth == "febrero" {
            strSpanishMonth="Febrero"
        }
        else if strMonth == "march" || strMonth == "marzo" {
            strSpanishMonth="Marzo"
        }
        else if strMonth == "april" || strMonth == "abril" {
            strSpanishMonth="Abril"
        }
        else if strMonth == "may" || strMonth == "mayo" {
            strSpanishMonth="Mayo"
        }
        else if strMonth == "june" || strMonth == "junio" {
            strSpanishMonth="Junio"
        }
        else if strMonth == "july" || strMonth == "julio" {
            strSpanishMonth="Junio"
        }
        else if strMonth == "august" || strMonth == "agosto" {
            strSpanishMonth="Agosto"
        }
        else if strMonth == "september" || strMonth == "septiembre" {
            strSpanishMonth="Septiembre"
        }
        else if strMonth == "october" || strMonth == "octubre" {
            strSpanishMonth="Octubre"
        }
        else if strMonth == "november" || strMonth == "noviembre" {
            strSpanishMonth="Noviembre"
        }
        else {
            strSpanishMonth = "Diciembre";
        }
        return strSpanishMonth;
    }
    
    class func setDay(strDay: String) -> String
    {
        let strDay=strDay.lowercased();
        var strEnglishDay = "" ;
        if strDay == "monday" {
            strEnglishDay="Monday"
        }
        else if strDay == "tuesday" {
            strEnglishDay="Tuesday"
        }
        else if strDay == "wednesday" {
            strEnglishDay="Wednesday"
        }
        else if strDay == "thursday" {
            strEnglishDay="Thursday"
        }
        else if strDay == "friday" {
            strEnglishDay="Friday"
        }
        else if strDay == "saturday" {
            strEnglishDay="Saturday"
        }
        else {
            strEnglishDay="Sunday"
        }
        return strEnglishDay;
    }
    
//    class func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = SERVER_DATE_FORMATE
//        inputFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//
//        if let date = inputFormatter.date(from: dateString) {
//            let outputFormatter = DateFormatter()
//            outputFormatter.dateFormat = format
//            outputFormatter.timeZone = NSTimeZone.local
//
//            return outputFormatter.string(from: date)
//        }
//        return nil
//    }
    
    class func addSuperScriptToLabel(label: UILabel, superScriptCount count: Int, fontSize size: CGFloat) {
        let font:UIFont? = UIFont(name: label.font!.fontName, size:size)
        let fontSuper:UIFont? = UIFont(name: label.font!.fontName, size:size/1.5)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: label.text!, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:((label.text?.count)!-count),length:count))
        label.attributedText = attString
    }
    
    //    class func getNumberOfItemInCart() -> String? {
    //
    //        if(UserDefaults.standard.object(forKey: CART_PRODUCTS) != nil ){
    //            let cartArray = UserDefaults.standard.object(forKey: CART_PRODUCTS) as! NSArray
    //           return String(cartArray.count)
    //
    //        }
    //        return "0"
    //    }
    //
    
    
    class func localToUTCNew(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        if(dt == nil){
            return ""
        }
        return dateFormatter.string(from: dt!)
    }
    
    class func getCurrentLocalTime(format: String) -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: now)
    }
    
    class func makeBlueBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 0, green: 0.6509803922, blue: 1, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width , height: 1)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    class func makeGrayBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: 1)
        border.borderWidth = textField.frame.size.width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    class func makeClearBorderToTextField(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: 1)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    
    class func convertIntoJSONString(arrayObject: [Any]) -> String? {

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    class func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        if(dt == nil){
                   return ""
               }
        return dateFormatter.string(from: dt!)
    }
//
    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = fromFormat
           dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?

           let dt = dateFormatter.date(from: date)
           dateFormatter.timeZone = NSTimeZone.local
           dateFormatter.dateFormat = toFormat
           dateFormatter.amSymbol = "AM"
           dateFormatter.pmSymbol = "PM"
        if(dt == nil){
            return ""
        }
           return dateFormatter.string(from: dt!)
       }
  
    
    class func UTCToLocaltimeInterval(date:Int, fromFormat: String, toFormat: String) -> String {
        
        
        
        let date1 = Utility.getDateTimeFromTimeInterVel(from: date)
        
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = YYYY_MM_DDHHMMSS
        let date = dateFormatter.string(from: date1)

        if let convertedDate = dateFormatter.date(from: date){
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = toFormat
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
           
            let finaleDate = dateFormatter.string(from: convertedDate)
            return finaleDate
        }
        
        
//        let date1 = Date(timeIntervalSince1970: TimeInterval(date))
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = TimeZone.current
//        let lax = utcToLocal(dateStr: date1)
//        print(lax)
         dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        if(date1 == nil){
            return ""
        }
        return dateFormatter.string(from: date1)
       }
  

    class func utcToLocal(dateStr: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = YYY_MM_DD_HH_MM_SS_Z
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
//        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = YYY_MM_DD_HH_MM_SS_Z
        
            return dateFormatter.string(from: dateStr)
//        }
        return nil
    }
    class func getSameDate(as itemString: String?, havingDateFormatter dateFormatter: DateFormatter?) -> Date? {
        let twentyFour = NSLocale(localeIdentifier: "en_GB")
        dateFormatter?.locale = twentyFour as Locale
        let dateString = getGlobalTimeAsDate(fromDate: itemString, andWithFormat: dateFormatter)
        return dateString
    }
    class func getGlobalTimeAsDate(fromDate date: String?, andWithFormat dateFormatter: DateFormatter?) -> Date? {
        dateFormatter?.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return dateFormatter?.date(from: date ?? "")
    }
    class func videoSnapshot(url: NSString) -> UIImage? {
        
        //let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let vidURL = NSURL(string: url as String)
        let asset = AVURLAsset(url: vidURL! as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    class func getEncodeString(strig: String) -> String {
        let utf8str = strig.data(using: String.Encoding.utf8)
        let base64Encoded = utf8str?.base64EncodedData()
        
        let base64Decoded = NSString(data: base64Encoded!, encoding: String.Encoding.utf8.rawValue)
        
        return base64Decoded! as String
    }
    
    class func getDecodedString(encodedString: String) -> String {
        if(Data(base64Encoded: encodedString) != nil)
        {
            let decodedData = Data(base64Encoded: encodedString)!
            let decodedString = String(data:decodedData, encoding: .utf8)!
            
            return decodedString
        }
        return encodedString
    }
    
    class func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "($1)$2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    class func isValidZipCode(zipCode:String) -> Bool
    {
        //        let zipCodeRegExArray = ["^\\d{5}([\\-]?\\d{4})?$","^(GIR|[A-Z]\\d[A-Z\\d]??|[A-Z]{2}\\d[A-Z\\d]??)[ ]??(\\d[A-Z]{2})$","\\b((?:0[1-46-9]\\d{3})|(?:[1-357-9]\\d{4})|(?:[4][0-24-9]\\d{3})|(?:[6][013-9]\\d{3}))\\b","^([ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJKLMNPRSTVWXYZ])\\{0,1}(\\d[ABCEGHJKLMNPRSTVWXYZ]\\d)$","^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$","^(V-|I-)?[0-9]{5}$","^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$","^[1-9][0-9]{3}\\s?([a-zA-Z]{2})?$","^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$","^([D|d][K|k]( |-))?[1-9]{1}[0-9]{3}$","^(s-|S-){0,1}[0-9]{3}\\s?[0-9]{2}$","^[1-9]{1}[0-9]{3}$","^\\d{6}$","^2899$"]
        let zipCodeRegExArray = ["^GIR[ ]?0AA|((AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}))|BFPO[ ]?\\d{1,4}$","^JE\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^GY\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^IM\\d[\\dA-Z]?[ ]?\\d[ABD-HJLN-UW-Z]{2}$","^\\d{5}([ \\-]\\d{4})?$","^[ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ ]?\\d[ABCEGHJ-NPRSTV-Z]\\d$","^\\d{5}$","^\\d{3}-\\d{4}$","^\\d{2}[ ]?\\d{3}$","^\\d{4}$","^\\d{5}$","^\\d{4}$","^\\d{4}[ ]?[A-Z]{2}$","^\\d{3}[ ]?\\d{2}$","^\\d{5}[\\-]?\\d{3}$","^\\d{4}([\\-]\\d{3})?$","^22\\d{3}$","^\\d{3}[\\-]\\d{3}$","^\\d{6}$","^\\d{3}(\\d{2})?$","^\\d{7}$","^\\d{4,5}|\\d{3}-\\d{4}$","^\\d{3}[ ]?\\d{2}$","^([A-Z]\\d{4}[A-Z]|(?:[A-Z]{2})?\\d{6})?$","^\\d{3}$","^\\d{3}[ ]?\\d{2}$","^39\\d{2}$","^(?:\\d{5})?$","^(\\d{4}([ ]?\\d{4})?)?$","^(948[5-9])|(949[0-7])$","^[A-Z]{3}[ ]?\\d{2,4}$","^(\\d{3}[A-Z]{2}\\d{3})?$","^980\\d{2}$","^((\\d{4}-)?\\d{3}-\\d{3}(-\\d{1})?)?$","^(\\d{6})?$","^(PC )?\\d{3}$","^\\d{2}-\\d{3}$","^00[679]\\d{2}([ \\-]\\d{4})?$","^4789\\d$","^\\d{3}[ ]?\\d{2}$","^00120$","^96799$","^6799$","^8\\d{4}$","^6798$","FIQQ 1ZZ","2899","(9694[1-4])([ \\-]\\d{4})?","9[78]3\\d{2}","9[78][01]\\d{2}","SIQQ 1ZZ","969[123]\\d([ \\-]\\d{4})?","969[67]\\d([ \\-]\\d{4})?","9695[012]([ \\-]\\d{4})?","9[78]2\\d{2}","988\\d{2}","008(([0-4]\\d)|(5[01]))([ \\-]\\d{4})?","987\\d{2}","9[78]5\\d{2}","PCRN 1ZZ","96940","9[78]4\\d{2}","(ASCN|STHL) 1ZZ","[HLMS]\\d{3}","TKCA 1ZZ","986\\d{2}","976\\d{2}"]
        var pinPredicate = NSPredicate()
        var result = Bool()
        for index in 0..<zipCodeRegExArray.count
        {
            pinPredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegExArray[index])
            if(pinPredicate.evaluate(with: zipCode) == true)
            {
                result = true
                break
            }
            else
            {
                result = false
            }
        }
        //        result = pinPredicate.evaluate(with: zipCode) as Bool
        return result
        
    }
   
    
//    //added by jainee
    class func getAddressFromLatLon() -> String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        var addressString : String = ""
        let lat: Double = Double("\(currentLatitude)")!
        let lon: Double = Double("\(currentLongitude)")!
        if (lat != 0 && lon != 0){
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        //                    print(pm.country!)
                        //                    print(pm.locality!)
                        //                    print(pm.subLocality!)
                        //                    print(pm.thoroughfare!)
                        //                    print(pm.postalCode!)
                        //                    print(pm.subThoroughfare!)
                        //                    if pm.subLocality != nil {
                        //                        addressString = addressString + pm.subLocality! + ", "
                        //                    }
                        //                    if pm.thoroughfare != nil {
                        //                        addressString = addressString + pm.thoroughfare! + ", "
                        //                    }
                        //                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                        //                    }
                        //                    if pm.country != nil {
                        //                        addressString = addressString + pm.country! + ", "
                        //                    }
                        //                    if pm.postalCode != nil {
                        //                        addressString = addressString + pm.postalCode! + " "
                        //                    }
                        print(addressString)
                        
                    }
            })
        }
        return addressString
    }
//    class func setStatusBarBackgroundColor(color: UIColor) {
//        
//        guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
//        
//        statusBar.backgroundColor = color
//    }
    
    class func isValidPassword(Input:String) -> Bool {
        let RegExpression = "^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$"
        let result = NSPredicate(format:"SELF MATCHES %@", RegExpression)
        return result.evaluate(with: Input)
    }
    
    class func removeLocalData() {
        let prefs = UserDefaults.standard
        // keyValue = prefs.string(forKey:USER_DETAILS)
        UserDefaults().set("0", forKey: IS_LOGIN)
        prefs.removeObject(forKey: "user_info")
        prefs.removeObject(forKey: USER_DATA)
       prefs.removeObject(forKey:USER_DETAILS)

    }
    
    class  func UTCToLocal(serverDate:Int) -> String {
        let createdDate = Utility.getDateTimeFromTimeInterVel(from: serverDate)
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
        let date = dateFormatter.string(from: createdDate)

        if let convertedDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.timeZone = .current
            let finaleDate = dateFormatter.string(from: convertedDate)
            return finaleDate
        }
        
        return ""
        
       }
    class func getAgoDate(timeStampDate:Double)->String{
        let date = Date(timeIntervalSince1970: TimeInterval(timeStampDate))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let postDate = formatter.date(from: strDate)!
        let timeFromNow = currentDate.offset(from: postDate)
        return timeFromNow
    }
    class func getMilSecondDateString(milisecond:Int,dateFormate:String)->String{
        let dateVar = NSDate(timeIntervalSince1970: TimeInterval(milisecond))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  dateFormate
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        print(dateFormatter.string(from: dateVar as Date))
        return dateFormatter.string(from: dateVar as Date)
    }
    class func getDate(timeStampDate:Double)->String{
        let date = Date(timeIntervalSince1970: TimeInterval(timeStampDate))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm:ss" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    class func getTimeValue(_ currentValue: Int) -> String? {
        var updatedValue = ""
        if currentValue < 60 {
            if currentValue == 1 {
                updatedValue = "\(currentValue) second"
            } else {
                updatedValue = "\(currentValue) seconds"
            }
        } else if currentValue >= 60 && currentValue < 3600 {
            let minute: Int = currentValue / 60
            if minute == 1 {
                updatedValue = "\(minute) minute"
            } else {
                updatedValue = "\(minute) minutes"
            }
        } else if currentValue >= 3600 && currentValue < 86400 {
            let hour: Int = currentValue / 3600
            if hour == 1 {
                updatedValue = "\(hour) hour"
            } else {
                updatedValue = "\(hour) hours"
            }
        } else if currentValue >= 86400 && currentValue < 604800 {
            let days: Int = currentValue / 86400
            if days == 1 {
                updatedValue = "\(days) day"
            } else {
                updatedValue = "\(days) days"
            }
        } else if currentValue >= 604800 && currentValue < 2592000 {
            let weeks: Int = currentValue / 604800
            if weeks == 1 {
                updatedValue = "\(weeks) week"
            } else {
                updatedValue = "\(weeks) weeks"
            }
        } else {
            let month: Int = currentValue / 2592000
            if month == 1 {
                updatedValue = "\(month) month"
            } else {
                updatedValue = "\(month) months"
            }
        }
        return updatedValue
    }
    
    class func stringDatetoStringDateWithDifferentFormate(dateString: String,fromDateFormatter:String,toDateFormatter: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormatter
        let myDate = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = toDateFormatter
        let somedateString = dateFormatter.string(from: myDate)
        return somedateString
    }
    
    class func successAlert(message: String){
        let banner = NotificationBanner(title: APPLICATION_NAME, subtitle: message, style: .success)
        banner.autoDismiss = true
        banner.duration = 2.0
        banner.show()
    }
    class func getCurrentLanguage() -> String{
            let userdef = UserDefaults.standard
            let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
            let current = langArray.firstObject as! String
            return current
        }
      class func setLanguage(langStr:String){
             let defaults = UserDefaults.standard
             defaults.set([langStr], forKey: "AppleLanguages")
             defaults.synchronize()
             Bundle.setLanguage(langStr)
         }
    
    class func setLocalizedValuesforView(parentview: UIView ,isSubViews : Bool)
    {
        if parentview is UILabel {
            let label = parentview as! UILabel
            let titleLabel = label.text
            if titleLabel != nil {
                label.text = self.getLocalizdString(value: titleLabel!)
            }
        }
        else if parentview is UIButton {
            let button = parentview as! UIButton
            let titleLabel = button.title(for:.normal)
            if titleLabel != nil {
                button.setTitle(self.getLocalizdString(value: titleLabel!), for: .normal)
            }
        }
        else if parentview is UITextField {
            let textfield = parentview as! UITextField
            let titleLabel = textfield.text!
            if(titleLabel == "")
            {
                let placeholdetText = textfield.placeholder
                if(placeholdetText != nil)
                {
                    textfield.placeholder = self.getLocalizdString(value:placeholdetText!)
                }
                
                return
            }
            textfield.text = self.getLocalizdString(value:titleLabel)
        }
        else if parentview is UITextView {
            let textview = parentview as! UITextView
            let titleLabel = textview.text!
            textview.text = self.getLocalizdString(value:titleLabel)
        }
        if(isSubViews)
        {
            for view in parentview.subviews {
                self.setLocalizedValuesforView(parentview:view, isSubViews: true)
            }
        }
    }
    class func getLocalizdString(value: String) -> String
       {
           var str = ""
           let language = self.getCurrentLanguage()
           let path = Bundle.main.path(forResource: language, ofType: "lproj")
           if(path != nil)
           {
               let languageBundle = Bundle(path:path!)
               str = NSLocalizedString(value, tableName: nil, bundle: languageBundle!, value: value, comment: "")
           }
           return str
       }
    
    class func displayLinkView(link: URL,completion: @escaping (_ error: Error?,_ meta: LPLinkMetadata?) -> Void){
        if let cacheMeta = retrieve(urlString: link.absoluteString){
            completion(nil,cacheMeta)
        }else{
            let mdProvider = LPMetadataProvider()
            mdProvider.startFetchingMetadata(for: link) { (metadata, error) in
                if error != nil{
                    DispatchQueue.main.async {
                        let data = LPLinkMetadata()
                        data.originalURL = link
                        cache(metadata: data,link: link.absoluteString)
                        completion(nil,data)
                    }
                }else{
                    DispatchQueue.main.async {
                        print(link)
                        if let meta = metadata{
                            cache(metadata: meta,link: link.absoluteString)
                        }
                        completion(nil,metadata)
                    }
                }
            }
        }
    }
    
  
    
//    class func getUserData() -> LoginResponse?{
//        if let data = UserDefaults.standard.value(forKey: USER_DATA) as? [String: Any]{
//            let dic = LoginResponse(JSON: data)
//            return dic
//        }
//        return nil
//    }
////
//    class func getAccessToken() -> String?{
//        if let token = getUserData()?.auth?.accessToken{
//            return token
//        }
//        return nil
//    }

//    class func setTabRoot(){
//
//        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
//        let control = storyBoard.instantiateViewController(withIdentifier: "TabbarScreen") as! TabbarScreen
//        let navVC = UINavigationController(rootViewController: control)
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//
//    }
//
//    class func setViewControllerRoot(){
//        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = main.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.interactivePopGestureRecognizer?.isEnabled = false
//        appDelegate.window?.rootViewController = navVC
//        appDelegate.window?.makeKeyAndVisible()
//
//    }
//
//    class func setUserInfoData(data: [String : Any]){
//        UserDefaults.standard.setValue(data, forKey: "user_info")
//    }
//
//    class func getUserInfoData() -> UserInfoResponse?{
//        if let data = UserDefaults.standard.value(forKey: "user_info") as? [String: Any]{
//            let dic = UserInfoResponse(JSON: data)
//            return dic
//        }
//        return nil
//    }
    
    class func labelWidth(height: CGFloat, font: UIFont,text: String) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }
    
    class func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    class func getDateTimeFromTimeInterVel(from dateIntervel: Int) -> Date{
        let date = Date(timeIntervalSince1970: TimeInterval(dateIntervel))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return date
    }
    
    class func compareDate(fromDate: Int,toDate: Int) -> Bool{
        let firstDate = Utility.getDateTimeFromTimeInterVel(from: fromDate)
        let compareDate = Utility.getDateTimeFromTimeInterVel(from: toDate)
        return self.getDateMonthYearFromDate(date: firstDate) == self.getDateMonthYearFromDate(date: compareDate)
        
    }
    
    class func getDateMonthYearFromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func getLocalDateFromUTCForMessageHeader(timeInterval: Int) -> String{
        let date = Utility.getDateTimeFromTimeInterVel(from: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = MM_DD_YYYY
        if Utility.getDateValue(date: date) == Utility.getDateValue(date: Date().dayBefore){
            return "Yesterday"
        }
        return "\(Utility.getDateValue(date: date) == Utility.getDateValue(date: Date()) ? "Today" : "\(dateFormatter.string(from: date))")"
    }
    
    class func getDateValue(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = MM_DD_YYYY
        return dateFormatter.string(from: date)
    }

    
    class func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!)yr"//ears ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1yr"//ear ago"
            } else {
                return "1yr"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)months"//onths ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1month"//onth ago"
            } else {
                return "1month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)w"//eeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1w"//eek ago"
            } else {
                return "1w"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)d"//ays ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1d"//ay ago"
            } else {
                return "1d"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h"//ours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1hr"//our ago"
            } else {
                return "1hr "//ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)min"//utes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1min"//ute ago"
            } else {
                return "1min"//ute ago"
            }
        }
//        else if (components.second! >= 3) {
//            return "\(components.second!)sec"//onds ago"
//        }
        else {
            return "Just now"
        }
        
    }
    
    class func getPostImage(postType: Int) -> (UIImage,String){
        switch postType {
        case 1:
            return (UIImage(named: "podcast_icon")!,"Podcast")
        case 2:
            return (UIImage(named: "video_icon")!,"Video")
        case 3:
            return (UIImage(named: "book_icon")!,"Book")
        default:
            return (UIImage(named: "article_icon")!,"Article")
        }
    }
    
    class func displayNVLoading(){
        appDelegate.window?.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    class func hideNVLoading(){
        activityIndicatorView.stopAnimating()
//        appDelegate.window?.addSubview(activityIndicatorView
    }
    
    class func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }

        return UIApplication.shared.canOpenURL(url)
    }
    
    class func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    class func loadLinkView(view: UIView){
        hideLinkLoadView(view: view)
        DispatchQueue.main.async {
            
            let linkLoadView = NVActivityIndicatorView(frame: CGRect(x: (view.bounds.width / 2) - 25, y:(view.bounds.height / 2) - 25, width: 30, height: 30),type: .ballSpinFadeLoader, color: UIColor.black)
            linkLoadView.tag = linkTag
            view.addSubview(linkLoadView)
            linkLoadView.startAnimating()
        }
    }

    class func hideLinkLoadView(view: UIView){
        DispatchQueue.main.async {
            for i in view.subviews{
                if i.tag == linkTag{
                    i.removeFromSuperview()
                }
            }
        }
    }
    
    class func hasSpecialCharacters(text: String) -> Bool {

        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9\n].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }
    
//    class func displayBannerView(message: String){
//        
//    }
    class func getFileFromDocumentDirectory(fileName: String) -> String?{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return URL(fileURLWithPath: filePath).absoluteString
        } else {
            return nil
        }
    }
}
var bundleKey: UInt8 = 0
class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIImage
{
//    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
//    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
//    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
//    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
//    var lowestQualityJPEGNSData: NSData
//    {
//        return UIImageJPEGRepresentation(self, 0.0)! as NSData
//    }
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.5)! as NSData}
    var lowestQualityJPEGNSData: NSData
    {
        return self.jpegData(compressionQuality: 0.0)! as NSData
    }
}

extension Optional where Wrapped == String {
    func isEmailValid() -> Bool{
        guard let email = self else { return false }
        let emailPattern = "[A-Za-z-0-9.-_]+@[A-Za-z0-9]+\\.[A-Za-z]{2,3}"
        do{
            let regex = try NSRegularExpression(pattern: emailPattern, options: .caseInsensitive)
            let foundPatters = regex.numberOfMatches(in: email, options: .anchored, range: NSRange(location: 0, length: email.count))
            if foundPatters > 0 {
                return true
            }
        }catch{
            //error
        }
        return false
    }
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))year ago"   }
        if months(from: date)  > 0 { return "\(months(from: date))months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date))days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))min ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))sec ago" }
        return ""
    }
}
func cache(metadata: LPLinkMetadata,link: String) {
  // Check if the metadata already exists for this URL
  do {
    guard retrieve(urlString: link) == nil else {
      return
    }

    // Transform the metadata to a Data object and
    // set requiringSecureCoding to true
    let data = try NSKeyedArchiver.archivedData(
      withRootObject: metadata,
      requiringSecureCoding: true)

    // Save to user defaults
    UserDefaults.standard.setValue(data, forKey: link)
  }
  catch let error {
    print("Error when caching: \(error.localizedDescription)")
  }
}

func retrieve(urlString: String) -> LPLinkMetadata? {
  do {
    // Check if data exists for a particular url string
    guard
      let data = UserDefaults.standard.object(forKey: urlString) as? Data,
      // Ensure that it can be transformed to an LPLinkMetadata object
      let metadata = try NSKeyedUnarchiver.unarchivedObject(
        ofClass: LPLinkMetadata.self,
        from: data)
      else { return nil }
    return metadata
  }
  catch let error {
    print("Error when caching: \(error.localizedDescription)")
    return nil
  }
}
class UserProfileTagsFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else { return nil }
        guard var newAttributesForElementsInRect = NSArray(array: attributesForElementsInRect, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        var leftMargin: CGFloat = 0.0;
        
        for attributes in attributesForElementsInRect {
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            }
            else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + 8 // Makes the space between cells
            newAttributesForElementsInRect.append(attributes)
        }
        
        return newAttributesForElementsInRect
    }
}
