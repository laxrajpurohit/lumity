//
//  ReportScreen.swift
//  Source-App
//
//  Created by iroid on 10/04/21.
//

import UIKit

class ReportScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var reportTableView: UITableView!
    
    var postId: Int?
    var groupPostId: Int?
    var groupPostCommentId: Int?
    
    var isFromComment:Bool = false
    var reportArray:[ReportTitleModel] = [ReportTitleModel(title: "Suspicious or fake"),ReportTitleModel(title: "Harassment or hateful speech"),ReportTitleModel(title: "Violence or physical harm"),ReportTitleModel(title: "Inappropriate Content"),ReportTitleModel(title: "Intellectual property infringement or defamation"),ReportTitleModel(title: "I don’t want to see this")]
    
    var onSuccessReport : (() -> Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDetail()
    }
    
    func initialDetail(){
        let nib = UINib(nibName: "ReportTableViewCell", bundle: nil)
        reportTableView.register(nib, forCellReuseIdentifier: "ReportTableViewCell")
        reportTableView.tableFooterView = UIView()
    }
    
    //MARK: - REPORT POST API
    func reportPost(message: String?){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let data = ReportPostRequest(post_id: groupPostId == nil ? self.postId:groupPostId, message: message)
            PostService.shared.reportPost(parameters: data.toJSON(),isFromGroup: groupPostId != nil) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.onSuccessReport?()
                })
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - COMMENT REPORT POST API
    func reportCommentPost(message: String?){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            
            let data = ReportPostCommentRequest(comment_id:  groupPostCommentId == nil ? self.postId:groupPostCommentId, message: message)
            PostService.shared.reportComment(parameters: data.toJSON(), isFromGroup: groupPostCommentId != nil) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.onSuccessReport?()
                })
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension ReportScreen:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.item = reportArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.reportArray[indexPath.row].title
        if isFromComment{
            self.reportCommentPost(message:message)
        }else{
            self.reportPost(message: message)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }
}
