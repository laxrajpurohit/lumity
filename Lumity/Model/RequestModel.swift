//
//  RequestModel.swift
//  SportCoach
//
//  Created by iroid on 01/01/21.
//

import Foundation
import ObjectMapper

class LoginRequest: Mappable{
    var country_code: String?
    var email: String?
    var password: String?
    
    init(country_code: String?,email: String?,password: String?) {
        self.country_code = country_code
        self.email = email
        self.password = password
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        country_code <- map["country_code"]
        email <- map["email"]
        password <- map["password"]
    }
}
class SignUpRequest: Mappable {
    var first_name: String?
    var last_name: String?
    var headline: String?
    var url: String?
    var bio:String?
    var email:String?
    var country_code: String?
    var phone_no: String?
    var password: String?
    var password_confirmation:String?
    var provider_id:String?
    var provider_type:String?
    var invite_code:String?
    init(first_name: String?,headline: String?,url: String?,last_name: String?,bio:String?,email:String?,country_code: String?,phone_no: String?,password: String?,password_confirmation:String?,provider_id:String?,provider_type:String?,invite_code:String?) {
        self.first_name = first_name
        self.last_name = last_name
        self.headline = headline
        self.url = url
        self.bio = bio
        self.email = email
        self.country_code = country_code
        self.phone_no = phone_no
        self.password = password
        self.password_confirmation = password_confirmation
        self.provider_id = provider_id
        self.provider_type = provider_type
        self.invite_code = invite_code
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        headline <- map["headline"]
        url <- map["url"]
        bio <- map["bio"]
        email <- map["email"]
        country_code <- map["country_code"]
        phone_no <- map["phone_no"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
        provider_id <- map["provider_id"]
        provider_type <- map["provider_type"]
        invite_code <- map["invite_code"]
    }
}

class ForgotPasswordEmailRequest: Mappable{
    var email: String?
    var country_code:String?
    
    init(email: String?,country_code: String?) {
        self.email = email
        self.country_code = country_code
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        country_code <- map["country_code"]
    }
}

class phoneOTPVerifyRequest: Mappable{
    var email: String?
    var country_code:String?
    var otp:String?
    
    init(email: String?,country_code: String?,otp:String?) {
        self.email = email
        self.country_code = country_code
        self.otp = otp
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        country_code <- map["country_code"]
        otp <- map["otp"]
    }
}

class OtpVerifyRequest: Mappable{
    var email: String?
    var otp: String?
    init(email: String?,otp: String?) {
        self.email = email
        self.otp = otp
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        otp <- map["otp"]
    }
}


class InviteCodeRequest: Mappable{
    var country_code: String?
    var name: String?
    var emailphone:String?
    
    init(country_code: String?,name: String?,emailphone:String?) {
        self.country_code = country_code
        self.name = name
        self.emailphone = emailphone
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        country_code <- map["country_code"]
        name <- map["name"]
        emailphone <- map["emailphone"]
    }
}

class VerifyInviteCodeRequest: Mappable{
    var country_code: String?
    var invite_code: String?
    var emailphone:String?
    
    init(country_code: String?,invite_code: String?,emailphone:String?) {
        self.country_code = country_code
        self.invite_code = invite_code
        self.emailphone = emailphone
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        country_code <- map["country_code"]
        invite_code <- map["invite_code"]
        emailphone <- map["emailphone"]
    }
}

class ChangePasswordRequest: Mappable{
    var email: String?
    var password: String?
    var password_confirmation: String?
    var country_code: String?
    init(email: String?,password: String?,password_confirmation: String?,country_code: String?) {
        self.email = email
        self.password = password
        self.password_confirmation = password_confirmation
        self.country_code = country_code
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
        country_code <- map["country_code"]
    }
}


class SocialLoginRequest: Mappable{
    var provider_id: String?
    var provider_type: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    init(provider_id: String?,provider_type: String?,first_name: String?,last_name: String?,email: String?) {
        self.provider_id = provider_id
        self.provider_type = provider_type
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        provider_id <- map["provider_id"]
        provider_type <- map["provider_type"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
    }
}
class LogoutRequest: Mappable{
    var deviceId: String?
    
    init(deviceId: String?) {
        self.deviceId = deviceId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        deviceId <- map["deviceId"]
    }
}
class AddInterestRequest: Mappable{
    var interest_id: String?
    
    init(interest_id: String?) {
        self.interest_id = interest_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        interest_id <- map["interest_id"]
    }
}
class AddJoinRequest: Mappable{
    var join_user_id: Int?
    var status: Int?
    
    init(join_user_id: Int?,status: Int?) {
        self.join_user_id = join_user_id
        self.status = status
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        join_user_id <- map["join_user_id"]
        status <- map["status"]
    }
}
class SearchCommunityRequest: Mappable{
    var explore: String?
    var username: String?
    var page:String?
    
    init(explore: String?,username: String?,page:String?) {
        self.explore = explore
        self.username = username
        self.page = page
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        explore <- map["explore"]
        username <- map["username"]
        page <- map["page"]
    }
}

class EmailExistRequest: Mappable{
    var country_code: String?
    var email: String?
  
    init(country_code: String?,email: String?) {
        self.country_code = country_code
        self.email = email
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        country_code <- map["country_code"]
        email <- map["email"]
    }
}

class CreatePostRequest: Mappable {
    var post_id: String?
    var post_type: String?
    var title: String?
    var author: String?
    var link: String?
    var media_url: String?
    var rate: String?
    var caption: String?
    var is_saved: String?
    var is_complete: String?
    var interest_id: String?
    var group_post_id:String?
    var group_id:String?
    var pin:String?
    var is_public_post: String?
    
    init(post_id: String?,post_type: String?,title: String?,author: String?,link: String?,media_url: String?,rate: String?,caption: String?,is_saved: String?,is_complete: String?,interest_id: String?, group_post_id:String?,group_id:String?,pin:String?,is_public_post: String?) {
        self.post_id = post_id
        self.post_type = post_type
        self.title = title
        self.author = author
        self.link = link
        self.media_url = media_url
        self.rate = rate
        self.caption = caption
        self.is_saved = is_saved
        self.is_complete = is_complete
        self.interest_id = interest_id
        self.group_post_id = group_post_id
        self.group_id = group_id
        self.pin = pin
        self.is_public_post = is_public_post
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        post_type <- map["post_type"]
        title <- map["title"]
        author <- map["author"]
        media_url <- map["media_url"]
        link <- map["link"]
        rate <- map["rate"]
        caption <- map["caption"]
        is_saved <- map["is_saved"]
        is_complete <- map["is_complete"]
        interest_id <- map["interest_id"] 
        group_post_id <- map["group_post_id"]
        group_id <- map["group_id"]
        pin <- map["pin"]
        is_public_post <- map["is_public_post"]
    }
}
class GetPostRequest: Mappable{
    var post_type: String?
    var search: String?
    var username: String?
    var explore:Int?
    var groupId:Int? = nil
    
    init(post_type: String?,search: String?,username: String?,explore: Int?,groupId:Int?) {
        self.post_type = post_type
        self.search = search
        self.username = username
        self.explore = explore
        self.groupId = groupId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_type <- map["post_type"]
        search <- map["search"]
        username <- map["username"]
        explore <- map["explore"]
        groupId <- map["group_id"]
    }
}


class doCommentRequest: Mappable{
    var post_id: Int?
    var comment: String?
    
    init(post_id: Int?,comment: String?) {
        self.post_id = post_id
        self.comment = comment
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        comment <- map["comment"]
    }
}

class doGroupCommentRequest: Mappable{
    var group_post_id: Int?
    var comment: String?
    
    init(group_post_id: Int?,comment: String?) {
        self.group_post_id = group_post_id
        self.comment = comment
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        comment <- map["comment"]
    }
}


class getCommentRequest: Mappable{
    var id: Int?
    var page: Int?
    
    init(id: Int?,page: Int?) {
        self.id = id
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        page <- map["page"]
    }
}

class doLikeRequest: Mappable{
    var group_post_id:Int?
    var post_id: Int?
    var islike: Int?
    
    init(post_id: Int?,islike: Int?,group_post_id:Int?) {
        self.group_post_id = group_post_id
        self.post_id = post_id
        self.islike = islike
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        islike <- map["islike"]
        group_post_id <- map["group_post_id"]
    }
}

//class doGroupLikeRequest: Mappable{
//    var group_post_id: Int?
//    var islike: Int?
//
//    init(group_post_id: Int?,islike: Int?) {
//        self.group_post_id = group_post_id
//        self.islike = islike
//    }
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        group_post_id <- map["group_post_id"]
//        islike <- map["islike"]
//    }
//}

class ChangeEmailRequest: Mappable{
    var email: String?
    
    init(email: String?) {
        self.email = email
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
    }
}

class ChangePhoneNumberRequest: Mappable{
    var country_code: String?
    var phone_no:String?
    init(country_code: String?,phone_no:String?) {
        self.country_code = country_code
        self.phone_no = phone_no
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        country_code <- map["country_code"]
        phone_no <- map["phone_no"]
    }
}



class ChangePasswordSettingRequest: Mappable{
    var current_password: String?
    var password: String?
    var password_confirmation:String?
    init(current_password: String?,password:String?,password_confirmation:String?) {
        self.current_password = current_password
        self.password = password
        self.password_confirmation = password_confirmation
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        current_password <- map["current_password"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
    }
}

class doCommentLikeRequest: Mappable{
    var comment_id: Int?
    var islike: Int?
    
    init(comment_id: Int?,islike: Int?) {
        self.comment_id = comment_id
        self.islike = islike
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment_id <- map["comment_id"]
        islike <- map["islike"]
    }
}


class getLikeList: Mappable{
    var post_id: Int?
    var page: Int?
    
    init(post_id: Int?,page: Int?) {
        self.post_id = post_id
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        page <- map["page"]
    }
}

class getCommentLikeList: Mappable{
    var comment_id: Int?
    var page: Int?
    
    init(comment_id: Int?,page: Int?) {
        self.comment_id = comment_id
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment_id <- map["comment_id"]
        page <- map["page"]
    }
}

class saveComplatePostRequest: Mappable{
    var post_id: Int?
    var is_saved: Int?
    var is_complete:Int?
    init(post_id: Int?,is_saved: Int?,is_complete:Int?) {
        self.post_id = post_id
        self.is_saved = is_saved
        self.is_complete = is_complete
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        is_saved <- map["is_saved"]
        is_complete <- map["is_complete"]
    }
}

class GroupsaveComplatePostRequest: Mappable{
    var group_post_id: Int?
    var is_saved: Int?
    var is_complete:Int?
    init(group_post_id: Int?,is_saved: Int?,is_complete:Int?) {
        self.group_post_id = group_post_id
        self.is_saved = is_saved
        self.is_complete = is_complete
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        is_saved <- map["is_saved"]
        is_complete <- map["is_complete"]
    }
}

class ReportPostRequest: Mappable{
    var post_id: Int?
    var message: String?
    
    init(post_id: Int?,message: String?) {
        self.post_id = post_id
        self.message = message
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        message <- map["message"]
    }
}
class ReportPostCommentRequest: Mappable{
    var comment_id: Int?
    var message: String?
    
    init(comment_id: Int?,message: String?) {
        self.comment_id = comment_id
        self.message = message
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment_id <- map["comment_id"]
        message <- map["message"]
    }
}

class ResharePostRequest: Mappable{
    var group_post_id: Int?
    var post_id: Int?
    var caption: String?
    var is_edit: Int?
    
    init(group_post_id: Int?,post_id: Int?,caption: String?,is_edit: Int?) {
        self.group_post_id = group_post_id
        self.post_id = post_id
        self.caption = caption
        self.is_edit = is_edit
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        post_id <- map["post_id"]
        caption <- map["caption"]
        is_edit <- map["is_edit"]
    }
}

class GroupResharePostRequest: Mappable{
    var group_post_id: Int?
    var caption: String?
    var is_edit: Int?
    
    init(group_post_id: Int?,caption: String?,is_edit: Int?) {
        self.group_post_id = group_post_id
        self.caption = caption
        self.is_edit = is_edit
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        caption <- map["caption"]
        is_edit <- map["is_edit"]
    }
}

class PasswordStrengthRequest: Mappable{
    var complete: Bool?
    var text: String?
    
    init(complete: Bool?,text: String?) {
        self.complete = complete
        self.text = text
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        complete <- map["complete"]
        text <- map["text"]
    }
    
    
}
class PostTypeRequest: Mappable{
    var status: String?
    var page: Int?
    var post_type: Int?
    var search: String?
    var mylibrary_id: Int?
    
    init(status: String?,page: Int?,post_type: Int?,search: String?,mylibrary_id: Int?) {
        self.status = status
        self.page = page
        self.post_type = post_type
        self.search = search
        self.mylibrary_id = mylibrary_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        page <- map["page"]
        post_type <- map["post_type"]
        search <- map["search"]
        mylibrary_id <- map["mylibrary_id"]
    }    
}
class DeletStatusPostRequest: Mappable{
    var status: String?
    var post_id: Int?
    
    init(status: String?,post_id: Int?) {
        self.status = status
        self.post_id = post_id
    }
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        post_id <- map["post_id"]
    }
}
class CreatePlayListStorePostRequest: Mappable{
    var name: String?
    var post_id: String?
    
    init(name: String?,post_id: String?) {
        self.name = name
        self.post_id = post_id
    }
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        post_id <- map["post_id"]
    }
}
class MyLibraryPostRequest: Mappable{
    var user_id: Int?
    var mylibrary_id: Int?
    var post_type: Int?
    var page: Int?
    var search: String?
    var isFromCompleted: Int?

    
    init(user_id: Int?,mylibrary_id: Int?,post_type: Int?,page: Int?,search: String?,isFromCompleted: Int?) {
        self.user_id = user_id
        self.mylibrary_id = mylibrary_id
        self.post_type = post_type
        self.page = page
        self.search = search
        self.isFromCompleted = isFromCompleted
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        mylibrary_id <- map["mylibrary_id"]
        post_type <- map["post_type"]
        page <- map["page"]
        search <- map["search"]
        isFromCompleted <- map["isFromCompleted"]
    }
}
class MyLibraryListRequest: Mappable{
    var page: Int?
    
    init(page: Int?) {
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
    }
}

class otherUserLibraryListRequest: Mappable{
    var page: Int?
    var user_id:Int?
    init(page: Int?,user_id:Int?) {
        self.page = page
        self.user_id = user_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        user_id <- map["user_id"]
    }
}
class MyLibraryCustomePostRequest: Mappable{
    var upload_type: String?
    var mylibrary_id: String?
    var post_id: String?
    var post_type: String?
    var title: String?
    var author: String?
    var link: String?
    var hashtag: String?
    var media_url: String?
    var rate: String?
    var caption: String?
    var isPublic: String?
    var isPrivate: String?
    var interest_id: String?
    
    init(upload_type: String?,mylibrary_id: String?,post_id: String?,post_type: String?,title: String?,author: String?,link: String?,hashtag: String?,media_url: String?,rate: String?,caption: String?,isPublic: String?,isPrivate: String?,interest_id: String?) {
        self.upload_type = upload_type
        self.mylibrary_id = mylibrary_id
        self.post_id = post_id
        self.post_type = post_type
        self.title = title
        self.author = author
        self.link = link
        self.hashtag = hashtag
        self.media_url = media_url
        self.rate = rate
        self.caption = caption
        self.isPublic = isPublic
        self.isPrivate = isPrivate
        self.interest_id = interest_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        upload_type <- map["upload_type"]
        mylibrary_id <- map["mylibrary_id"]
        post_id <- map["post_id"]
        post_type <- map["post_type"]
        title <- map["title"]
        author <- map["author"]
        link <- map["link"]
        hashtag <- map["hashtag"]
        media_url <- map["media_url"]
        rate <- map["rate"]
        caption <- map["caption"]
        isPublic <- map["isPublic"]
        isPrivate <- map["isPrivate"]
        interest_id <- map["interest_id"]
    }
}
class MyLibraryCustomePostEditRequest: Mappable{
    var mylibrary_post_id: String?
    var post_type: String?
    var title: String?
    var author: String?
    var link: String?
    var hashtag: String?
    var media_url: String?
    var rate: String?
    var caption: String?
    var isPublic: String?
    var isPrivate: String?
    var interest_id: String?
    
    init(mylibrary_post_id: String?,post_type: String?,title: String?,author: String?,link: String?,hashtag: String?,media_url: String?,rate: String?,caption: String?,isPublic: String?,isPrivate: String?,interest_id: String?) {
        self.mylibrary_post_id = mylibrary_post_id
        self.post_type = post_type
        self.title = title
        self.author = author
        self.link = link
        self.hashtag = hashtag
        self.media_url = media_url
        self.rate = rate
        self.caption = caption
        self.isPublic = isPublic
        self.isPrivate = isPrivate
        self.interest_id = interest_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mylibrary_post_id <- map["mylibrary_post_id"]
        post_type <- map["post_type"]
        title <- map["title"]
        post_type <- map["post_type"]
        author <- map["author"]
        link <- map["link"]
        hashtag <- map["hashtag"]
        media_url <- map["media_url"]
        rate <- map["rate"]
        caption <- map["caption"]
        isPublic <- map["isPublic"]
        isPrivate <- map["isPrivate"]
        interest_id <- map["interest_id"]
    }
}
class CustomePostDeleteRequest: Mappable{
    var mylibrary_id: Int?
    var mylibrary_post_id: Int?
    
    init(mylibrary_id: Int?,mylibrary_post_id: Int?) {
        self.mylibrary_id = mylibrary_id
        self.mylibrary_post_id = mylibrary_post_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mylibrary_id <- map["mylibrary_id"]
        mylibrary_post_id <- map["mylibrary_post_id"]
    }
}

class EditMyFolderRequest: Mappable{
    var mylibrary_id: Int?
    var name: String?
    var type:Int?
    init(mylibrary_id: Int?,name: String?,type:Int?) {
        self.mylibrary_id = mylibrary_id
        self.name = name
        self.type = type
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mylibrary_id <- map["mylibrary_id"]
        name <- map["name"]
        type <- map["type"]
    }
}
class MyLibraryDeleteRequest: Mappable{
    var mylibrary_id: Int?
    
    init(mylibrary_id: Int?) {
        self.mylibrary_id = mylibrary_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mylibrary_id <- map["mylibrary_id"]
    }
}
class SettingRequest: Mappable{
    var image: String?
    var title: String?
    
    init(image: String?,title: String?) {
        self.image = image
        self.title = title
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        title <- map["title"]
    }
}
class YourAccoutRequest: Mappable{
    var title: String?
    var subTitle: String?
    init(subTitle: String?,title: String?) {
        self.subTitle = subTitle
        self.title = title
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        subTitle <- map["subTitle"]
        title <- map["title"]
    }
}
class GetUserPostRequest: Mappable{
    var user_id: Int?
    var post_type: String?
    var search: String?
    var page: Int?
    
    init(user_id: Int?,post_type: String?,search: String?,page: Int?) {
        self.user_id = user_id
        self.post_type = post_type
        self.search = search
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        post_type <- map["post_type"]
        search <- map["search"]
        page <- map["page"]
    }
}
class RegisterForPushRequest: Mappable {
    var device_id: String?
    var device_type: String?
    var device_token: String?
    init(device_id: String?,device_type: String?,device_token: String?) {
        self.device_id = device_id
        self.device_type = device_type
        self.device_token = device_token
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        device_token <- map["device_token"]
    }
}
class NotificationRequest: Mappable {
    var daily_motion: String?
    var reminder_app: String?
    var new_message: String?
    var like_post: String?
    var comment_post: String?
    var shares_post: String?
    var tagged_post: String?
    var new_member_community: String?
    var saved_post: String?
    var marked_post: String?
    var group_like_post: String?
    var group_comment_post: String?
    var group_share_post: String?
    var group_saved_post: String?
    var group_completed_post: String?
    var group_new_member: String?
    var group_new_post: String?
    var group_added_you: String?
    
    init(daily_motion: String?,reminder_app: String?,new_message: String?,like_post: String?,comment_post: String?,shares_post: String?,tagged_post: String?,new_member_community: String?,saved_post: String?,marked_post: String?,group_like_post: String?,group_comment_post: String?, group_share_post: String?, group_saved_post: String?, group_completed_post: String?,group_new_member: String?, group_new_post: String?,group_added_you: String?) {
        self.daily_motion = daily_motion
        self.reminder_app = reminder_app
        self.new_message = new_message
        self.like_post = like_post
        self.comment_post = comment_post
        self.shares_post = shares_post
        self.tagged_post = tagged_post
        self.new_member_community = new_member_community
        self.saved_post = saved_post
        self.marked_post = marked_post
        self.group_like_post = group_like_post
        self.group_comment_post  = group_comment_post
        self.group_share_post = group_share_post
        self.group_saved_post = group_saved_post
        self.group_completed_post = group_completed_post
        self.group_new_member = group_new_member
        self.group_new_post = group_new_post
        self.group_added_you = group_added_you
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
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
class BlockUserListRequest: Mappable{
    var page: Int?
    
    init(page: Int?) {
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
    }
}
class UpdateProfileRequest: Mappable{
    var first_name: String?
    var last_name: String?
    var headline: String?
    var url: String?
    var bio: String?
    var interest_id: String?
    
    init(first_name: String?,last_name: String?,headline: String?,url: String?,bio: String?,interest_id: String?) {
        self.first_name = first_name
        self.last_name = last_name
        self.headline = headline
        self.url = url
        self.bio = bio
        self.interest_id = interest_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        headline <- map["headline"]
        url <- map["url"]
        bio <- map["bio"]
        interest_id <- map["interest_id"]
    }
}
class BugsAndFixesRequest: Mappable{
    var desc: String?
    
    init(desc: String?) {
        self.desc = desc
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        desc <- map["desc"]
    }
}

class FeedBackAndSuggestionRequest: Mappable{
    var about_source: String?
    var we_improve:String?
    var any_interest:String?
    
    init(about_source: String?,we_improve:String?,any_interest:String?) {
        self.about_source = about_source
        self.we_improve = we_improve
        self.any_interest = any_interest
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        about_source <- map["about_source"]
        we_improve <- map["we_improve"]
        any_interest <- map["any_interest"]
    }
}
class UserCommunityRequest: Mappable{
    var group_id:Int?
    var user_id: Int?
    var type: Int?
    var search: String?
    var page: Int?
    
    init(user_id: Int?,type: Int?,search: String?,page: Int?,group_id:Int?) {
        self.user_id = user_id
        self.type = type
        self.search = search
        self.page = page
        self.group_id = group_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        type <- map["type"]
        search <- map["search"]
        page <- map["page"]
        group_id <- map["group_id"]
    }
}



class TopFiveRequest: Mappable {
    var user_id: Int?
    var post_type: Int?
    
    
    init(user_id: Int?,post_type: Int?) {
        self.user_id = user_id
        self.post_type = post_type
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        post_type <- map["post_type"]
    }
}
class AddTopFiveCompletedRequest: Mappable{
    var data: String?
    var post_type: Int?

    
    init(data: String?,post_type: Int?) {
        self.data = data
        self.post_type = post_type
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        post_type <- map["post_type"]
    }
}
class AddTopFiveJsonRequest: Mappable{
    var post_id: String?
    var position: String?
    
    init(post_id: String?,position: String?) {
        self.post_id = post_id
        self.position = position
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        post_id <- map["post_id"]
        position <- map["position"]
    }
}
class UserChatRequest: Mappable {
    var search: String?
    init(search: String?) {
        self.search = search
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        search <- map["search"]
    }
}
class SendAttachment: Mappable {
    var receiver_id: String?
    var type:String?
    var post_id:String?
    init(receiver_id: String?,type: String?,post_id:String) {
        self.receiver_id = receiver_id
        self.type = type
        self.post_id = post_id
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        receiver_id <- map["receiver_id"]
        type <- map["type"]
        post_id <- map["post_id"]
    }
}

class MyLibraryCompletePostRequest: Mappable{
    var mylibrary_id: Int?
    var post_id: Int?
    var is_saved: Int?
    var is_complete:Int?
    
    init(mylibrary_id: Int?,post_id: Int?,is_saved: Int?,is_complete:Int?) {
        self.mylibrary_id = mylibrary_id
        self.post_id = post_id
        self.is_saved = is_saved
        self.is_complete = is_complete
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mylibrary_id <- map["mylibrary_id"]
        post_id <- map["post_id"]
        is_saved <- map["is_saved"]
        is_complete <- map["is_complete"]
    }
}
class SaveToCompletePostRequest: Mappable{
    var id: Int?
    var mylibrary_post_id: Int?
  
    
    init(id: Int?,mylibrary_post_id: Int?) {
        self.id = id
        self.mylibrary_post_id = mylibrary_post_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        mylibrary_post_id <- map["mylibrary_post_id"]
    }
}
class AddCommentRequest: Mappable{
    var group_post_id: Int?
    var post_id: Int?
    var comment: String?
    
    init(group_post_id: Int? = nil,post_id: Int?,comment: String?) {
        self.group_post_id = group_post_id
        self.post_id = post_id
        self.comment = comment
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        post_id <- map["post_id"]
        comment <- map["comment"]
    }
}
class GetCommentsRequest: Mappable{
    var group_post_id: Int?
    var id: Int?
    var prePage: Int?
    var lastId: Int?
    
    init(group_post_id: Int? = nil,id: Int?,prePage: Int?,lastId: Int?) {
        self.group_post_id = group_post_id
        self.id = id
        self.prePage = prePage
        self.lastId = lastId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_id <- map["group_post_id"]
        id <- map["id"]
        prePage <- map["prePage"]
        lastId <- map["lastId"]
    }
}
class ReplyRequest: Mappable{
    var group_post_comment_id: Int?
    var comment_id: Int?
    var comment: String?
    var replayId: Int?
    
    init(group_post_comment_id: Int? = nil,comment_id: Int?,comment: String?,replayId: Int?) {
        self.group_post_comment_id = group_post_comment_id
        self.comment_id = comment_id
        self.comment = comment
        self.replayId = replayId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_post_comment_id <- map["group_post_comment_id"]
        comment_id <- map["comment_id"]
        comment <- map["comment"]
        replayId <- map["replayId"]
    }
}
class AppVersionRequest: Mappable {
    var version: String?
    init(version: String?) {
        self.version = version
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        version <- map["version"]
    }
}
class DateTempRequest: Mappable{
    var tmpKey: String?
    var dateStr: Date?
    var tempVal: [MessageData]?
    
    init(tmpKey: String?,dateStr: Date?,tempVal: [MessageData]?) {
        self.tmpKey = tmpKey
        self.dateStr = dateStr
        self.tempVal = tempVal
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        tmpKey <- map["tmpKey"]
        dateStr <- map["dateStr"]
        tempVal <- map["tmpDate"]
    }
}

class CreateGroupRequest: Mappable {
    var group_id: String?
    var name: String?
    var bio:String?
    var user_ids:String?
    var is_public:String?
    init(group_id: String?,name: String?,bio:String?,user_ids:String?,is_public:String?) {
        self.group_id = group_id
        self.name = name
        self.bio = bio
        self.user_ids = user_ids
        self.is_public = is_public
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        name <- map["name"]
        bio <- map["bio"]
        user_ids <- map["user_ids"]
        is_public <- map["is_public"]
    }
}

class JoinGroupRequest: Mappable{
    var group_id: String?
    var user_id: String?
    
    init(group_id: String?,user_id: String?) {
        self.group_id = group_id
        self.user_id = user_id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        user_id <- map["user_id"]
    }
}

class GroupUserListRequest: Mappable{
    var group_id: String?
    var page: String?
    
    init(group_id: String?,page: String?) {
        self.group_id = group_id
        self.page = page
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        group_id <- map["group_id"]
        page <- map["page"]
    }
}

class GroupListRequest: Mappable{
    var is_public: String?
    var search: String?
    
    init(is_public: String?,search: String?) {
        self.is_public = is_public
        self.search = search
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        is_public <- map["is_public"]
        search <- map["search"]
    }
}
