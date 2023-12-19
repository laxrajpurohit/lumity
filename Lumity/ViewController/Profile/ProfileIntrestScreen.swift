//
//  ProfileIntrestScreen.swift
//  Source-App
//
//  Created by Nikunj on 09/05/21.
//

import UIKit
import KTCenterFlowLayout

class ProfileIntrestScreen: UIViewController {
    // MARK: - OUTLETS
    @IBOutlet weak var intrestDescriptionLabel: UILabel!
    @IBOutlet weak var shareTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalSelctedLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueView: UIView!
    
    // MARK: - VARIABLE DECLARE
    var itemArray: [InterestsListData] = []
    var selectedTagIntrestedArray: [InterestsListData] = []
    var delegate: SelectedIntrestDelegate?
    var timerForShowScrollIndicator: Timer?

    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
        self.setCollectionView()
        
        self.getInterests()
        self.shareTitle.text = "Select passions that you’d like to share. Choose up to 5."
        self.totalSelctedLabel.text = "(0/5)"
        self.backButton.isHidden = false
        self.setContinueButtonAndTextFromPost()
        self.intrestDescriptionLabel.text = nil
        collectionView.flashScrollIndicators()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.001) {
            self.collectionView.flashScrollIndicators()
        }
    }
    
    func setCollectionView(){
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: - ACTIONS
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinue(_ sender: UIButton) {
        self.delegate?.getIntrestData(data: self.selectedTagIntrestedArray)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func onSkip(_ sender: UIButton) {
        self.goFurther()
    }
    
    func goFurther(){
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "CommunityScreen") as! CommunityScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setContinueButtonAndTextFromPost(){
        if  self.selectedTagIntrestedArray.count < 1{
            self.continueButton.isUserInteractionEnabled = false
            self.continueView.removeGradient(selectedGradientView: self.continueView)
            self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
//            self.continueView.layer.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
        }else{
            self.continueButton.isUserInteractionEnabled = true
            self.continueView.removeGradient(selectedGradientView: self.continueView)
            self.continueView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            
//            self.continueView.layer.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.7098039216, blue: 0.7450980392, alpha: 1)
        }
        self.totalSelctedLabel.text = "(\(self.selectedTagIntrestedArray.count)/5)"
    }
    
    func addIntrestId(){
        for i in self.selectedTagIntrestedArray{
            if i.interest_id == nil{
                if let obj = self.itemArray.first(where: {$0.name == i.name}){
                    i.interest_id = obj.interest_id
                }
            }
        }
    }
}

//MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE
extension ProfileIntrestScreen: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
        cell.label.text = self.itemArray[indexPath.row].name
        cell.mainView.shadowOpacity = 1
        cell.mainView.borderColor = self.selectedTagIntrestedArray.contains(where: {$0.interest_id == self.itemArray[indexPath.row].interest_id}) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "E6E6E6")
        cell.label.textColor = self.selectedTagIntrestedArray.contains(where: {$0.interest_id == self.itemArray[indexPath.row].interest_id}) ? Utility.getUIcolorfromHex(hex: "9D84C0") : Utility.getUIcolorfromHex(hex: "707070")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = self.selectedTagIntrestedArray.firstIndex(where: {$0.interest_id == self.itemArray[indexPath.row].interest_id }){
            self.selectedTagIntrestedArray.remove(at: index)
        }else{
            guard 5 > self.selectedTagIntrestedArray.count  else {
                return
            }
            self.selectedTagIntrestedArray.append(self.itemArray[indexPath.row])
        }
        self.setContinueButtonAndTextFromPost()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Utility.labelWidth(height: 45, font: UIFont(name: "Calibri-Bold", size: 18)!, text: self.itemArray[indexPath.row].name ?? "")
        return CGSize(width: width + 20, height: 45)
    }
}
//MARK: - API calling
extension ProfileIntrestScreen{
    func getInterests(){
        if Utility.isInternetAvailable(){
           // Utility.showIndicator()
            LoginService.shared.getInterestsList {  [weak self] (statusCode, respone) in
               // Utility.hideIndicator()
                if let res = respone{
                    self?.itemArray.append(contentsOf: res)
                    self?.addIntrestId()
                    self?.collectionView.reloadData()
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


