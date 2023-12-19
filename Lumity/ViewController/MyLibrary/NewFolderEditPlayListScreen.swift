//
//  NewFolderEditPlayListScreen.swift
//  Source-App
//
//  Created by iroid on 25/04/21.
//

import UIKit

class NewFolderEditPlayListScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var titleLabel: UILabel!
    
    var onSaveLater: (() ->Void)?
    var onUploadNewContent: (() ->Void)?
    var folderName: String?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = "Edit Playlist - "+(self.folderName ?? "")+" :"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: false, completion: nil)
    }
 
    //MARK: - ACTIONS
    @IBAction func onFromCompleted(_ sender: UIButton) {
       
        self.dismiss(animated: false) {
            self.onSaveLater?()
        }
    }
    
    @IBAction func onUploadNewContent(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.onUploadNewContent?()
        }
    }
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

