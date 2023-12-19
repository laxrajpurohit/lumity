//
//  MyLibraryService.swift
//  Source-App
//
//  Created by Nikunj on 26/04/21.
//

import Foundation
class MyLibraryService {
    static let shared = { MyLibraryService() }()
    
    //MARK:- STATUS POST    
    func getStatusWisePost(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: getPostStatusWiseURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DELETE POST
    func deletePost(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: deletePostStatusWiseURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- CREATE PLAYLIST & STORE POST
    func createPlaylistStorePost(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibraryStoreURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- MYLIBRARY LIST
    func myLibraryList(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibrayListURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- MYLIBRARY POST
    func myLibraryPostList(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibraryPostURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- OTHER USER LIBRARY LIST
    func otherUserLibraryList(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: otherUserLibrayListURL+"\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- CUTOME POST API
    func customePost(parameters: [String: Any] = [:],imageData: Data?,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestWithImage(urlString: myLibraryCustomePostURL, imageParameterName: "media", images: imageData, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    //MARK:- CUTOME POST EDIT API
    func editCustomePost(parameters: [String: Any] = [:],imageData: Data?,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestWithImage(urlString: myLibraryCustomePostEditURL, imageParameterName: "media", images: imageData, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DELETE CUSTOME POST DELETE
    func deleteCustomeAPI(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibraryCustomePostDeleteURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func editFolderTitleAPI(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibraryEditTitleURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }

    
    //MARK:- DELETE MYLIBRARY API
    func deleteMyLibraryAPI(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: myLibraryDeleteURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- SAVE COMPLETED / SAVE LATER
    func saveCompletedPost(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: saveMyLibraryPostURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- Save for later to complete post
    func saveForLaterToComplete(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: completedSaveForLaterURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
}
