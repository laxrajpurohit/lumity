//
//  ReportSuccessScreen.swift
//  Source-App
//
//  Created by iroid on 10/04/21.
//

import UIKit

class ReportSuccessScreen: UIViewController {

    // MARK: - VARIABLE DECLARE
    var onClose: (() -> Void)?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - ACTIONS
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: { [weak self] in
            self?.onClose?()
        })
    }
}
