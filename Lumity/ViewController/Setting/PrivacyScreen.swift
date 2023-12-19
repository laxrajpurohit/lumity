//
//  PrivacyScreen.swift
//  Source-App
//
//  Created by iroid on 07/08/21.
//

import UIKit
import MessageUI

class PrivacyScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var privacyTableView: UITableView!
    
    var itemArray: [YourAccoutRequest] = []
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    
    func setItemArray(){
        self.itemArray.append(YourAccoutRequest(subTitle: "", title: "Privacy Policy"))
        self.itemArray.append(YourAccoutRequest(subTitle: "", title: "Terms of Service"))
        self.itemArray.append(YourAccoutRequest(subTitle: "", title: "Questions about your data"))
        
    }
    
    func initialDetail(){
        self.privacyTableView.register(UINib(nibName: "PrivacyCell", bundle: nil), forCellReuseIdentifier: "PrivacyCell")
        self.privacyTableView.delegate = self
        self.privacyTableView.dataSource = self
        self.privacyTableView.tableFooterView = UIView()
        self.setItemArray()
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension PrivacyScreen: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.privacyTableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! PrivacyCell
        cell.item = self.itemArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
            control.linkUrl = privacyPolicyURL
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 1{
            let control = STORYBOARD.webView.instantiateViewController(withIdentifier: "WebViewScreen") as! WebViewScreen
            control.linkUrl = termConditionURL
            self.navigationController?.pushViewController(control, animated: true)
        } else if indexPath.row == 2{
            let recipientEmail = "Support@lumityapp.com"
            let subject = "Your data"
            let body = "What questions/requests do you have about your data?"
            
            // Show default mail composer
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                present(mail, animated: true)
                
                // Show third party email composer if default Mail app is not present
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
//MARK: - EMAIL DELEGATE
extension PrivacyScreen : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
