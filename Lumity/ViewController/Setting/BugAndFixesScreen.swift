//
//  BugAndFixesScreen.swift
//  Source-App
//
//  Created by iroid on 09/05/21.
//

import UIKit
import MobileCoreServices
import AVFoundation

class BugAndFixesScreen: UIViewController {
    
    //MARK: - OUTLET
    @IBOutlet weak var attachPhotoVideoLabel: UILabel!
    
    @IBOutlet weak var attachImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var whatIssueTextView: UITextView!
    var videoAndImageData: Data? = nil
    var videoUrl:URL? = nil
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableContinueButton(isEnable: false)
    }
   
    func enableContinueButton(isEnable: Bool){
        self.submitButton.removeGradient(selectedGradientView: self.submitButton)
        isEnable == true ?  self.submitButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8):self.submitButton.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        
//        self.submitButton.setTitleColor(isEnable ? Utility.getUIcolorfromHex(hex: "5BB5BE") : Utility.getUIcolorfromHex(hex: "A4D1D6"), for: .normal)
//        self.submitButton.backgroundColor =
        self.submitButton.isUserInteractionEnabled = isEnable
    }
    
    
    func checkAllRequiredValue() {
        if self.whatIssueTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            self.enableContinueButton(isEnable: true)
        }else{
            self.enableContinueButton(isEnable: false)
        }
    }
    
    //MARK:- Photo Video Alert
    func photoVideoSelectOption(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the actions
        let takePhoto = UIAlertAction(title: "Image", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openGallery()
        }
        let galleryPhoto = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectVideo()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(takePhoto)
        alertController.addAction(galleryPhoto)
        alertController.addAction(cancelAction)
        
        //   Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Select Video
    func selectVideo(){
        let videoPickerController = UIImagePickerController()
        videoPickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false { return }
       // videoPickerController.allowsEditing = true
        videoPickerController.sourceType = .photoLibrary
//        videoPickerController.videoMaximumDuration = 8//TimeInterval(240.0)
        videoPickerController.mediaTypes = [kUTTypeMovie as String]
        videoPickerController.modalPresentationStyle = .custom
        self.present(videoPickerController, animated: true, completion: nil)
    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Thank you for submitting!", message: "We will review and get back with you shortly. We apologize for any inconvenience. We hope to remedy this situation soon.",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAttachView(){
        self.attachPhotoVideoLabel.text = "Attach photo or video"
        self.attachPhotoVideoLabel.textColor = .black
        self.videoAndImageData = nil
        self.videoUrl = nil
        self.removeButton.isHidden = true
        self.attachImageView.image = UIImage(named: "attach_img_icon")
    }
    
    func displayImageViewName(name: String){
        self.attachPhotoVideoLabel.text = name
        self.attachPhotoVideoLabel.textColor = Utility.getUIcolorfromHex(hex: "6085FF")
        self.removeButton.isHidden = false
        self.attachImageView.image = UIImage(named: "attachment_icon")
    }
    
    //MARK: - ACTIONS
    @IBAction func onSubmit(_ sender: UIButton) {
        doBugAndFixes()
    }
            
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAttachPhotoVideo(_ sender: Any) {
        self.photoVideoSelectOption()
    }
    
    @IBAction func onRemove(_ sender: Any) {
        self.displayAttachView()
    }
}
//MARK: - TEXTVIEW DELEGATE
extension BugAndFixesScreen: UITextViewDelegate{
        
    func textViewDidChange(_ textView: UITextView) {
        self.checkAllRequiredValue()
    }
}
extension BugAndFixesScreen{
    //MARK: - BUG AND FIXES
    func doBugAndFixes(){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
                        Utility.showIndicator()
            let parameter = BugsAndFixesRequest(desc: whatIssueTextView.text ?? "")
        
            ProfileService.shared.bugAndFixes(parameters: parameter.toJSON(), imageData: videoAndImageData,videoURL: videoUrl) { (statusCode, response) in
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
    
    func compressVideo(url:URL){
            let data = NSData(contentsOf: url )
            print("File size before compression: \(Double(data!.count / 1048576)) mb")
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
            print(compressedURL)
        self.compressVideoAVFoundation(inputURL: url, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            switch session.status {
            case .unknown:
                print("unknown")
                break
            case .waiting:
                print("waiting")
                break
            case .exporting:
                print("exporting")
                break
            case .completed:
                self.videoUrl = compressedURL
            case .failed:
                print("failed")
                break
            case .cancelled:
                print("cancelled")
                break
            }
        }
    }
    
    func compressVideoAVFoundation(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
//MARK: - ImagePicker Delegate
extension BugAndFixesScreen :UINavigationControllerDelegate,UIImagePickerControllerDelegate{
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //FIXME:- AUDIO STOPPED WHEN PLAY PHOTOS VIDEO'S AUDIO
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.videoAndImageData = image.png(isOpaque: false)
            self.videoUrl = nil
        }else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            self.videoAndImageData = nil
            self.videoUrl = videoURL
            self.compressVideo(url: videoURL)
        }
        if let imagName = info[.imageURL] as? URL{
            self.displayImageViewName(name: imagName.lastPathComponent)
        }else if let videoName = info[.mediaURL] as? URL{
            self.displayImageViewName(name: videoName.lastPathComponent)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
