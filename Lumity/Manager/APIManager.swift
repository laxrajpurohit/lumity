//
//  APIManager.swift
//  SportCoach
//
//  Created by iroid on 01/01/21.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIClient {
    static let shared = {
        APIClient(baseURL: server_url)
    }()
    
    var baseURL: URL?
    
    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
    }
    
    func getHeader() -> HTTPHeaders {
        var headerDic: HTTPHeaders = [:]
        if Utility.getUserData() == nil{
            headerDic = [
                "Accept": "application/json"
            ]
        }else{
            if let accessToken = Utility.getAccessToken(){
                headerDic = [
                    "Authorization":"Bearer "+accessToken,
                    "Accept": "application/json"
                ]
            }else{
                headerDic = [
                    "Accept": "application/json"
                ]
            }
        }
        return headerDic
    }
    
    func requestAPIWithParameters(method: HTTPMethod,urlString: String,parameters: [String:Any],success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: getHeader()).responseObject { (response: DataResponse<Response>) in
            switch response.result{
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    failure(value.message ?? "")
                    return
                }
                if (200..<300).contains(statusCode){
                    success(statusCode,value)
                }else if statusCode == 401{
                    Utility.setLoginRoot()
                    Utility.removeLocalData()
                    failure(value.message ?? "")
                }else{
                    failure(value.message ?? "")
                }
                break
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }
        }
    }
    
    func requestAPIWithGetMethod(method: HTTPMethod,urlString: String,success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        Alamofire.request(urlString, method: method, parameters: nil, encoding: JSONEncoding.default, headers: getHeader()).responseObject { (response: DataResponse<Response>) in
            switch response.result{
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    failure(value.message ?? "")
                    return
                }
                if (200..<300).contains(statusCode){
                    success(statusCode,value)
                }else if statusCode == 401{
                    Utility.setLoginRoot()
                    Utility.removeLocalData()
                    failure(value.message ?? "")
                }else{
                    failure(value.message ?? "")
                }
                break
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }
        }
    }
    
    func requestWithImage(urlString: String,imageParameterName: String,images: Data?,videoURL: URL? = nil,parameters: [String:Any],success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            if let image = images{
                multipartFormData.append(image, withName: imageParameterName,fileName: UUID().uuidString+".jpg", mimeType: "image/jpg")
            }
            if let video = videoURL{
                do {
                    let data = try Data(contentsOf: video, options: .mappedIfSafe)
                    print(data)
                    multipartFormData.append(data, withName: imageParameterName, fileName: UUID().uuidString+".mp4", mimeType: "video/mp4")
                } catch  {
                }
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:urlString,method: .post,headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        if (200..<300).contains(statusCode){
                            success(statusCode,value)
                        }else if statusCode == 401{
                            Utility.setLoginRoot()
                            Utility.removeLocalData()
                            failure(value.message ?? "")
                        }else{
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    
    func requestWithImageOrVideo(urlString: String,imageParameterName: String,images: Data?,videoURL: URL? = nil,parameters: [String:Any],success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            if let image = images{
                multipartFormData.append(image, withName: imageParameterName,fileName: UUID().uuidString+".jpg", mimeType: "image/jpg")
            }
            if let video = videoURL{
                multipartFormData.append(video, withName: imageParameterName, fileName: UUID().uuidString+".mp4", mimeType: "video/mp4")
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:urlString,method: .post,headers:getHeader()){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseObject { (response: DataResponse<Response>) in
                    switch response.result{
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            failure(value.message ?? "")
                            return
                        }
                        if (200..<300).contains(statusCode){
                            success(statusCode,value)
                        }else if statusCode == 401{
                            Utility.setLoginRoot()
                            Utility.removeLocalData()
                            failure(value.message ?? "")
                        }else{
                            failure(value.message ?? "")
                        }
                        break
                    case .failure(let error):
                        failure(error.localizedDescription)
                        break
                    }
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    
    func requestAPIWithGetMethodForExternalAPI(method: HTTPMethod,urlString: String,success: @escaping(Int,Response) -> (),failure : @escaping(String) -> ()){
        Alamofire.request(urlString, method: method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<Response>) in
            switch response.result{
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    failure(value.message ?? "")
                    return
                }
                if (200..<300).contains(statusCode){
                    success(statusCode,value)
                }else if statusCode == 401{
                    Utility.setLoginRoot()
                    Utility.removeLocalData()
                    failure(value.message ?? "")
                }else{
                    failure(value.message ?? "")
                }
                break
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }
        }
    }
}
