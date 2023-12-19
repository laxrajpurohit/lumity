//
//  InterestScreen.swift
//  Source-App
//
//  Created by Nikunj on 26/03/21.
//

import UIKit
import KTCenterFlowLayout

class InterestScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var intrestDescriptionLabel: UILabel!
    @IBOutlet weak var shareTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalSelctedLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var continueView: UIView!

    var idArray: [Int] = []
    var InterestsList:[InterestsListData] = []
    
    var fromPost: Bool = false
    var selectedTagIntrestedArray: [InterestsListData] = []
    var delegate: SelectedIntrestDelegate?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.continueView.removeGradient(selectedGradientView: self.continueView)
        self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        self.setCollectionView()
        
        self.getInterests()
        if self.fromPost{
            self.shareTitle.text = "Select related interests to this post. Choose up to 3"
            self.totalSelctedLabel.text = "(0/3)"
            self.skipButton.isHidden = true
            self.backButton.isHidden = false
        }else{
            self.skipButton.isHidden = false
            self.backButton.isHidden = true
            self.shareTitle.text = "Select passions that you’d like to share. Choose up to 5."
            self.totalSelctedLabel.text = "(0/5)"
        }
        if self.fromPost{
            self.setContinueButtonAndTextFromPost()
        }
        self.intrestDescriptionLabel.text = self.fromPost ? nil : "You are not limited to posting about the interests you select. This simply allows for your community to know a little bit more about you."
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.idArray = []
//        self.collectionView.reloadData()
//        self.totalSelctedLabel.text = "(\(self.idArray.count)/5)"
    }
    
    func setCollectionView(){
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        self.collectionView.collectionViewLayout = layout
    }

    func addInterestAPI(){
        let data = AddInterestRequest(interest_id: self.idArray.map { String($0) }.joined(separator: ","))
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            LoginService.shared.addInterest(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                let userData = Utility.getUserData()
                userData?.interest_type = 1
                Utility.saveUserData(data: (userData?.toJSON())!)
                self?.goFurther()
            } failure: {  [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func goFurther(){
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityScreen") as! CommunityScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setContinueButtonAndTextFromPost(){
        if  self.selectedTagIntrestedArray.count < 1{
            self.continueButton.isUserInteractionEnabled = false
//            self.continueView.layer.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
            self.continueView.removeGradient(selectedGradientView: self.continueView)
            self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        }else{
            self.continueButton.isUserInteractionEnabled = true
            self.continueView.removeGradient(selectedGradientView: self.continueView)
            self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.continueView.layer.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
        }
        self.totalSelctedLabel.text = "(\(self.selectedTagIntrestedArray.count)/3)"
    }
   
    //MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        if self.fromPost{
            self.delegate?.getIntrestData(data: self.selectedTagIntrestedArray)
            self.navigationController?.popViewController(animated: false)
        }else{
            if self.idArray.count == 0{
                Utility.showAlert(vc: self, message: "Please press skip if you do not want to select any interests at this time.")
            }else{
                self.addInterestAPI()
            }
           
        }
    }
    
    @IBAction func onSkip(_ sender: UIButton) {
        self.goFurther()
    }
}
//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension InterestScreen: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.InterestsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.InterestsList[indexPath.row].name
        cell.mainView.shadowOpacity = 1
        if self.fromPost{
            cell.mainView.borderColor = self.selectedTagIntrestedArray.contains(where: {$0.interest_id == self.InterestsList[indexPath.row].interest_id}) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "E6E6E6")
            cell.label.textColor = self.selectedTagIntrestedArray.contains(where: {$0.interest_id == self.InterestsList[indexPath.row].interest_id}) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "707070")
        }else{
            cell.mainView.borderColor = self.idArray.contains(self.InterestsList[indexPath.row].interest_id ?? 0) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "E6E6E6")
            cell.label.textColor = self.idArray.contains(self.InterestsList[indexPath.row].interest_id ?? 0) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "707070")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.fromPost{
            if let index = self.selectedTagIntrestedArray.firstIndex(where: {$0.interest_id == self.InterestsList[indexPath.row].interest_id }){
                self.selectedTagIntrestedArray.remove(at: index)
            }else{
                guard 3 > self.selectedTagIntrestedArray.count  else {
                    return
                }
                self.selectedTagIntrestedArray.append(self.InterestsList[indexPath.row])
            }
        }else{
            if let index = self.idArray.firstIndex(where: {$0 ==  self.InterestsList[indexPath.row].interest_id }){
                self.idArray.remove(at: index)
            }else{
                guard 5 > self.idArray.count  else {
                    return
                }
                self.idArray.append(self.InterestsList[indexPath.row].interest_id ?? 0)
            }
        }
        
        if self.fromPost{
            self.setContinueButtonAndTextFromPost()
        }else{
            if  self.idArray.count < 1{
                self.continueButton.isUserInteractionEnabled = false
//                self.continueView.layer.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
                self.continueView.removeGradient(selectedGradientView: self.continueView)
                self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
            }else{
                self.continueButton.isUserInteractionEnabled = true
//                self.continueView.layer.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
                self.continueView.removeGradient(selectedGradientView: self.continueView)
                self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            }
            self.totalSelctedLabel.text = "(\(self.idArray.count)/5)"
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Utility.labelWidth(height: 45, font: UIFont(name: "Calibri-Bold", size: 18)!, text: self.InterestsList[indexPath.row].name ?? "")
        return CGSize(width: width + 20, height: 45)
    }
}
//MARK: - API calleing
extension InterestScreen{
    func getInterests(){
        if Utility.isInternetAvailable(){
           // Utility.showIndicator()
            LoginService.shared.getInterestsList { [weak self] (statusCode, respone) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                if let res = respone{
                    stronSelf.InterestsList.append(contentsOf: res)
                    for (index,obj) in stronSelf.selectedTagIntrestedArray.enumerated(){
                        if obj.interest_id == nil{
                            if let intrestObj = res.first(where: {$0.name == obj.name}){
                                stronSelf.selectedTagIntrestedArray[index].interest_id = intrestObj.interest_id
                            }
                        }
                    }
                    
                    stronSelf.collectionView.reloadData()
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

