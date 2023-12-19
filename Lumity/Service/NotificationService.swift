//
//  NotificationService.swift
//  Source-App
//
//  Created by Nikunj on 22/05/21.
//

import Foundation
class NotificationService {
    static let shared = { NotificationService() }()
    
    //MARK:- GET NOTIFICATION LIST
    func getNotifications(page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: notificationListURL+"?page=\(page)") { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET NOTIFICATION Click
    func notificationClick(notificationId: String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString: userNotificationListURL+"\(notificationId)") { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
