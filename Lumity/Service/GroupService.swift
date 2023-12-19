//
//  GroupService.swift
//  Lumity
//
//  Created by iMac on 10/10/22.
//

import Foundation
class GroupService {
    static let shared = { GroupService() }()
    
    //MARK:- CREATE GROUP
    func createGroup(parameters: [String: Any] = [:],imageData: Data?,success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestWithImage(urlString: createGroupURL, imageParameterName: "profile", images: imageData,videoURL: nil, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    //MARK:- GROUP LIST
    func groupList(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: groupListURL+"\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK: - GROUP DETAILS
    func groupDetail(url:String, success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString:url) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK: - REMOVE USER FROM GROUP
    func removeUserFromGroup(url:String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: url, parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DO LIKE POST
    func doJoinGroup(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: joinGroupURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GROUP LIST
    func groupUserList(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: groupUserListURL+"\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }

}
