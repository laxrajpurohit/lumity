//
//  folderOptionScreen.swift
//  Source-App
//
//  Created by iroid on 13/05/21.
//

import UIKit
import PanModal
class folderOptionScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var makePubicAndPrivateLabel: UILabel!
    @IBOutlet weak var makePrivateAndPublicImageView: UIImageView!
    
    var myLibraryDataDetailData:MyLibraryListResponse?
    var onDelete:(()->Void)?
    var onEditFolder:((MyLibraryListResponse)->Void)?
    var onSendMessage: (() -> Void)?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        panModalSetNeedsLayoutUpdate()
//        panModalTransition(to: .shortForm)

        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 16
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
        initailDetail()
    }
    
    func initailDetail(){
        
        makePubicAndPrivateLabel.text = myLibraryDataDetailData?.is_private == 1 ? "Make Public":"Make Private"
        makePrivateAndPublicImageView.image = myLibraryDataDetailData?.is_private == 1 ? UIImage(named: "make_public_icon"):UIImage(named: "make_private_icon")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func displayDeleteDialogue(obj: MyLibraryListResponse){
        let alertController = UIAlertController(title:"Delete '\(obj.name ?? "")' Playlist?" , message: "Are you sure you want to Delete the '\(obj.name ?? "")' Playlist?", preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action) in
            self?.deletePost(obj: obj)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func displayFolderMakeDialogue(obj: MyLibraryListResponse){
        let text = myLibraryDataDetailData?.is_private == 1 ? "‘\(obj.name ?? "")’ public":"‘\(obj.name ?? "")’ private"
        let detailText =  myLibraryDataDetailData?.is_private == 1 ? "Your community will be able to view this playlist":"Your community will not be able to view this playlist"
        
        let alertController = UIAlertController(title:"Make \(text)?" , message: detailText, preferredStyle: .alert)
        let resendAction = UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (action) in
            self?.editMyLibraryTitle(isPrivate: obj.is_private == 0 ? 1:0)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(resendAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deletePost(obj: MyLibraryListResponse){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = MyLibraryDeleteRequest(mylibrary_id: obj.id)
            MyLibraryService.shared.deleteMyLibraryAPI(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                guard let strongSelf = self else {
                    return
                }
                Utility.hideIndicator()
               
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.onDelete?()
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
    
    func editMyLibraryTitle(isPrivate:Int){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let data = EditMyFolderRequest(mylibrary_id: self.myLibraryDataDetailData?.id, name: self.myLibraryDataDetailData?.name, type: isPrivate)
            MyLibraryService.shared.editFolderTitleAPI(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                self?.myLibraryDataDetailData?.is_private = isPrivate
                self?.dismiss(animated: true, completion: { [weak self] in
                    if let data = self?.myLibraryDataDetailData{
                        self?.onEditFolder?(data)
                    }
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
    @IBAction func onSendDirectMessage(_ sender: Any) {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.onSendMessage?()
        })
    }
    
    @IBAction func onSaveOrLater(_ sender: Any) {

        if let data = myLibraryDataDetailData{
            displayFolderMakeDialogue(obj: data)
        }
        
    }
    @IBAction func onDelete(_ sender: Any) {
        if let data = myLibraryDataDetailData{
            displayDeleteDialogue(obj: data)
        }
        
    }
}
//MARK: - PANMODAL DELEGATE
extension folderOptionScreen: PanModalPresentable {

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
        return .contentHeight(240)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(240)
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
