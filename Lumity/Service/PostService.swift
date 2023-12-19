//
//  PostService.swift
//  Source-App
//
//  Created by Nikunj on 08/04/21.
//

import Foundation
class PostService{
    static let shared = { PostService() }()
    
    //MARK:- CREATE POST
    func createPost(parameters: [String: Any] = [:],imageData: Data?,videoURL: URL? = nil,isGroupPost:Bool? = false,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        let data = CreatePostRequest(JSON: parameters)
        if isGroupPost == true{
            APIClient.shared.requestWithImage(urlString: groupPostURL, imageParameterName: "media", images: imageData,videoURL: videoURL, parameters: parameters) { (statusCode, response) in
                success(statusCode,response.loginResponse)
            } failure: { (error) in
                failure(error)
            }
        }else{
            APIClient.shared.requestWithImage(urlString: data?.post_id == nil ? postURL : postUpdateURL, imageParameterName: "media", images: imageData,videoURL: videoURL, parameters: parameters) { (statusCode, response) in
                success(statusCode,response.loginResponse)
            } failure: { (error) in
                failure(error)
            }
        }
    }
    
    //MARK:- CREATE POST
    func createGroupPost(parameters: [String: Any] = [:],imageData: Data?,videoURL: URL? = nil,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        let data = CreatePostRequest(JSON: parameters)
        APIClient.shared.requestWithImage(urlString: data?.post_id == nil ? postURL : postUpdateURL, imageParameterName: "media", images: imageData,videoURL: videoURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- GET HOME POST
    func getAllPost(parameters: [String: Any] = [:],page: Int,isGroupPostList:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isGroupPostList == true ?  groupPostListURL+"?page=\(page)":postListURL+"?page=\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- GET POST DETAIL
    func getPostDetail(postId: Int? = nil,groupPostId:Int? = nil,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethod(method: .get, urlString:groupPostId == nil ? postDetailURL+"\(postId ?? 0)":groupPostDetailURL+"\(groupPostId ?? 0)") { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
  
    func getPostComment(parameters: [String: Any] = [:],page: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString:doCommentURL+"\(page)", parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    //MARK:- DO POST COMMENT
    func doCommentOnPost(parameters: [String: Any] = [:],success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: postCommentURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DELETE POST COMMENT
    func deleteCommentPost(comment_id: Int,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: deletePostComment+"\(comment_id)", parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DO LIKE POST
    func doLikeOnPost(parameters: [String: Any] = [:],isGroupLike:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isGroupLike == true ?  groupPostLikeURL : postLikeURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DO LIKE ON COMMENT POST
    func doLikeOnComment(parameters: [String: Any] = [:],iSFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: iSFromGroup == true ? groupCommentLikeDislikeURL:commentLikeDislikeURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- LIKE USER LIST
    func likeUserList(parameters: [String: Any] = [:],url:String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString:url, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- DO SAVE COMPLETED POST
    func doSaveCompletedPost(parameters: [String: Any] = [:],isFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isFromGroup == true ? groupSaveCompledPostUrl:saveCompledPostUrl, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- REPORT POST
    func reportPost(parameters: [String: Any] = [:],isFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isFromGroup == true ?  groupPostReportURL:postReportURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- REPORT COMMENT
    func reportComment(parameters: [String: Any] = [:],isFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isFromGroup == true ?  groupReportCommentURL:reportCommentURL , parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- RESHARE POST
    func resharePost(parameters: [String: Any] = [:],isFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isFromGroup == true ? groupResharePostURL:resharePostURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    
    //MARK:- DELETE POST
    func deletePost(id: Int,isGroup: Bool = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .delete, urlString: isGroup == true ? groupDeletePostURL+"/\(id)":deletePostURL+"/\(id)", parameters: [:]) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
   
    //MARK:- POST UPDATE
    func updatePost(parameters: [String: Any] = [:],imageData: Data?,videoURL: URL? = nil,success: @escaping (Int, LoginResponse?) -> (), failure: @escaping (String) -> ()) {
        APIClient.shared.requestWithImage(urlString: postURL, imageParameterName: "media", images: imageData,videoURL: videoURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response.loginResponse)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- COMMENT LIST
    func getPostComments(parameters: [String: Any] = [:],isGroup: Bool = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isGroup ? groupPostCommentListURL : commentListURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- REPLY
    func addReply(parameters: [String: Any] = [:],isGroup: Bool = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isGroup ? groupPostCommentReplyURL : commentReplyURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- COMMENT
    func addComment(parameters: [String: Any] = [:], iSFromGroup:Bool? = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: iSFromGroup == true ? postGroupCommentURL:postCommentURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    //MARK:- REPLY LIST
    func getPostReplys(parameters: [String: Any] = [:],isGroup: Bool = false,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithParameters(method: .post, urlString: isGroup ? groupPostCommentReplyListURL : replyListURL, parameters: parameters) { (statusCode, response) in
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }

    //MARK:- Search Youtube Video
    func searchYouTubeVideo(urlString:String,success: @escaping (Int, Response) -> (), failure: @escaping (String) -> ()){
        APIClient.shared.requestAPIWithGetMethodForExternalAPI(method: .get, urlString: urlString) { (statusCode, response) in
            success(statusCode, response)
            success(statusCode,response)
        } failure: { (error) in
            failure(error)
        }
    }

    
}
