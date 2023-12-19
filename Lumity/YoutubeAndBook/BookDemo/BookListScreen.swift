//
//  BookListScreen.swift
//  Lumity
//
//  Created by iMac on 08/11/22.
//

import UIKit
import ObjectMapper

class BookListScreen: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: dateSportTextField!
    
    var volumes = [Volume]()
    var youTubeVideoListResponse = [YouTubeVideoData]()
    var uploadType = UploadType.youTubeVideo.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.searchTextField.clearButtonMode = .always
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        switch uploadType {
        case UploadType.book.rawValue:
            self.titleLabel.text = "Book"
            break
        case UploadType.youTubeVideo.rawValue:
            self.titleLabel.text = "YouTube Video"
            break
        case UploadType.youTubeChannel.rawValue:
            self.titleLabel.text = "YouTube Channel"
            break
        default:
            print("Nothing")
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        let alert = UIAlertController(title: "Searching for a book",
                                      message:"What book are you looking for?" ,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter book name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] action in
            guard let textField = alert.textFields?.first,
                let searchText = textField.text else {
                    return
            }

            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(searchAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Segues
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow,
//                let controller = segue.destination as? DetailViewController {
//                let volume = volumes[indexPath.row]
//                controller.volume = volume
//            }
//        }
//    }

}

extension BookListScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadType == UploadType.book.rawValue ?  volumes.count : youTubeVideoListResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! VolumeTableViewCell
        
        switch uploadType {
        case UploadType.book.rawValue:
            cell.item = volumes[indexPath.row]
            break
        case UploadType.youTubeVideo.rawValue:
            cell.youTubeVideoData = youTubeVideoListResponse[indexPath.row]
            break
        case UploadType.youTubeChannel.rawValue:
            cell.youTubeVideoData = youTubeVideoListResponse[indexPath.row]
            break
        
        default:
            print("Nothing")
        }
        return cell
    }
}
//MARK:- TEXTFIELD DELEGATE
extension BookListScreen: UITextFieldDelegate{
    
    
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
        
        switch uploadType {
        case UploadType.book.rawValue:
            self.bookSearch(text: text)
            break
        case UploadType.youTubeVideo.rawValue:
            self.youTubeVideoAPI(text: text)
            break
        case UploadType.youTubeChannel.rawValue:
            self.youTubeChannelAPI(text: text)
            break
        
        default:
            print("Nothing")
        }
    }
    
    
    func bookSearch(text:String){
        GoogleBooksConnectionService.shared.loadVolumesWithName(name: text, completion: { result in
            guard let volumeListResponse = result as? VolumeListResponse,
                  let volumes = volumeListResponse.items else {
                return
            }
            print(volumes)
            self.volumes = volumes
            self.tableView.reloadData()
        });
    }
    //MARK: - YouTube Video API
    func youTubeVideoAPI(text:String){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
//

            PostService.shared.searchYouTubeVideo(urlString:"https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=AIzaSyCz6UkdugdD6ne8treaJYA0KVBKTkKsmyw") { (statusCode, response) in
                print(response.items?.toJSON())
                
                guard let youTubeListResponse = response.items as? [YouTubeVideoData]
                       else {
                    Utility.hideIndicator()
                    return
                }
                self.youTubeVideoListResponse = youTubeListResponse
                self.tableView.reloadData()
                
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
    
    //MARK: - YouTube Channel API
    func youTubeChannelAPI(text:String){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            PostService.shared.searchYouTubeVideo(urlString:"https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=channel&key=AIzaSyCz6UkdugdD6ne8treaJYA0KVBKTkKsmyw") { (statusCode, response) in
                print(response.items?.toJSON())
                
                guard let youTubeListResponse = response.items as? [YouTubeVideoData]
                       else {
                    Utility.hideIndicator()
                    return
                }
                self.youTubeVideoListResponse = youTubeListResponse
                self.tableView.reloadData()
                
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

class Volume: Mappable {
    var identifier: String!
    
    var title: String!
    var authors: [String]?
    var description: String?
    var image: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        
        title <- map["volumeInfo.title"]
        authors <- map["volumeInfo.authors"]
        description <- map["volumeInfo.description"]
        image <- map["volumeInfo.imageLinks.thumbnail"]
    }
    
}
class VolumeListResponse: Mappable {
    var totalItems: Int!
    var items: [Volume]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalItems <- map["totalItems"]
        items <- map["items"]
    }
}

class YouTubeListResponse: Mappable {
    
    var items: [YouTubeVideoData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

class YouTubeVideoData: Mappable {
    var identifier: String!
    var title: String!
    var description: String?
    var image: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["etag"]
        title <- map["snippet.title"]
        description <- map["snippet.description"]
        image <- map["snippet.thumbnails.medium.url"]
    }
    
}
