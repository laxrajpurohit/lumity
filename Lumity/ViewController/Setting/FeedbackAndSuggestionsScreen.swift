//
//  FeedbackAndSuggestionsScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit

class FeedbackAndSuggestionsScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var whatDoYouLikeTextView: UITextView!
    @IBOutlet weak var whereCanWeImproveTextView: UITextView!
    @IBOutlet weak var anyIntrestedTextView: UITextView!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableContinueButton(isEnable: false)
    }
   
    func enableContinueButton(isEnable: Bool){
        self.submitButton.removeGradient(selectedGradientView: self.submitButton)
        isEnable == true ?  self.submitButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.submitButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
//        self.submitButton.backgroundColor = isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6")
        self.submitButton.isUserInteractionEnabled = isEnable
    }
    
    func checkAllRequiredValue() {
        if self.whatDoYouLikeTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 || self.whereCanWeImproveTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 || self.anyIntrestedTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Thank you for submitting!", message: "It is much appreciated. We will take your feedback into consideration.",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    @IBAction func onSubmit(_ sender: UIButton) {
        doFeedBackAndSuggestions()
    }
            
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - TEXTVIEW DELEGATE
extension FeedbackAndSuggestionsScreen: UITextViewDelegate{
        
    func textViewDidChange(_ textView: UITextView) {
        self.checkAllRequiredValue()
    }
}
extension FeedbackAndSuggestionsScreen{
    //MARK: - FEEDBACK & SUGGESTIONS
    func doFeedBackAndSuggestions(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
                        Utility.showIndicator()
            let parameter = FeedBackAndSuggestionRequest(about_source: whatDoYouLikeTextView.text ?? "", we_improve: whereCanWeImproveTextView.text ?? "", any_interest: anyIntrestedTextView.text ?? "")
            ProfileService.shared.feedbackAndSuggection(parameters: parameter.toJSON()) { (statusCode, response) in
                Utility.hideIndicator()
                self.showSuccessAlert()
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
