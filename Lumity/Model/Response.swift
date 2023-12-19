    //
//  Response.swift
//  SportCoach
//
//  Created by iroid on 01/01/21.
//

import Foundation
import ObjectMapper

class Response: Mappable{
    var success: Bool?
    var message: String?
    var loginResponse: LoginResponse?
    var interestsListData: [InterestsListData]?
    var userInterestListResponse: [UserInterestList]?
    var postListResponse: [PostReponse]?
    var postCommentReponse: [PostCommentReponse]?
    var chatListData:[ChatListData]?
    var postComment: PostCommentReponse?
    var postDetail: PostReponse?
    var notificationSettingResponse:NotificationSettingResponse?
    var myLibraryListResponse: [MyLibraryListResponse]?
    var blockUserResponse:[BlockUserResponse]?
    var notificationResponse: [NotificationResponse]?
    var messageData:[MessageData]?
    var chatAttachmentData:ChatAttachmentData?
    var links: Links?
    var userdetailData:UserdetailData?
    var meta: Meta?
    var messageCountData:MessageCountData?
    var commentResponse: [CommentResponse]?
    var groupListData:[GroupListData]?
    var groupDetailData:GroupListData?
    var groupUserList:[UserInterestList]?
    var postCommentResponse: CommentResponse?
    var appVersionResponse:AppVersionResponse?
    var comment_count: Int?
    var commentCountResponse: CommentCountResponse?
    var memberCountData:MemberCountData?
    var items:[YouTubeVideoData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        loginResponse <- map["data"]
        interestsListData <- map["data"]
        userInterestListResponse <- map["data"]
        links <- map["links"]
        meta <- map["meta"]
        postListResponse <- map["data"]
        postCommentReponse <- map["data"]
        postComment <- map["data"]
        postDetail <- map["data"]
        myLibraryListResponse <- map["data"]
        notificationSettingResponse <- map["data"]
        blockUserResponse <- map["data"]
        notificationResponse <- map["data"]
        chatListData <- map["data"]
        messageData <- map["data"]
        chatAttachmentData <- map["data"]
        messageCountData <- map["data"]
        userdetailData <- map["userdetail"]
        commentResponse <- map["data"]
        postCommentResponse <- map["data"]
        appVersionResponse <- map["data"]
        comment_count <- map["comment_count"]
        commentCountResponse <- map["data"]
        groupListData <- map["data"]
        groupDetailData <- map["data"]
        groupUserList <- map["data"]
        memberCountData <- map["data"]
        items <- map["items"]
    }
}
