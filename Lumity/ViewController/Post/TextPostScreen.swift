//
//  TextPostScreen.swift
//  Lumity
//
//  Created by iMac on 28/10/22.
//

import UIKit
import Cosmos

class TextPostScreen: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var saveForLaterView: UIView!
    @IBOutlet weak var addLibraryLabel: UILabel!
    @IBOutlet weak var captionTitle: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postButtonBGView: dateSportView!
    @IBOutlet weak var captionPlaceHolder: UILabel!
    @IBOutlet weak var postTypeImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var reselectTagView: dateSportView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var completeSelectedView: UIView!
    @IBOutlet weak var selectTagButtonView: dateSportView!
    @IBOutlet weak var intrestedCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var saveForLaterSelectedView: UIView!
    @IBOutlet weak var selectTagButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topRecommendationLabel: UILabel!
    @IBOutlet weak var topRecommendationSwitch: UISwitch!
    
    // MARK: - VARIABLE DECLARE
//    var postType : PostType = .book
    var isSaveForLater: Bool = false
    var isComplete: Bool = false
    var postWise: PostWise?
    
    var itemArray: [InterestsListData] = []
    var superVC: UIViewController?
    
    var completeAddNewPostDelegate: EnterNewPostDelegate?
    var myLibraryObj: MyLibraryListResponse?
    var postObj: PostReponse?
    
    var fromShare: Bool = false

    var groupId:Int?
    var groupPostId:Int?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.checkAllRequiredValue()
    }
    

    func initializeDetails(){
//        postButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        self.rateView.settings.minTouchRating = 0
        self.reselectTagView.isHidden = true
        self.setSaveAndComplete()
//        self.postTypeImageView.image = Utility.getPostImage(postType: self.postType.rawValue).0
//        self.postTitleLabel.text = Utility.getPostImage(postType: self.postType.rawValue).1
        self.tagCollectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        self.captionTextView.delegate = self
        self.rateView.didTouchCosmos = { [weak self] (rate) in
            self?.closeKeyboard()
        }
        self.displaySelectTagView()
        self.checkAllRequiredValue()
        
//        if self.myLibraryObj != nil || self.postWise != nil{
//            self.captionTitle.text = "Notes"
//            self.addLibraryLabel.isHidden = true
//            self.saveForLaterView.isHidden = true
//            self.completedView.isHidden = true
//            self.postButton.setTitle("Save", for: .normal)
//        }else{
//            self.captionTitle.text = "Caption"
//            self.addLibraryLabel.isHidden = false
//            self.saveForLaterView.isHidden = false
//            self.completedView.isHidden = false
//            self.postButton.setTitle("Post", for: .normal)
//        }
        
        if groupId != nil{
            self.addLibraryLabel.isHidden = true
            self.saveForLaterView.isHidden = true
            self.completedView.isHidden = true
            self.topRecommendationSwitch.isHidden = true
            self.topRecommendationLabel.isHidden = true
        }
        self.setEditPost()
    }
    
    func setEditPost(){
        if let data = self.postObj{
            self.captionTextView.text = data.caption
            self.topRecommendationSwitch.isOn = self.postObj?.pin == 1 ? true:false
            self.captionPlaceHolder.isHidden = ((self.captionTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0)) > 0
            self.rateView.rating = Double(data.rate ?? 0)
            self.intrestedCollectionViewHeight.constant = 100
            if let intrests = data.interest{
                for i in intrests{
                    let data = InterestsListData(interest_id: nil, name: i)
                    self.itemArray.append(data)
                }
            }
            self.tagCollectionView.reloadData()
            self.displaySelectTagView()
            if data.is_complete == 1{
                self.isComplete = true
            }else{
                self.isComplete = false
            }
            if data.is_saved == 1{
                self.isSaveForLater = true
            }else{
                self.isSaveForLater = false
            }
            self.setSaveAndComplete()
            self.checkAllRequiredValue()
        }
    }
    
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    

    
    func setSaveAndComplete(){
        self.saveForLaterSelectedView.isHidden = !self.isSaveForLater
        self.completeSelectedView.isHidden = !self.isComplete
    }
    
    func displaySelectTagView(){
        if self.itemArray.count > 0{
            self.selectTagButtonHeight.constant = 0
            self.selectTagButtonView.isHidden = true
            self.reselectTagView.isHidden = false
        }else{
            self.selectTagButtonHeight.constant = 40
            self.selectTagButtonView.isHidden = false
            self.reselectTagView.isHidden = true
        }
    }
    
    func checkAllRequiredValue() {
        if self.captionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    func enableContinueButton(isEnable: Bool){
        self.postButtonBGView.removeGradient(selectedGradientView: self.postButtonBGView)
        isEnable == true ?  self.postButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.postButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
//        self.postButtonBGView.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        self.postButton.isUserInteractionEnabled = isEnable
    }
    
    // MARK: - ACTIONS
    @IBAction func onSelectTagIntrest(_ sender: Any) {
        self.closeKeyboard()
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
        vc.delegate = self
        vc.fromPost = true
        vc.selectedTagIntrestedArray = self.itemArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onReselectTag(_ sender: Any) {
        self.closeKeyboard()
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
        vc.delegate = self
        vc.fromPost = true
        vc.selectedTagIntrestedArray = self.itemArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPost(_ sender: Any) {
            self.postAPI()
    }
}

//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension TextPostScreen: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.tagCollectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row].name
        cell.mainView.borderColor = Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = Utility.getUIcolorfromHex(hex: "707070")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.intrestedCollectionViewHeight.constant = collectionView.contentSize.height

        let width = Utility.labelWidth(height: 45, font: UIFont(name: "Calibri-Bold", size: 18)!, text: self.itemArray[indexPath.row].name ?? "")
        return CGSize(width: width + 20, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.intrestedCollectionViewHeight.constant = collectionView.contentSize.height
    }
}

extension TextPostScreen: SelectedIntrestDelegate{
    func getIntrestData(data: [InterestsListData]) {
        self.intrestedCollectionViewHeight.constant = 100
        self.itemArray = data
        self.tagCollectionView.reloadData()
        self.displaySelectTagView()
    }
}
//MARK: - TEXTVIEW DELEGATE
extension TextPostScreen: UITextViewDelegate{
        
    func textViewDidChange(_ textView: UITextView) {
        self.captionPlaceHolder.isHidden = textView.text.count > 0
        self.checkAllRequiredValue()
    }
}

 // MARK: - API CALLING
extension TextPostScreen{
    //MARK: - POST APi
    func postAPI(){
        self.view.endEditing(true)
        var idArray : [Int] = []
        if self.itemArray.allSatisfy({$0.interest_id != nil}){
            for i in self.itemArray{
                idArray.append(i.interest_id ?? 0)
            }
        }
        let arr = idArray.map { String($0) }.joined(separator: ",")
        
        //MARK: - BOOK POST
        if let vc = self.superVC as? GroupDetailScreen{
            if Utility.isInternetAvailable(){
                Utility.showIndicator()
                let data = CreatePostRequest(post_id: self.postObj?.id == nil ? nil : "\(self.postObj?.id ?? 0)",post_type: "5", title: nil, author:nil, link: nil,media_url: nil, rate: nil, caption: self.captionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines), is_saved: nil, is_complete: nil, interest_id: arr == "" ? nil : arr, group_post_id: self.postObj?.groupPostId == nil ? nil:"\(self.postObj?.groupPostId ?? 0)", group_id: groupId == nil ? nil:"\(groupId ?? 0)", pin: nil,is_public_post: nil)
                PostService.shared.createPost(parameters: data.toJSON(),imageData: nil,videoURL: nil,isGroupPost: groupId == nil ? false:true) { [weak self] (statusCode, response) in
                    Utility.hideIndicator()
                    guard let strongSelf = self else{
                        return
                    }
                    for controller in strongSelf.navigationController!.viewControllers as Array{
                        if controller is GroupDetailScreen && self?.groupId != nil{
                            self?.completeAddNewPostDelegate?.uploadNewPost()
                            strongSelf.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
                    if strongSelf.postObj != nil{
//                        if let superVC = vc.superVC{
//                            strongSelf.completeAddNewPostDelegate?.uploadNewPost()
//                            strongSelf.navigationController?.popToViewController(superVC, animated: true)
//                        }
                    }else{
//                        for controller in strongSelf.navigationController!.viewControllers as Array {
//                            if strongSelf.fromShare{
//                                if controller is TabBarScreen {
//                                    //                                    self?.completeAddNewPostDelegate?.uploadNewPost()
//                                    strongSelf.navigationController?.popToViewController(controller, animated: true)
//                                    break
//                                }
//                            }else{
//                                if controller is HomeScreen && self?.groupId == nil{
//                                    self?.completeAddNewPostDelegate?.uploadNewPost()
//                                    strongSelf.navigationController?.popToViewController(controller, animated: true)
//                                    break
//                                }else if controller is GroupDetailScreen && self?.groupId != nil{
//                                    self?.completeAddNewPostDelegate?.uploadNewPost()
//                                    strongSelf.navigationController?.popToViewController(controller, animated: true)
//                                    break
//                                }else if controller is TabBarScreen{
//                                    self?.completeAddNewPostDelegate?.uploadNewPost()
//                                    strongSelf.navigationController?.popToViewController(controller, animated: true)
//                                    break
//                                }
//                            }
//
//                        }
                    }
                    
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
    }
}
