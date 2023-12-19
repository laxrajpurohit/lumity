//
//  ResponseModel.swift
//  SportCoach
//
//  Created by iroid on 01/01/21.
//

import Foundation
import ObjectMapper
import SDWebImageLinkPlugin

class LoginResponse: Mappable{
    var user_id: Int?
    var first_name: String?
    var full_name:String?
    var last_name: String?
    var headline: String?
    var country_code:String?
    var phone_no:String?
    var url: String?
    var bio: String?
    var email: String?
    var profile_pic: String?
    var is_login_first_time:Bool?
    var interest: String?
    var interest_type:Int?
    var join_status: Int?
    var is_social:Bool?
    var mylibrary_public_count: Int?
    var auth : Auth?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        headline <- map["headline"]
        country_code <- map["country_code"]
        phone_no <- map["phone_no"]
        url <- map["url"]
        bio <- map["bio"]
        email <- map["email"]
        profile_pic <- map["profile_pic"]
        is_login_first_time <- map["is_login_first_time"]
        interest <- map["interest"]
        interest_type <- map["interest_type"]
        join_status <- map["join_status"]
        full_name <- map["full_name"]
        is_social <- map["is_social"]
        mylibrary_public_count <- map["mylibrary_public_count"]
        auth <- map["auth"]
    }
}

class Auth: Mappable {
    var tokenType: String?
    var accessToken: String?
    var refreshToken: String?
    var expiresIn: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tokenType <- map["tokenType"]
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
        expiresIn <- map["expiresIn"]
    }
}
class InterestsListData: Mappable {
    var interest_id: Int?
    var name: String?
    var image: String?
    
    init(interest_id: Int?,name: String?) {
        self.interest_id = interest_id
        self.name = name
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        interest_id <- map["interest_id"]
        name <- map["name"]
        image <- map["image"]
    }
}
class UserInterestList: Mappable{
    var user_id: Int?
    var first_name: String?
    var last_name: String?
    var bio: String?
    var email: String?
    var profile_pic: String?
    var interest: String?
    var interest_type: Int?
    var join_status: Int?
    var headline: String?
    var is_online:Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        bio <- map["bio"]
        email <- map["email"]
        profile_pic <- map["profile_pic"]
        interest <- map["interest"]
        interest_type <- map["interest_type"]
        join_status <- map["join_status"]
        headline <- map["headline"]
    }
}

class MemberCountData: Mappable{
    var groupMembersCount: Int?
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        groupMembersCount <- map["groupMembersCount"]
    }
}

class PostTypeModel: Mappable{
    var postType: Int?
    var title: String?
    var image: String?
    var isSelected:Bool?
    init(postType: Int?,title: String?,image: String?,isSelected:Bool?) {
        self.postType =  postType
        self.title = title
        self.image = image
        self.isSelected = isSelected
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        postType <- map["postType: 3,"]
        title <- map["title"]
        image <- map["image"]
        isSelected <- map["isSelected"]
    }
}
class PostReponse: Mappable{
    var id: Int?
    var user_id: Int?
    var title: String?
    var author: String?
    var link: String?
    var media: String?
    var media_url: String?
    var rate: Int?
    var caption: String?
    var post_type: Int?
    var is_report: Bool?
    var is_like: Bool?
    var is_comment: Bool?
    var hashtag: String?
    var interest: [String]?
    var is_saved: Int?
    var user_is_saved:Int?
    var user_is_complete:Int?
    var is_complete: Int?
    var created_at: Int?
    var userDetails: LoginResponse?
    var path: String?
    var per_page: Int?
    var to: Int?
    var total: Int?
    var reshare_count:Int?
    var like_count:Int?
    var comment_count:Int?
    var linkMeta: LPLinkMetadata?
    var reshare: Bool?
    var reshareReadMore: Bool = true
    var reshareUserDetails: LoginResponse?
    var reshare_caption: String?
    var reshare_createdat: Int?
    var reshare_main_post_id: Int?
    
    var mylibrary_id: Int?
    var mylibrary_post_id: Int?
    var position: Int?
    var localImagePath: String?
    var groupPostId:Int?
    var pin:Int?
    var is_public_post: Int?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        title <- map["title"]
        author <- map["author"]
        link <- map["link"]
        media <- map["media"]
        media_url <- map["media_url"]
        rate <- map["rate"]
        caption <- map["caption"]
        post_type <- map["post_type"]
        is_report <- map["is_report"]
        is_like <- map["is_like"]
        is_comment <- map["is_comment"]
        hashtag <- map["hashtag"]
        interest <- map["interest"]
        is_saved <- map["is_saved"]
        is_complete <- map["is_complete"]
        user_is_saved <- map["user_is_saved"]
        user_is_complete <- map["user_is_complete"]
        created_at <- map["created_at"]
        userDetails <- map["userDetails"]
        path <- map["path"]
        per_page <- map["per_page"]
        to <- map["to"]
        total <- map["total"]
        like_count <- map["like_count"]
        comment_count <- map["comment_count"]
        reshare_count <- map["reshare_count"]
        linkMeta <- map["linkMeta"]
        reshare <- map["reshare"]
        reshareReadMore <- map["reshareReadMore"]
        reshareUserDetails <- map["reshareUserDetails"]
        reshare_caption <- map["reshare_caption"]
        reshare_createdat <- map["reshare_createdat"]
        reshare_main_post_id <- map["reshare_main_post_id"]
        
        mylibrary_id <- map["mylibrary_id"]
        mylibrary_post_id <- map["mylibrary_post_id"]
        position <- map["position"]
        localImagePath <- map["localImagePath"]
        groupPostId <- map["group_post_id"]
        pin <- map["pin"]
        is_public_post <- map["is_public_post"]
    }
}

class PostCommentReponse: Mappable{
    var id: Int?
    var user_id: Int?
    var title: String?
    var username: String?
    var post_id:Int?
    var comment: String?
    var created_at:Int?
    var comment_count:Int?
    var like_count:Int?
    var is_like:Bool?
    var userDetails: LoginResponse?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        title <- map["title"]
        username <- map["username"]
        post_id <- map["post_id"]
        comment <- map["comment"]
        userDetails <- map["userDetails"]
        created_at <- map["created_at"]
        comment_count <- map["comment_count"]
        like_count <- map["like_count"]
        is_like <- map["is_like"]
    }
}

class Meta: Mappable{
    var current_page: Int?
    var from: Int?
    var last_page: Int?
    var links: [Link]?
    var path: String?
    var per_page: Int?
    var to: Int?
    var total: Int?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        current_page <- map["current_page"]
        from <- map["from"]
        last_page <- map["last_page"]
        links <- map["links"]
        path <- map["path"]
        per_page <- map["per_page"]
        to <- map["to"]
        total <- map["total"]
    }
}
class Link: Mappable{
    var url: String?
    var label: String?
    var active: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        label <- map["label"]
        active <- map["active"]
    }
}
class Links: Mappable{
    var first: String?
    var last: String?
    var prev: String?
    var next: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        first <- map["first"]
        last <- map["last"]
        prev <- map["prev"]
        next <- map["next"]
    }
}
class ReportTitleModel: Mappable{
    var title: String?
    init(title: String?) {
        self.title = title
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
    }
}
class MyLibraryListResponse: Mappable{
    var id: Int?
    var name: String?
    var image:String?
    var is_private:Int?
    var user_id:Int?
    var postDetails: PostReponse?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        user_id <- map["user_id"]
        image <- map["image"]
        postDetails <- map["postDetails"]
        is_private <- map["is_private"]
    }
}

class NotificationSettingResponse: Mappable{
    var user_id: Int?
    var daily_motion: Bool?
    var reminder_app:Bool?
    var new_message: Bool?
    var like_post: Bool?
    var comment_post:Bool?
    var shares_post: Bool?
    var tagged_post: Bool?
    var new_member_community:Bool?
    var saved_post: Bool?
    var marked_post: Bool?
    var group_like_post: Bool?
    var group_comment_post: Bool?
    var group_share_post: Bool?
    var group_saved_post: Bool?
    var group_completed_post: Bool?
    var group_new_member: Bool?
    var group_new_post: Bool?
    var group_added_you:Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        daily_motion <- map["daily_motion"]
        reminder_app <- map["reminder_app"]
        new_message <- map["new_message"]
        like_post <- map["like_post"]
        comment_post <- map["comment_post"]
        shares_post <- map["shares_post"]
        tagged_post <- map["tagged_post"]
        new_member_community <- map["new_member_community"]
        saved_post <- map["saved_post"]
        marked_post <- map["marked_post"]
        group_like_post <- map["group_like_post"]
        group_comment_post <- map["group_comment_post"]
        group_share_post <- map["group_share_post"]
        group_saved_post <- map["group_saved_post"]
        group_completed_post <- map["group_completed_post"]
        group_new_member <- map["group_new_member"]
        group_new_post <- map["group_new_post"]
        group_added_you <- map["group_added_you"]
        
    }
}

class BlockUserResponse: Mappable{
    var user_id: Int?
    var first_name: String?
    var last_name:String?
    var created_at: Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        created_at <- map["created_at"]
        
    }
}
class SyncContact: Mappable {
    var full_name: String?
    var phone_number: String?
    
    init(full_name: String?,phone_number: String?) {
        self.full_name = full_name
        self.phone_number = phone_number
    }
    
    required init?(map: Map) {
        
    }
    // Mappable
    func mapping(map: Map) {
        full_name    <- map["full_name"]
        phone_number <- map["phone_number"]
        
    }
}
class ChatListData: Mappable{
    var unseen_message:Int?
    var message:String?
    var is_online:Bool?
    var is_seen:Int?
    var last_seen:Int?
    var time:Int?
    var type:Int?
    var user:LoginResponse?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        unseen_message <- map["unseen_message"]
        user <- map["user"]
        message <- map["message"]
        is_online <- map["is_online"]
        is_seen <- map["is_seen"]
        last_seen <- map["last_seen"]
        time <- map["time"]
        type <- map["type"]
    }
}

class UserdetailData: Mappable{
    var id:Int?
    var first_name:String?
    var last_name:String?
    var profile_pic:String?
    var is_online:Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        is_online <- map["is_online"]
        profile_pic <- map["profile_pic"]
    }
}
class MessageData: Mappable{
    var id:Int?
    var senderId:Int?
    var receiverId:Int?
    var type:Int?
    var message:String?
    var createdAt:Int?
    var seen:Int?
    var postDetails:PostReponse?
    var mylibraryDetails:MyLibraryListResponse?
    init(id:Int?,senderId:Int?,receiverId:Int?,type:Int?,message:String?,createdAt:Int?,seen:Int?, postDetails:PostReponse?,mylibraryDetails:MyLibraryListResponse?) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.type = type
        self.message = message
        self.createdAt = createdAt
        self.seen = seen
        self.postDetails =  postDetails
        self.mylibraryDetails = mylibraryDetails
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        senderId <- map["senderId"]
        receiverId <- map["receiverId"]
        type <- map["type"]
        message <- map["message"]
        createdAt <- map["createdAt"]
        seen <- map["seen"]
        postDetails <- map["postDetails"]
        mylibraryDetails <- map["mylibraryDetails"]
        
    }
}
class SectionMessageData: Mappable{
    var headerInterVal: Int?
    var headerDate:String?
    var messageData:[MessageData]?
    init(headerInterVal: Int? = nil,headerDate:String,messageData:[MessageData]) {
        self.headerInterVal = headerInterVal
        self.headerDate = headerDate
        self.messageData = messageData
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        headerInterVal <- map["headerInterVal"]
        headerDate <- map["headerDate"]
        messageData <- map["messageData"]
      
    }
}

class NotificationResponse: Mappable{
    var id: Int?
    var user_id: Int?
    var notification_user_id: Int?
    var notification_user_detail: NotificationUserDetails?
    var post_id: Int?
    var post_details: PostReponse?
    var message: String?
    var type: Int?
    var is_join: Int?
    var created_at: Int?
    var group_id: Int?
    var group_post_id: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        notification_user_id <- map["notification_user_id"]
        notification_user_detail <- map["notification_user_detail"]
        post_id <- map["post_id"]
        post_details <- map["post_details"]
        message <- map["message"]
        type <- map["type"]
        is_join <- map["is_join"]
        created_at <- map["created_at"]
        group_id <- map["group_id"]
        group_post_id <- map["group_post_id"]
    }
}

class NotificationUserDetails: Mappable{
    var user_id: Int?
    var first_name: String?
    var last_name: String?
    var headline: String?
    var url: String?
    var bio: String?
    var email: String?
    var is_social: Int?
    var profile_pic: String?
    var interest: String?
    var interest_type: Int?
    var is_login_first_time: Bool?
    var join_status: Int?
    var mylibrary_public_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        headline <- map["headline"]
        url <- map["url"]
        bio <- map["bio"]
        email <- map["email"]
        is_social <- map["is_social"]
        profile_pic <- map["profile_pic"]
        interest <- map["interest"]
        interest_type <- map["interest_type"]
        is_login_first_time <- map["is_login_first_time"]
        join_status <- map["join_status"]
        mylibrary_public_count <- map["mylibrary_public_count"]
    }
}
class ChatAttachmentData: Mappable{
    var sender_id:Int?
    var receiver_id:Int?
    var message_type:Int?
    var message:String?
    var type:Int?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        message_type <- map["message_type"]
        message <- map["message"]
        type <- map["type"]
    }
}

class MessageCountData:Mappable{
    var count:Int?
    var notification_count:Int?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        count <- map["count"]
        notification_count <-  map["notification_count"]
    }
}
class CommentResponse: Mappable{
    var group_post_comment_id: Int?
    var group_post_id: Int?
    var id: Int?
    var user_id: Int?
    var username: String?
    var post_id:Int?
    var comment: String?
    var is_like:Bool?
    var like_count:Int?
    var created_at:Int?
    var userDetails: LoginResponse?
    
    var repliesCount: Int?
    var replies: [CommentResponse]?
        
    var replayId : Int?
    var isMore: Bool? = false
    
    var comment_count: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_comment_id <- map["group_post_comment_id"]
        group_post_id <- map["group_post_id"]
        
        id <- map["id"]
        user_id <- map["user_id"]
        username <- map["username"]
        post_id <- map["post_id"]
        comment <- map["comment"]
        is_like <- map["is_like"]
        like_count <- map["like_count"]
        created_at <- map["created_at"]
        userDetails <- map["userDetails"]
        
        repliesCount <- map["repliesCount"]
        replies <- map["replies"]
        
        replayId <- map["replayId"]
        isMore <- map["isMore"]
        
        comment_count <- map["comment_count"]
    }
}
class AppVersionResponse: Mappable {
    var current_version: String?
    var new_version:String?
    var is_update:Bool?
    var message:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        current_version <- map["current_version"]
        new_version <- map["new_version"]
        is_update <- map["is_update"]
        message <- map["message"]
    }
}
class CommentCountResponse: Mappable{
    var comment_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment_count <- map["comment_count"]
        
    }
}
class TempMessageData: Mappable{
    var headerKey: String?
    var headerDate: Date?
    var messageData:[MessageData]?
    init(headerKey: String?,headerDate:Date,messageData:[MessageData]?) {
        self.headerKey = headerKey
        self.headerDate = headerDate
        self.messageData = messageData
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        headerKey <- map["headerKey"]
        headerDate <- map["headerDate"]
        messageData <- map["messageData"]
      
    }
}

class GroupListData: Mappable {

    var groupId: Int?
    var name: String?
    var bio: String?
    var profile: String?
    var isPublic: Int?
    var isCreatedByMe:Int?
    var groupMembersCount:Int?
    var isJoin:Int?
    var groupMembers: [UserInterestList]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        groupId <- map["group_id"]
        name <- map["name"]
        bio <- map["bio"]
        profile <- map["profile"]
        profile <- map["profile"]
        isPublic <- map["is_public"]
        groupMembersCount <- map["group_members_count"]
        groupMembers <- map["group_members"]
        isCreatedByMe <- map["is_created_by_me"]
        isJoin <- map["is_join"]
    }
}

//class GroupMembers: Mappable {
//
//    var userId: NSNumber?
//    var firstName: String?
//    var lastName: String?
//    var headline: String?
//    var url: String?
//    var bio: Any?
//    var email: Any?
//    var isSocial: NSNumber?
//    var profilePic: String?
//    var interest: String?
//    var interestType: NSNumber?
//    var isLoginFirstTime: Bool?
//    var joinStatus: NSNumber?
//    var mylibraryPublicCount: NSNumber?
//
//    required init?(map: Map){
//    }
//
//    func mapping(map: Map) {
//        userId <- map["user_id"]
//        firstName <- map["first_name"]
//        lastName <- map["last_name"]
//        headline <- map["headline"]
//        url <- map["url"]
//        bio <- map["bio"]
//        email <- map["email"]
//        isSocial <- map["is_social"]
//        profilePic <- map["profile_pic"]
//        interest <- map["interest"]
//        interestType <- map["interest_type"]
//        isLoginFirstTime <- map["is_login_first_time"]
//        joinStatus <- map["join_status"]
//        mylibraryPublicCount <- map["mylibrary_public_count"]
//    }
//}


