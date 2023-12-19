//
//  Constants.swift
//  Medics2you
//
//  Created by Techwin iMac-2 on 11/03/20.
//  Copyright © 2020 Techwin iMac-2. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import GoogleSignIn

let APP_NAME = "Lumity"

struct STORYBOARD {
    static let onBoarding = UIStoryboard(name: "OnBoarding", bundle: Bundle.main)
    static let menu = UIStoryboard(name: "Menu", bundle: Bundle.main)
    static let login = UIStoryboard(name: "Login", bundle: Bundle.main)
    static let home = UIStoryboard(name: "Home", bundle: Bundle.main)
    static let explore = UIStoryboard(name: "Explore", bundle: Bundle.main)
    static let notifications = UIStoryboard(name: "Notifications", bundle: Bundle.main)
    static let myLibrary = UIStoryboard(name: "MyLibrary", bundle: Bundle.main)
    static let profile = UIStoryboard(name: "Profile", bundle: Bundle.main)
    static let post = UIStoryboard(name: "Post", bundle: Bundle.main)
    static let changePassword = UIStoryboard(name: "ChangePassword", bundle: Bundle.main)
    static let register = UIStoryboard(name: "Register", bundle: Bundle.main)
    static let forgot = UIStoryboard(name: "Forgot", bundle: Bundle.main)
    static let payForParkDescription = UIStoryboard(name: "payForParkDescription", bundle: nil)
    static let auction = UIStoryboard(name: "Auction", bundle: Bundle.main)
    static let tabbar = UIStoryboard(name: "TabBar", bundle: Bundle.main)
    static let otp = UIStoryboard(name: "Otp", bundle: Bundle.main)
    static let webView = UIStoryboard(name: "WebView", bundle: Bundle.main)
    static let search = UIStoryboard(name: "Search", bundle: Bundle.main)
    static let setting = UIStoryboard(name: "Setting", bundle: Bundle.main)
    static let community = UIStoryboard(name: "Community", bundle: Bundle.main)
    static let notification = UIStoryboard(name: "Notification", bundle: Bundle.main)
    static let message =  UIStoryboard(name: "Message", bundle: Bundle.main)
    static let group =  UIStoryboard(name: "Group", bundle: Bundle.main)
    static let bookList =  UIStoryboard(name: "BookList", bundle: Bundle.main)
    
}

//MARK:- SocketIO


//Production URL
let SOCKET_URL = "http://54.85.79.78:7007/"
let server_url = "https://lummity.co/api/v1/"
//let server_url = "http://54.85.79.78/api/v1/"

//Development URL
//let SOCKET_URL = "http://3.220.136.81:7008/"
//let server_url = "http://3.220.136.81/api/v1/"


let loginURL = server_url+"login"
let intrestsURL = server_url+"interests-list"
let registerURL = server_url+"register"
let resetPasswordSendEmailURL = server_url+"reset-password/send-email"
//let verifyEmailURL = server_url+"user/otp/verify"
let verifyPhoneOrEmailURL = server_url+"user/otp/verify"
let resetPasswordEmailURL = server_url+"reset-password/change-password"
let socialLoginURL = server_url+"social-login"
let addInterestURL = server_url+"user/interests"
let userInterestListURL = server_url+"user/interests/list?page="
let addJoinURL = server_url+"user/join"
let postURL = server_url+"post/store"
let postUpdateURL = server_url+"post/update"
let postListURL = server_url+"post/list"
let userLikePostList = server_url+"user-like-post-list?page="
let postDetailURL = server_url+"post/"
let postCommentURL = server_url+"post/comment"
let deletePostComment = server_url+"comment/delete/"
let deleteTop5Post = server_url+"delete-top-five/"
let postLikeURL = server_url+"post/like/dislike"
let commentLikeDislikeURL = server_url + "comment/like/dislike"
let likeUserListURL = server_url+"like-user-list?page="
let doCommentURL = server_url+"post/comment/list?page="
let commentLikeListUrl = server_url+"like-comment-list?page="
let saveCompledPostUrl = server_url+"save-complate-post"
let logoutURL = server_url + "logout"
let postReportURL = server_url+"post/report"
let reportCommentURL = server_url+"report-comment"
let resharePostURL = server_url+"reshare-post"
let emailExistURL = server_url+"email-exists"
let getPostStatusWiseURL = server_url+"user/status/wise/post"
let deletePostStatusWiseURL = server_url+"user/status/wise/post/delete"
let myLibraryStoreURL = server_url+"mylibrary/store"
let myLibrayListURL = server_url+"mylibrary/list"
let otherUserLibrayListURL = server_url+"mylibrary/list?page="
let myLibraryPostURL = server_url+"mylibrary/posts"
let myLibraryCustomePostURL = server_url+"mylibrary-custom-posts"
let myLibraryCustomePostEditURL = server_url+"mylibrary-custom-posts-edit"
let myLibraryCustomePostDeleteURL = server_url+"mylibrary-custom-posts-delete"
let myLibraryEditTitleURL = server_url+"mylibrary/edit"
let changeEmailURL = server_url+"change/email"
let changephoneNoURL = server_url+"change/phoneno"
let changePasswordURL = server_url+"change-password"
let notificationSettingURL = server_url+"notification/setting"
let myPostListURL = server_url+"user/post/list"
let getUserProfileURL = server_url+"user/profile/"
let myLibraryDeleteURL = server_url+"mylibrary-delete"
let registerFotPusgURL = server_url+"save-for-push"
let inviteCodeRequestURL = server_url+"invite/code"
let verifyInviteCodeRequestURL = server_url+"verify/invite/code"
let userNotificationURL = server_url+"user/notification/setting"
let updateUserProfileURL = server_url+"user-update-profile"
let blockUserListURL = server_url+"user-block-list?page="
let bugsAndFixesURL = server_url+"bugs/fixes/store"
let feedBackAndSuggestionURL = server_url+"feedback/suggestion/store"
let userCommunityURL = server_url+"user/community"
let topFiveListURL = server_url+"top-five-list"
let saveTopFiveListURL = server_url+"save-top-five-list"
let deletePostURL = server_url+"post/delete"
let deleteUserChatURL = server_url+"chat/delete"
let chatCountURL = server_url+"chatcount"
let sendAttachmentURL = server_url+"send/attachment"
let chatDetailUrl = server_url+"messages/"
//let chatUserUrl = server_url+"chats?page="
let chatUserUrl = server_url+"chatlist?page="

let notificationListURL = server_url+"notification/list"
let userNotificationListURL = server_url+"user/notification/"
let removeAccountURL = server_url+"account-remove"
let saveMyLibraryPostURL = server_url+"mylibrary-save-complate-post"
let completedSaveForLaterURL = server_url+"save-forto-complate-post"

//MARK: COMMENT
let commentListURL = server_url+"post/comment/list"
let commentReplyURL = server_url+"post/comment/replay"
var replyListURL = server_url+"post/comment/replay/list"

//MARK: GROUP
let groupListURL = server_url+"group/list?page="
let createGroupURL = server_url+"group"
let groupDetailURL = server_url+"group/"
let removeUserFromGroupURL = server_url+"remove-user-group/"
let groupPostURL = server_url+"group/post"
let groupPostListURL = server_url+"group/post/list"
let groupPostDetailURL = server_url+"group/post/details/"
let postGroupCommentURL = server_url+"group/post/comment"
let groupUserListURL = server_url+"group/users/list?page="
let groupPostLikeURL = server_url+"group/post/like/dislike"
let groupResharePostURL = server_url+"group/reshare/post"
let groupSaveCompledPostUrl = server_url+"group/save/complate/post"
let groupPostCommentListURL = server_url+"group/post/comment/list"
let groupPostCommentReplyURL = server_url+"group/post/comment/replay"
let groupPostCommentReplyListURL = server_url+"group/post/comment/replay/list"
let joinGroupURL = server_url+"group/join"
let groupUserCommunityURL = server_url+"group/user/list?page="
let groupCommentLikeDislikeURL = server_url + "group/comment/like/dislike"
let groupDeletePostURL = server_url+"group/post"
let groupPostReportURL = server_url+"group/post/report"
let groupReportCommentURL = server_url+"group/comment/report"


let appVersion = server_url+"appversion"

let GOOGLE_CLIENT_ID = "705217604046-huhc4feomjnpdoflqr3ck8ajm9e41l7n.apps.googleusercontent.com"

//MARK:- Social Key
let EMAIL = "email"
let USER_IDD = "userid"
let USERNAME = "username"
let LAST_NAME = "lastName"
let SOCIAL_provider = "socail_provider"
let USER_DATA = "USER_DATA"

let FACEBOOK = "facebook"
let GOOGLE = "google"
let APPLE = "apple"

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let termConditionURL = "https://www.lumityapp.com/terms-of-service"
let privacyPolicyURL = "https://www.lumityapp.com/privacy-policy"
let tutorialURL = "https://www.lumityapp.com/how-it-works"

enum PostType: Int{
    case podcast = 1
    case video = 2
    case book = 3
    case artical = 4
    case reShare = 5
}

enum MessageNavigationType: Int{
    case homeScreen = 1
    case detailScreen = 2
    case shareDetailScreen = 3
    case exploreScreen = 4
    case myLibraryScreen = 5
    case profileScreen = 6
    case likeScreen = 7
    case newUserScreen = 8
}

enum PostWise: String{
    case saveForLater = "1"
    case completed = "2"
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


//let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (screenWidth / 2) - 25, y:(screenHeight / 2) - 25, width: 50, height: 50),type: .ballSpinFadeLoader, color: UIColor.black)

let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (screenWidth / 2) - 25, y:(screenHeight / 2) - 25, width: 50, height: 50),type: .ballSpinFadeLoader, color: UIColor.black)

//let linkLoadView = NVActivityIndicatorView(frame: CGRect(x: (screenWidth / 2) - 25, y:(screenHeight / 2) - 25, width: 50, height: 50),type: .ballClipRotateMultiple, color: UIColor.black)

//func createActivityView(view: UIView) -> NVActivityIndicatorView{
//    return NVActivityIndicatorView(frame: CGRect(x: (view.bounds.width / 2) - 25, y:(view.bounds.height  / 2) - 25, width: 50, height: 50),type: .ballSpinFadeLoader, color: UIColor.black)
//}

var intrestedListArray: [InterestsListData] = []


var topSafeArea: CGFloat{
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.safeAreaInsets.top ?? 0
    }
    return 0
}
var bottomSafeArea: CGFloat{
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
}


enum NotificationType : Int{
    case newMemberCommunity = 1
    case liked = 2
    case commented = 3
    case share = 4
    //    case tag = 5 | remaining
    case saveYourPost = 6
    case completeYourPost = 7
    case groupCreate = 11
    
    case groupPostCreate = 12
    case groupReSharePost = 13
    case groupSaveYourPost = 14
}

let linkTag = 1000

let signInConfig = GIDConfiguration.init(clientID: GOOGLE_CLIENT_ID)
let dummyText = "???-lumity-ios-app-id1565191495"


enum UploadType: Int{
    case book = 1
    case youTubeVideo = 2
    case youTubeChannel = 3
}
