//
//  DeletePostScreen.swift
//  Source-App
//
//  Created by Nikunj on 27/05/21.
//

import UIKit
import PanModal

class DeletePostScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var mainView: UIView!
    
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        panModalSetNeedsLayoutUpdate()
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 16
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ACTIONS
    @IBAction func onDeletePost(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onDelete?()
        }
    }
    
    @IBAction func onEditPost(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onEdit?()
        }
    }

}
//MARK: - PANMODAL DELEGATE
extension DeletePostScreen: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(170)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(170)
    }
    
    var allowsExtendedPanScrolling: Bool{
        return true
    }
    
    var showDragIndicator: Bool{
        return false
    }
    
    
//    var panModalBackgroundColor: UIColor{
//        return Utility.getUIcolorfromHex(hex: "eaeaea")
//    }
}
