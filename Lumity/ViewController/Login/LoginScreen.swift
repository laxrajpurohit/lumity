//
//  LoginScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit
import GoogleSignIn
class LoginScreen: UIViewController {

    //MARK: - OUTLET
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    var signUpObj : SignUpRequest?
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPrivacyPolicyTxt()
        self.setSignUpLabel()
        // Do any additional setup after loading the view.
    }
    
    func setPrivacyPolicyTxt(){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let string = "By continuing, you agree to Lumity’s Terms of Use and confirm that you have read Lumity’s Privacy Policy"
        let attributedString = NSMutableAttributedString(string: string,attributes: [NSAttributedString.Key.paragraphStyle : paragraph])
        
        let termConditionRange = (string as NSString).range(of: "Terms of Use")
        self.privacyPolicyTextView.textAlignment = NSTextAlignment.center
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font : UIFont(name: "Calibri", size: 14)!], range: (string as NSString).range(of: string))
        
        attributedString.addAttributes([NSAttributedString.Key.link : termConditionURL,NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 14)!,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: termConditionRange)
        
        let privacyPoilicyRange = (string as NSString).range(of: "Privacy Policy")
        
        attributedString.addAttributes([NSAttributedString.Key.link : privacyPolicyURL,NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 14)!,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: privacyPoilicyRange)

        self.privacyPolicyTextView.linkTextAttributes = [:]
//        self.privacyPolicyTextView.delegate = self
        self.privacyPolicyTextView.attributedText = attributedString
    }
    
    func setSignUpLabel(){
        let string = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString(string: string)
        let loginRange = (string as NSString).range(of: "Sign Up")
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Calibri-Bold", size: 18)!,NSAttributedString.Key.foregroundColor : Utility.getUIcolorfromHex(hex: "FF5C5C")], range: loginRange)
        self.signUpLabel.attributedText = attributedString
        self.signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.signUpScreen)))
        self.signUpLabel.isUserInteractionEnabled = true
    }
    
    
    @objc func signUpScreen(){
        for controller in self.navigationController!.viewControllers as Array {
              if controller is SignUpScreen {
                  self.navigationController!.popToViewController(controller, animated: true)
                  return
              }
          }
        
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchData(firtName:String,lastName:String,email:String,providerID:String,providerType:String){
        signUpObj = SignUpRequest(first_name: firtName, headline: nil, url: nil, last_name: lastName, bio: nil, email: email,country_code: nil,phone_no: nil, password: nil, password_confirmation: nil, provider_id: providerID, provider_type: providerType, invite_code: "")
    }
    func callRegisterForPushAPIAndSocket(){
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.connectSocket()
        appDelegate?.registerForPush()
    }
    
    //MARK: - ACTIONS
    @IBAction func onLoginEmail(_ sender: Any) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginEmailScreen") as! LoginEmailScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onLoginPhone(_ sender: Any) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginPhoneScreen") as! LoginPhoneScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        let loginManager = GoogleLoginManager()
        loginManager.handleGoogleLoginButtonTap(viewController: self)
        loginManager.delegate = self
    }
    @IBAction func onAppleLogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let loginManager = AppleLoginManager()
            loginManager.mainView = self.view
            loginManager.handleAuthorizationAppleIDButtonPress()
            loginManager.delegate = self
        } else {
            Utility.showAlert(vc: self, message: "Apple login not supported below iOS 13 OS.")
        }
    }
}
//MARK: - Google Login Delegate
extension LoginScreen: googleLoginManagerDelegate{
    func onGoogleLoginSuccess(user: GIDGoogleUser) {
        fetchData(firtName: user.profile?.givenName ?? "", lastName: user.profile?.familyName ?? "", email: user.profile?.email ?? "", providerID: user.userID ?? "", providerType: GOOGLE)
        let  data = SocialLoginRequest(provider_id: user.userID, provider_type: GOOGLE, first_name: user.profile?.givenName, last_name: user.profile?.familyName, email: user.profile?.email)
        self.socialLogin(data: data.toJSON())
    }
    
    func onGoogleLoginFailure(error: NSError) {
        Utility.showAlert(vc: self, message: error.localizedDescription)
    }
}
//MARK: - Social Login API
extension LoginScreen{
    func socialLogin(data: [String:Any]){
        self.view.endEditing(true)
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            LoginService.shared.socialLogin(parameters: data) { [weak self] (statusCode, response) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
                if let res = response{
                    print(res.toJSON())
//                    let data = SignUpRequest(first_name: res.first_name, headline: nil, url: nil, last_name: res.last_name, bio: nil, email: res.email, password: nil, password_confirmation: nil,provider_id:self?.signUpObj?.provider_id, provider_type: self?.signUpObj?.provider_type)
//                    let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileScreen
//                    vc.obj = data
                    if res.is_login_first_time == true || res.is_login_first_time == nil{
//                        vc.isFromSocial = true
                        Utility.showAlert(vc: self!, message: "An account with this login has not been created. Please create an account via the sign up process.")
                    }else{
                        //MARK:- OLD USER
//                        Utility.hideIndicator()
                        if let res = response{
                            Utility.saveUserData(data: res.toJSON())
                            self?.callRegisterForPushAPIAndSocket()
                            Utility.setTabRoot()
                        }
                    }
                }
            } failure: { [weak self] (error) in
                guard let stronSelf = self else { return }
                Utility.hideIndicator()
//                Utility.showAlert(vc: stronSelf, message: "User login Successfully")
                Utility.showAlert(vc: stronSelf, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
}
//MARK: - Apple login Delegate
extension LoginScreen: AppleLoginManagerDelegate{
    func onSuccess(result: NSDictionary) {
        print(result)
        let  data =  SocialLoginRequest(provider_id: (result.value(forKey: "userid") as? String) ?? "", provider_type: APPLE, first_name: (result.value(forKey: USERNAME) as? String) ?? "", last_name: (result.value(forKey: LAST_NAME) as? String) ?? "", email: (result.value(forKey: "email") as? String) ?? "")
        self.socialLogin(data: data.toJSON())
    }
    
    func onFailure(error: NSError) {
        Utility.showAlert(vc: self, message: error.localizedDescription)
    }
}