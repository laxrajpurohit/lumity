//
//  MessagService.swift
//  Tendask
//
//  Created by iroid on 15/03/21.
//

import Foundation
class MessageService {
    static let shared = { MessageService() }()
    
    func getChatUserList(parameters: [String: Any] = [:],url:String, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: url, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DELETE CHAT USER
    func getChatUser(id: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: deleteUserChatURL+"/\(id)", parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- GET MESASGE DETAIL
    func getChatDetail(url:String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString:url) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- GET MESASGE DETAIL
    func getChatCount( success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString:chatCountURL) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    func sendPhoto(parameters: [String: Any] = [:],imageData:Data, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestWithImage(urlString: sendAttachmentURL, imageParameterName: "attachment", images: imageData, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
//    func deleteUserChat(parameters: [String: Any] = [:],url:String, success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
//        APIClient.shared.requestAPIWithParameters(method: .post, urlString: url, parameters: parameters) { (statusCode, response) in
//            success(statusCode,response)
//        } failure: { (error) in
//            failure(error)
//        }
//    }
}
