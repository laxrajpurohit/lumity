//
//  BlockConfirmationAlertScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit

class BlockConfirmationAlertScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var nameLabel: UILabel!
    
    var blockUserData:BlockUserResponse?
    var onUnBlock : (() -> Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "Unblock \(blockUserData?.first_name ?? "") \(blockUserData?.last_name ?? "")"
    }
    
    //MARK: - ACTIONS
    @IBAction func onUnblock(_ sender: UIButton) {
       
        self.onUnBlock?()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onBlock(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    

}
