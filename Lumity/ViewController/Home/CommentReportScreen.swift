//
//  CommentReportScreen.swift
//  Source-App
//
//  Created by iroid on 13/04/21.
//

import UIKit

// CommentReportScreen: Manages the screen for reporting or deleting a comment.
class CommentReportScreen: UIViewController {

    // Outlets for label and view components.
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var deleteLbel: UILabel!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var reportView: UIView!
    
    // Properties to store comment data and callbacks.
    var commentData:PostCommentReponse?
    var onReportComment: (() -> Void)?
    var onDelete: (() -> Void)?
    var commentObj: CommentResponse?
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = commentData{
            if data.user_id == Utility.getCurrentUserId(){
                self.deleteView.isHidden = false
                self.mainViewHeight.constant = 100
            }else{
                self.deleteView.isHidden = true
                self.mainViewHeight.constant = 50
            }
        }else{
            self.deleteView.isHidden = true
            self.mainViewHeight.constant = 50
        }
        
        if let data = self.commentObj{
            if data.user_id == Utility.getCurrentUserId(){
                self.deleteView.isHidden = false
//                self.mainViewHeight.constant = 100
                self.reportView.isHidden = true
                self.mainViewHeight.constant = 50
            }else{
                self.deleteView.isHidden = true
                self.mainViewHeight.constant = 50
                self.reportView.isHidden = false
//                self.mainViewHeight.constant = 5
            }
            if data.replayId != nil{
                self.deleteLbel.text = "Delete Reply"
                self.reportLabel.text = "Report Reply"
            }
        }else{
            self.deleteView.isHidden = true
            self.mainViewHeight.constant = 50
        }
    }
    
    // Action for back button - dismisses the current view controller.
    @IBAction func onBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Action for report button - shows a confirmation alert before reporting.
    @IBAction func onReport(_ sender: UIButton) {
        self.showConfirmationAlert(message: "Are you sure you want to report this comment?", type: 1)
    }
    
    // Action for delete button - dismisses the view controller and triggers the delete callback.
    @IBAction func onDelete(_ sender: Any) {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.onDelete?()
        })
    }
    
    // Shows a confirmation alert with a custom message and handles the user's response.
    func showConfirmationAlert(message:String,type:Int) {
        let alert = UIAlertController(title: APP_NAME, message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        self.dismiss(animated: true, completion: { [weak self] in
                                            self?.onReportComment?()
                                        })
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
