//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Nikunj on 02/09/21.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var imageType = ""

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
            print("Item \(item)")
            guard  let attachments = item.attachments else {
                return
            }
            for item in attachments{
                print(item)
                if item.hasItemConformingToTypeIdentifier("public.jpeg"){
                    imageType = "public.jpeg"
                }
                if item.hasItemConformingToTypeIdentifier("public.png"){
                    imageType = "public.png"
                }
                print("imageType\(imageType)")
                let propertyList = String(kUTTypePropertyList)

                
                if item.hasItemConformingToTypeIdentifier(imageType){
                    print("True")
                    item.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { (item, error) in
                        
                        var imgData: Data!
                        if let url = item as? URL{
                            imgData = try! Data(contentsOf: url)
                        }
                        
                        if let img = item as? UIImage{
                            imgData = img.pngData()
                        }
                        let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                        let savedata =  UserDefaults.init(suiteName: "group.com.source.mobile.app")
                        savedata?.set(dict, forKey: "data")
                        savedata?.synchronize()
                        print("ImageData \(String(describing: savedata?.value(forKey: "img")))")
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: {_ in
                            self.openURL(url: URL(string:"openPdf://fromShareVC")!)
                        })
                    })
                }else  if item.hasItemConformingToTypeIdentifier("public.url") {
                    item.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
                        if let shareURL = url as? URL {
                            // Do stuff with your URL now.
                            let dict: [String : Any] = ["url" :  shareURL.absoluteString]
                            let savedata =  UserDefaults.init(suiteName: "group.com.source.mobile.app")
                            savedata?.set(dict, forKey: "data")
                            savedata?.synchronize()
                        }
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:{_ in
                            self.openURL(url: URL(string:"openPdf://fromShareVC")!)
                        })
                    })
                } else if item.hasItemConformingToTypeIdentifier("public.plain-text") {
                    item.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (url, error) in
                        if let shareURL = url as? String {
                            // Do stuff with your URL now.
                            let dict: [String : Any] = ["url" :  shareURL]
                            let savedata =  UserDefaults.init(suiteName: "group.com.source.mobile.app")
                            savedata?.set(dict, forKey: "data")
                            savedata?.synchronize()
                        }
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:{_ in
                            self.openURL(url: URL(string:"openPdf://fromShareVC")!)
                        })
                    })
                }else {
                    print("error")
                }
            }
        }
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        print("click")
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    func openURL(url: URL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector(inBackground: "openURL:", with: url) != nil
        }
        catch {
            return false
        }
    }


    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.next
        }

        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
}
