//
//  VideoPostScreen.swift
//  Source-App
//
//  Created by Nikunj on 11/04/21.
//

import UIKit
import LinkPresentation

class VideoPostScreen: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var continueButtonBGView: dateSportView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    
    // MARK: - VARIABLE DECLARE
    var superVC: UIViewController?
    var myLibraryObj: MyLibraryListResponse?
    var postWise: PostWise?
    var postObj: PostReponse?
    
    var isFromShare: Bool = false
    var shareLink: URL?
    var groupId:Int?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.checkAllRequiredValue()
    }
    
    func initializeDetails(){
        self.setUpTextFieldChangeEvent()
        self.checkAllRequiredValue()
        self.linkTextField.delegate = self
        self.setEditPost()
        if let shareURL = self.shareLink{
            self.linkTextField.text = shareURL.absoluteString
            self.loadLinkView(link: shareURL.absoluteString)
            self.checkAllRequiredValue()
        }
//        self.continueButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
    }
    
    func setEditPost(){
        if let data = self.postObj{
            self.linkTextField.text = data.link
            if let link = data.link{
                self.loadLinkView(link: link)
                self.linkView.subviews.forEach { (view) in
                    view.frame = CGRect(x: 0, y: 0, width: screenWidth - 30, height: self.linkView.bounds.height)
                }
            }
            self.checkAllRequiredValue()
        }
    }
    
    func setUpTextFieldChangeEvent(){
        self.linkTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.checkAllRequiredValue()
    }
    
    func checkAllRequiredValue() {
        if !self.checkTextFieldValueNill(textField: self.linkTextField) && Utility.verifyUrl(urlString: self.linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)){
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    func enableContinueButton(isEnable: Bool){
//        self.continueButtonBGView.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        
        self.continueButtonBGView.removeGradient(selectedGradientView: self.continueButtonBGView)
        isEnable == true ?  self.continueButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.continueButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
        self.continueButton.isUserInteractionEnabled = isEnable
      
    }
    
    func checkTextFieldValueNill(textField: UITextField) -> Bool{
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }

    // MARK: - ACTIONS
    @IBAction func onContinue(_ sender: Any) {
        let vc = STORYBOARD.post.instantiateViewController(withIdentifier: "PostEnterDetailScreen") as! PostEnterDetailScreen
        vc.postType = .video
        vc.superVC = self
        if let homeVC = self.superVC as? HomeScreen{
            vc.completeAddNewPostDelegate = homeVC
        }else if let intrestPostScreen = self.superVC as? ExploreSelectedIntrestedScreen{
            vc.completeAddNewPostDelegate = intrestPostScreen
        }else if let profileTabScreen = self.superVC as? ProfileTabbarScreen{
            vc.completeAddNewPostDelegate = profileTabScreen
        }else if let playListPostVC = self.superVC as? PlayListDetailScreen{
            vc.completeAddNewPostDelegate = playListPostVC
        }else if let completedVC = self.superVC as? SaveForLaterPostScreen{
            vc.completeAddNewPostDelegate = completedVC
        }else if let completedVC = self.superVC as? GroupDetailScreen{
            vc.completeAddNewPostDelegate = completedVC
        }
        vc.groupId = self.groupId
        vc.myLibraryObj = self.myLibraryObj
        vc.postWise = self.postWise
        vc.postObj = self.postObj
        vc.fromShare = self.isFromShare
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = self.linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.enableContinueButton(isEnable: false)
            self.linkView.subviews.forEach({ $0.removeFromSuperview() })
        }else{
            if Utility.verifyUrl(urlString: text){
                self.enableContinueButton(isEnable: true)
                self.loadLinkView(link: text)
            }else{
                self.enableContinueButton(isEnable: false)
                self.linkView.subviews.forEach({ $0.removeFromSuperview() })
            }
        }
    }
    
    func loadLinkView(link: String){
        activityIndicatorView.frame = CGRect(x: (self.linkView.frame.width / 2) - 25, y: (self.linkView.frame.height / 2) - 25, width: 50, height: 50)
        self.linkView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        Utility.displayLinkView(link: URL(string: link)!) { [weak self] (error, metaData) in
            guard let strongSelf = self else {
                return
            }
            guard let meta = metaData else {
                return
            }
            let linkMetaView = LPLinkView(metadata: meta)
            strongSelf.linkView.addSubview(linkMetaView)
            linkMetaView.frame = strongSelf.linkView.bounds
            activityIndicatorView.stopAnimating()
//            strongSelf.linkView.borderColor = .clear
        }
    }

    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TEXTVIEW DELEGATE
extension VideoPostScreen: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.checkTextFieldChangedValue(textField:)),object: textField)
            self.perform(#selector(self.checkTextFieldChangedValue(textField:)),with: textField,afterDelay: 0.5)
        return true
    }
}

