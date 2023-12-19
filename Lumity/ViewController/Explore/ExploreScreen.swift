//
//  ExploreScreen.swift
//  Source-App
//
//  Created by iroid on 31/03/21.
//

import UIKit

class ExploreScreen: UIViewController {
    
    @IBOutlet weak var intrestCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestCollectionVIew: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userListTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchView: dateSportView!
    @IBOutlet weak var searchBottomView: UIView!
    
    var itemArray: [UserInterestList] = []
    var pageNum = 1
    var intresetArray: [InterestsListData] = []
    var meta : Meta?
    var superVC: TabBarScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.itemArray.removeAll()
       // self.searchTextField.text = ""
        self.getCommunityListData(str: self.searchTextField.text ?? "")
//        self.setupCollectionViewSelectMethod()
    }
    func initializeDetails(){
        self.tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        self.interestCollectionVIew.register(UINib(nibName: "ExploreIntrestCell", bundle: nil), forCellWithReuseIdentifier: "ExploreIntrestCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
        self.interestCollectionVIew.delegate = self
        self.interestCollectionVIew.dataSource = self
       
        self.getInterests()
        self.searchTextField.clearButtonMode = .always
    }
    
    @objc func textChangeSearch(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            self.getCommunityListData(str: nil)
        }else{
            self.pageNum = 1
            self.itemArray = []
            self.getCommunityListData(str: text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func changeJoinStatus(userId: Int,status: Int){
        if let index = self.itemArray.firstIndex(where: {$0.user_id == userId}){
            self.itemArray[index].join_status = status
            self.tableView.reloadData()
        }
    }
    
    func setIntresetCollectionViewHeight(){
        let isDevide = self.intresetArray.count % 2 == 0 ? 0 : 1
        let space : CGFloat = CGFloat(((self.intresetArray.count + isDevide) / 2) * 10)
        let cellHeight : CGFloat = 60
        let totalHeight : CGFloat = (cellHeight * CGFloat(((self.intresetArray.count + isDevide) / 2))) + space
        self.intrestCollectionViewHeight.constant = totalHeight
    }
    
    @IBAction func onShowMorePeople(_ sender: Any) {
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreUserListScreen") as! ExploreUserListScreen
        vc.itemArray = self.itemArray
        vc.searchText = self.searchTextField.text
        vc.meta = self.meta
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onHideSearchView(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
    }
}

//MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension ExploreScreen : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.isEmpty ? 0 : (self.itemArray.count > 3 ? 3 : self.itemArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunityCell
        if itemArray.count > 0{
            cell.item = self.itemArray[indexPath.row]
            cell.onJoin = { [weak self] in
                let status = self?.itemArray[indexPath.row].join_status == 0 ? 1 : 0
                self?.addJoinUser(userId: self?.itemArray[indexPath.row].user_id ?? 0,status: status)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.userListTableViewHeight.constant = tableView.contentSize.height
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray.indices.contains(indexPath.row){
            let vc = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
            vc.userId = self.itemArray[indexPath.row].user_id
            vc.superVC = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK: - TEXTFIELD DELEGATE
extension ExploreScreen: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.textChangeSearch(_:)),object: textField)
        self.perform(#selector(textChangeSearch),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.textChangeSearch(_:)),object: textField)
        self.perform(#selector(textChangeSearch),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        self.searchView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9411764706, alpha: 1)
        self.searchBottomView.isHidden = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        self.searchView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.searchBottomView.isHidden = true
    }
}
//MARK: - CollectionView DELEGATE & DELEGATE
extension ExploreScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.intresetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.interestCollectionVIew.dequeueReusableCell(withReuseIdentifier: "ExploreIntrestCell", for: indexPath) as! ExploreIntrestCell
        cell.item = self.intresetArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.intresetArray[indexPath.row]
        let vc = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreSelectedIntrestedScreen") as! ExploreSelectedIntrestedScreen
        vc.searhText = data.name
        vc.superVC = self.superVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftSpace = (self.interestCollectionVIew.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
        let rightSpace = (self.interestCollectionVIew.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.right
        let cellSpacing = (self.interestCollectionVIew.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let numberOFRows : CGFloat = 2
        let scWidth : CGFloat = screenWidth - (leftSpace + rightSpace)
        let totalSpace : CGFloat = cellSpacing * (numberOFRows - 1)
        let width = (scWidth - totalSpace) / numberOFRows
        return CGSize(width: width, height: 60)
    }
}
//MARK: - API calling
extension ExploreScreen{
    func getInterests(){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            LoginService.shared.getInterestsList { [weak self] (statusCode, respone) in
                Utility.hideIndicator()
                if let res = respone{
                    self?.intresetArray = res
                    self?.interestCollectionVIew.reloadData()
                    self?.setIntresetCollectionViewHeight()
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
    
    
    func getCommunityListData(str: String?){
        if Utility.isInternetAvailable(){
//            Utility.showIndicator()
            let url = userInterestListURL + "\(pageNum)"
            let data = SearchCommunityRequest(explore: "1",username: str, page: "\(pageNum)")
            LoginService.shared.getUserInterestList(parameters: data.toJSON(), url: url) { [weak self] (statusCode, response) in
                Utility.hideIndicator()
                print(response.userInterestListResponse?.toJSON())
                if let res = response.userInterestListResponse{
                        self?.itemArray = res
                        self?.tableView.reloadData()
                }
                if let meta = response.meta{
                    self?.meta = meta
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
    func appendPostDataTableView(data: [UserInterestList]){
        var indexPath : [IndexPath] = []
        for i in self.itemArray.count..<self.itemArray.count+data.count{
            indexPath.append(IndexPath(row: i, section: 0))
        }
        self.itemArray.append(contentsOf: data)
        self.tableView.insertRows(at: indexPath, with: .bottom)
    }
    
    func addJoinUser(userId: Int,status: Int){
        if Utility.isInternetAvailable(){
            //            Utility.showIndicator()
            let data = AddJoinRequest(join_user_id: userId,status: status)
            LoginService.shared.addJoinUser(parameters: data.toJSON()) { [weak self] (statusCode, response) in
                if Thread.isMainThread{
                    Utility.hideIndicator()
                    self?.changeJoinStatus(userId: userId,status: status)
                }else{
                    DispatchQueue.main.async { [weak self] in
                        self?.changeJoinStatus(userId: userId,status: status)
                    }
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

extension ExploreScreen {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: self.view)
    }
}
