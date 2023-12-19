//
//  YourAccountScreenViewController.swift
//  Source-App
//
//  Created by iroid on 07/05/21.
//

import UIKit

class YourAccountScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var settingTableView: UITableView!
    
    var itemArray: [YourAccoutRequest] = []
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    
    func setItemArray(){
        self.itemArray.append(YourAccoutRequest(subTitle: "Add or remove email addresses on your Account", title: "Email Address"))
        self.itemArray.append(YourAccoutRequest(subTitle: "Add or remove phone number on your Account", title: "Phone Numbers"))
        if !(Utility.getUserData()?.is_social ?? false){
            self.itemArray.append(YourAccoutRequest(subTitle: "Choose a unique password to protect your account", title: "Change password"))
        }
    }
    
    func initialDetail(){
        self.settingTableView.register(UINib(nibName: "YourAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "YourAccountTableViewCell")
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.tableFooterView = UIView()
        self.setItemArray()
    }
    
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension YourAccountScreen: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.settingTableView.dequeueReusableCell(withIdentifier: "YourAccountTableViewCell", for: indexPath) as! YourAccountTableViewCell
        cell.item = self.itemArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "EditEmailScreen") as! EditEmailScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 1{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "EditPhoneScreen") as! EditPhoneScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 2{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "ChangePasswordScreen") as! ChangePasswordScreen
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
