//
//  WebViewScreen.swift
//  Source-App
//
//  Created by iroid on 20/04/21.
//

import UIKit
import WebKit

class WebViewScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - VARIABLE DECLARE
    var webView: WKWebView!
    var linkUrl = ""
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        //webView.navigationDelegate = self
        initialDetail()
        // Do any additional setup after loading the view.
    }
    
    func initialDetail(){
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame = CGRect(origin: CGPoint.zero, size: containerView.frame.size)
        
        let urlString = linkUrl.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: linkUrl){
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            containerView.addSubview(webView!)
        }else if let url = URL(string: urlString){
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            containerView.addSubview(webView!)
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

 // MARK: - WKNAVIGATION DELEGATE
extension WebViewScreen: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
//        Utility.showIndicator()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
//        Utility.hideIndicator()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
