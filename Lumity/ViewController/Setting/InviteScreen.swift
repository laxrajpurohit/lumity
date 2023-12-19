//
//  InviteScreen.swift
//  Source-App
//
//  Created by iroid on 08/05/21.
//

import UIKit
import Contacts
import MessageUI

class InviteScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var inviteTableView: UITableView!
    @IBOutlet weak var inviteListView: UIView!
    @IBOutlet weak var contactNumberSearch: UITextField!
    @IBOutlet weak var enableContactNumberButton: UIButton!
    
    var syncContact = [SyncContact]()
    var filterSyncContact = [SyncContact]()
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDetail()
    }
    
    func initialDetail(){
        
//        self.enableContactNumberButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        
        self.inviteTableView.register(UINib(nibName: "InviteFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "InviteFriendsTableViewCell")
        self.inviteTableView.tableFooterView = UIView()
        checkContactAccess()
        self.contactNumberSearch.addTarget(self, action: #selector(self.changeText(textfield:)), for: .editingChanged)
    }
    
    @objc func changeText(textfield: UITextField){
        
        if textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            self.filterSyncContact = syncContact.filter({$0.full_name!.lowercased().hasPrefix(textfield.text!.lowercased())})
            self.inviteTableView.reloadData()
        }else{
            self.filterSyncContact = []
            self.inviteTableView.reloadData()
        }
    }
    
    func goToSetting(){
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted || status == .notDetermined{
            let alertController = UIAlertController (title: "Go to Settings?", message: "Please allow us to access contacts", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    
    func  checkContactAccess() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted || status == .notDetermined{
            inviteListView.isHidden = true
        }
        else{
            inviteListView.isHidden = false
            fetchContact()
        }
    }
    func fetchContact() {
        Utility.showIndicator()
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                DispatchQueue.main.async {
                    self.inviteListView.isHidden = true
                    Utility.hideIndicator()
                    self.goToSetting()
                }
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.syncContact.append(SyncContact(full_name: contact.givenName + " " + contact.familyName, phone_number: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
                //                self.synchContact()
                DispatchQueue.main.async {
                    self.inviteTableView.reloadData()
                    Utility.hideIndicator()
                }
            } else {
                print("access denied")
            }
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEnableAccessToContacts(_ sender: Any) {
        self.fetchContact()
        self.inviteListView.isHidden = false
        self.inviteTableView.reloadData()
      
       
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension InviteScreen:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (self.contactNumberSearch.text!.count > 0 && self.filterSyncContact.isEmpty) ? 0 : (self.filterSyncContact.isEmpty ? syncContact.count : filterSyncContact.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsTableViewCell", for: indexPath) as! InviteFriendsTableViewCell
        let searchResult = self.filterSyncContact.isEmpty ?  syncContact[indexPath.row] : filterSyncContact[indexPath.row]

        cell.nameLabel.text = searchResult.full_name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = self.filterSyncContact.isEmpty ?  syncContact[indexPath.row] : filterSyncContact[indexPath.row]
        let phoneNum = searchResult.phone_number
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "\(Utility.getUserData()?.first_name ?? "") \(Utility.getUserData()?.last_name ?? "") has invited you to join Lumity\nhttps://apps.apple.com/us/app/source-app/id1565191495"
            controller.recipients = [phoneNum ?? ""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
//MARK: - MAIL DELEGATE
extension InviteScreen:MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

