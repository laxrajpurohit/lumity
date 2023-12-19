//
//  EditPlayListScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/04/21.
//

import UIKit

class EditPlayListScreen: UIViewController {

    var onSaveLater: (()->Void)?
    var onUploadNewContent: (()->Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  //MARK: - ACTIONS
    @IBAction func onSaveLater(_ sender: UIButton) {
       
        self.dismiss(animated: true) {
            self.onSaveLater!()
        }
    }
    
    @IBAction func onUploadNewContent(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.onUploadNewContent!()
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
