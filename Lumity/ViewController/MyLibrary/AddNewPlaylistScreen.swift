//
//  AddNewPlaylistScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/04/21.
//

import UIKit

class AddNewPlaylistScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var playListTextField: UITextField!
    @IBOutlet weak var playListLabel: UILabel!
    
    var superVC: MyLibraryScreen?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playListTextField.addTarget(self, action: #selector(self.changePlayListName(textField:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func changePlayListName(textField: UITextField){
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        if text.count == 0{
            self.playListLabel.text = "Name of new playlist"
        }else{
            self.playListLabel.text = text
        }
    }
    
    func checkValidation() -> String?{
        if self.playListTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            return "Please enter playlist name"
        }
        return nil
    }
   
    //MARK: - ACTIONS
    @IBAction func onNext(_ sender: Any) {
        if let error =  self.checkValidation(){
            Utility.showAlert(vc: self, message: error)
        }else{
            let vc = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "AddFromCompletedScreen") as! AddFromCompletedScreen
            vc.playListName = self.playListTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            vc.delegate = self.superVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
