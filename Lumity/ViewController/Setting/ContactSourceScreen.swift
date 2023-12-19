//
//  ContactSourceScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit

class ContactSourceScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var settingTableView: UITableView!
    
    var itemArray: [YourAccoutRequest] = []
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDetail()
    }
    
    func setItemArray(){
        self.itemArray.append(YourAccoutRequest(subTitle: "Please let us know of any technical issues you may be having. We will aim to resolve these as soon as possible.", title: "Bugs & Fixes"))
        self.itemArray.append(YourAccoutRequest(subTitle: "Let us know how you’re enjoying the app and if there is anything new you’d like to see added.", title: "Feedback & Suggestions"))
        
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
extension ContactSourceScreen: UITableViewDelegate,UITableViewDataSource{
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
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "BugAndFixesScreen") as! BugAndFixesScreen
            self.navigationController?.pushViewController(control, animated: true)
        }else if indexPath.row == 1{
            let control = STORYBOARD.setting.instantiateViewController(withIdentifier: "FeedbackAndSuggestionsScreen") as! FeedbackAndSuggestionsScreen
            self.navigationController?.pushViewController(control, animated: true)
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
}
