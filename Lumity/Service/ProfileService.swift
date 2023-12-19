//
//  ProfileService.swift
//  Source-App
//
//  Created by Nikunj on 08/05/21.
//

import Foundation
class ProfileService {
    static let shared = { ProfileService() }()
    
    //MARK:- USER POST API
    func getUserPost(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myPostListURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- USER DETAIL API
    func getUserDetail(userId: Int,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: getUserProfileURL+"\(userId)") { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Change Email
    func changeEmail(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: changeEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Change Phone number
    func changePhoneNumber(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: changephoneNoURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Change Password
    func changePassword(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: changePasswordURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- USER DETAIL API
    func getNotificationData(success: @escaping (Int, NotificationSettingResponse?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: userNotificationURL) { (statusCode, response) in
            success(statusCode,response.notificationSettingResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- UPDATE NOTIFICATION PREFERENCES
    func updateNotificationPreferences(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: notificationSettingURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET BLOCK USER LIST
    func blockUserList(url:String,parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: url, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- EDIT USER PROFILE
    func editUserProfile(parameters: [String: Any] = [:],imageData: Data?,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestWithImage(urlString: updateUserProfileURL, imageParameterName: "profile_pic", images: imageData, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET LIKE POST
    func getLikePost(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: userLikePostList+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- BUG & FIXES API
    func bugAndFixes(parameters: [String: Any] = [:],imageData: Data?,videoURL: URL?,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestWithImage(urlString: bugsAndFixesURL, imageParameterName: "image", images: imageData, videoURL: videoURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { error in
            failure(error)
        }

        
    }
    
    //MARK:- FEEDBACK & SUGGECTIONS API
    func feedbackAndSuggection(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: feedBackAndSuggestionURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    //MARK:- USER COMMUNITY
    func userCommunity(parameters: [String: Any] = [:],page: Int,isFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isFromGroup == true ? groupUserCommunityURL+"\(page)":userCommunityURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET TOP FIVE POST
    func getTopFivePost(parameters: [String: Any] = [:],success: @escaping (Int, [PostReponse]?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: topFiveListURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.postListResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DELETE TOP FIVE POST
    func deleteTopFivePost(postID: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: deleteTop5Post+"\(postID)", parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- ADD TOP FIVE POST
    func addPostTopFive(parameters: [String: Any] = [:],success: @escaping (Int, [PostReponse]?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: saveTopFiveListURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.postListResponse)
        } failure: { (error) in
            failure(error)
        }
    }
}
