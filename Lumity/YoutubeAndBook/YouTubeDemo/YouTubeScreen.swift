//
//  YouTubeScreen.swift
//  Lumity
//
//  Created by Laxmansingh Rajpurohit on 27/08/23.
//

import UIKit

class YouTubeScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: dateSportTextField!
    
    var volumes = [Volume]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        // Do any additional setup after loading the view.
    }

}
extension YouTubeScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! VolumeTableViewCell
        cell.volumeTitleLabel.text = volumes[indexPath.row].title
        cell.autherNameLabel.text = "by \(volumes[indexPath.row].authors?.first ?? "")"
        Utility.setImage(volumes[indexPath.row].image, imageView:  cell.bookImageView)
        
        return cell
    }
}
//MARK:- TEXTFIELD DELEGATE
extension YouTubeScreen: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.checkTextFieldChangedValue(textField:)),object: textField)
        self.perform(#selector(self.checkTextFieldChangedValue(textField:)),with: textField,afterDelay: 0.5)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(self.checkTextFieldChangedValue(textField:)),object: textField)
        self.perform(#selector(self.checkTextFieldChangedValue(textField:)),with: textField,afterDelay: 0.5)
        return true
    }
    
    @objc func checkTextFieldChangedValue(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        GoogleBooksConnectionService.shared.loadVolumesWithName(name: text, completion: { result in
            guard let volumeListResponse = result as? VolumeListResponse,
                  let volumes = volumeListResponse.items else {
                return
            }
            print(volumes)
            self.volumes = volumes
            self.tableView.reloadData()
        })
    }
    
    
    
    //MARK:- YouTube Video API
    func youTubeVideoAPI(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            PostService.shared.searchYouTubeVideo(urlString:"https://www.googleapis.com/youtube/v3/search?part=snippet&q=lax&type=channel&key=AIzaSyCz6UkdugdD6ne8treaJYA0KVBKTkKsmyw") { (statusCode, response) in
                Utility.hideIndicator()
            } failure: { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
            
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
