//
//  PresignedImageCacheHelper.swift
//  SportCoach
//
//  Created by iroid on 25/05/21.
//

import Foundation
import SDWebImage

struct PresignedImageCacheHelper{
    
    //MARK:- CACHE IMAGE FILE
    static func downloadPresignedImage(fileName: String,imageURL: String){
        let imageName = fileName.split{$0 == "/"}.map(String.init).last ?? ""
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.isHidden = true
        appDelegate.window?.addSubview(imageView)
        imageView.sd_setImage(with: URL(string: imageURL)!) { (image, error, cacheType, url) in
            if let img = image{
                if self.getFileFromDocumentDirectory(fileName: imageName) == nil{
                    self.saveImageAndGetPath(fileName: imageName, image: img)
                }
            }
        }
    }
    
    //MARK:- CHECK FILE AVAILABLE IN DOCUMENT DIRECTORY
    static func checkPresignedImageFromDocFile(fileName: String) -> String?{
        if let file = self.getFileFromDocumentDirectory(fileName: fileName){
            return file
        }
        return nil
    }
    
    //MARK:- SAVE IMAGE IN DOCUMENT DIRECTORY
    static func saveImageAndGetPath(fileName: String,image: UIImage) {//-> String{
        let fileManager = FileManager.default
        let imageName = fileName
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = image
        let imageData = image.jpegData(compressionQuality: 0.3)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//        return paths
    }
    
    static func getFileFromDocumentDirectory(fileName: String) -> String?{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return URL(fileURLWithPath: filePath).absoluteString
        } else {
            return nil
        }
    }
    
    //MARK:- GET IMAGE FROM PROFILE FOLDER
    func getImageFromURL(fileName : String,fileURL: String,completion: @escaping(_ error: String?,_ imageURL: String?) -> Void){
        if let fileURL = PresignedImageCacheHelper.checkPresignedImageFromDocFile(fileName: fileName){
            completion(nil,fileURL)
        }else{
            PresignedImageCacheHelper.downloadPresignedImage(fileName: fileName, imageURL: fileURL)
            completion(nil,nil)
        }
    }
    
    //MARK:- CACHE IMAGE FILE
    static func downloadAndReturnPresignedImage(fileName: String,imageURL: String,completion: @escaping(_ error: String?,_ filURL: String?) -> Void){
        let imageName = fileName.split{$0 == "/"}.map(String.init).last ?? ""
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.isHidden = true
        appDelegate.window?.addSubview(imageView)
        imageView.sd_setImage(with: URL(string: imageURL)!) { (image, error, cacheType, url) in
            if let img = image{
                if let localURL = self.getFileFromDocumentDirectory(fileName: imageName){
                    completion(nil, localURL)
                }else{
                    self.saveImageAndGetPath(fileName: imageName, image: img)
                    if let file = self.getFileFromDocumentDirectory(fileName: fileName){
                        completion(nil, file)
                    }else{
                        completion("Something Went wrong", nil)
                    }
                }
            }else{
                completion("Something Went wrong", nil)
            }
        }
    }
}
extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
