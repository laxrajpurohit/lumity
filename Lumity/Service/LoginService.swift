//
//  LoginService.swift
//  SportCoach
//
//  Created by iroid on 06/01/21.
//

import Foundation
class LoginService {
    static let shared = { LoginService() }()
    
    //MARK:- LOGIN
    func login(parameters: [String: Any] = [:],success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: loginURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Vehicle Make List URL
    func getInterestsList(success: @escaping (Int, [InterestsListData]?) -> (), failure: @escaping (String) -> ()) {
//        if intrestedListArray.isEmpty {
            APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: intrestsURL) { (statusCode, response) in
                intrestedListArray = response.interestsListData ?? []
                success(statusCode,response.interestsListData)
            } failure: { (error) in
                failure(error)
            }
//        }else{
//            success(200,intrestedListArray)
//        }
    }
    
    //MARK:- REGISTER USER
    func registerUser(parameters: [String: Any] = [:],imageData: Data?,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        
        APIClient.shared.requestWithImage(urlString: registerURL, imageParameterName: "profile_pic", images: imageData,videoURL: nil, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Invite code request send
    func inviteCodeRequest(parameters: [String: Any] = [:],success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: inviteCodeRequestURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Invite code request send
    func verifyInviteCodeRequest(parameters: [String: Any] = [:],success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: verifyInviteCodeRequestURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Register for push
    func registerForPush(parameters: [String: Any] = [:],success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: registerFotPusgURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- FORGOT PASSWORD USER
    func resetPasswordSendEmail(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: resetPasswordSendEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- VERIFY PHONE NUMBER
    func verifyPhoneNumber(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: verifyPhoneOrEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- VERIFY PASSWORD USER
    func verifyEmail(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: verifyPhoneOrEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func resetPassword(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: resetPasswordEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- SOCIAL LOGIN
    func socialLogin(parameters: [String: Any] = [:],success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: socialLoginURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Logout
//    func logout(success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()) {
//        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: logoutURL) { (statusCode, response) in
//            success(statusCode,response)
//        } failure: { (error) in
//            failure(error)
//        }
//    }
    
    func logout(parameters: [String: Any] = [:],success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: logoutURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }

    //MARK:- ADD INTEREST
    func addInterest(parameters: [String: Any] = [:],success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: addInterestURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET INTEREST LIST URL
    func getUserInterestList(parameters: [String: Any] = [:],url:String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString:url, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- CHECK EMAIL EXISTS OR NOT
    func checkEmailIdExistsOrNot(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString:emailExistURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- ADD JOIN USER
    func addJoinUser(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: addJoinURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Chang eEmail
    func changeEmail(parameters: [String: Any] = [:],success: @escaping (Int, Response?) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: changeEmailURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- delete account URL
    func deleteUserAccount(success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: removeAccountURL, parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- APP VERSION
    func appVerion(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: appVersion, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
