//
//  TabBarScreen.swift
//  Source-App
//
//  Created by iroid on 31/03/21.
//

import UIKit

class TabBarScreen: UITabBarController,UITabBarControllerDelegate {
    
    // MARK: - OUTLETS
    @IBInspectable var onTopIndicator: Bool = true
    @IBInspectable var indicatorColor: UIColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    
    // MARK: - VARIABLE DECLARE
    var postTypeScreen:PostTypeScreen! = nil

    var completeAddNewPostDelegate: EnterNewPostDelegate?

    var isFromNotification = false
    var userId: Int?
    var homeVC: HomeScreen?
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabBar()
        // initial position
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - View Controller Life Cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Draw Indicator above the tab bar items
        guard let numberOfTabs = tabBar.items?.count else {
            return
        }
        
        let numberOfTabsFloat = CGFloat(numberOfTabs)
        let imageSize = CGSize(width: tabBar.frame.width / numberOfTabsFloat-30,
                               height: tabBar.frame.height)
        
        
        let indicatorImage = UIImage.drawTabBarIndicator(color: indicatorColor,
                                                         size: imageSize,
                                                         onTop: onTopIndicator)
        self.tabBar.selectionIndicatorImage = indicatorImage
    }
    func setUpTabBar(){
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.clipsToBounds = true
        self.tabBar.backgroundColor = .white
        
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        delegate = self
        //        self.delegate = self
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        
        
        self.homeVC =  STORYBOARD.home.instantiateViewController(withIdentifier: "HomeScreen") as? HomeScreen
        let HomeNavigationController = UINavigationController(rootViewController: self.homeVC!)
        self.homeVC?.superVC = self
        HomeNavigationController.isNavigationBarHidden = true
        HomeNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        let exploreScreen = STORYBOARD.explore.instantiateViewController(withIdentifier: "ExploreScreen") as! ExploreScreen
        let exploreNavigationController = UINavigationController(rootViewController: exploreScreen)
        exploreScreen.superVC = self
        exploreNavigationController.isNavigationBarHidden = true
        exploreNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        

        
        postTypeScreen =  STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as? PostTypeScreen
        let postTypeNavigationController = UINavigationController(rootViewController: postTypeScreen)
        postTypeNavigationController.isNavigationBarHidden = true
        postTypeNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        
        let notificationScreen = STORYBOARD.myLibrary.instantiateViewController(withIdentifier: "MyLibraryScreen") as! MyLibraryScreen
        let notificationNavigationController = UINavigationController(rootViewController: notificationScreen)
        notificationScreen.superVC = self
        notificationNavigationController.isNavigationBarHidden = true
        notificationNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        
        let profileScreen = STORYBOARD.profile.instantiateViewController(withIdentifier: "ProfileTabbarScreen") as! ProfileTabbarScreen
        profileScreen.superVC = self
        profileScreen.isHideBack = true
        profileScreen.userId = userId
        let profileNavigationController = UINavigationController(rootViewController: profileScreen)
        profileNavigationController.isNavigationBarHidden = true
        profileNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        viewControllers = [HomeNavigationController,exploreNavigationController,postTypeNavigationController,notificationNavigationController,profileNavigationController]
        
        self.tabBar.items![0].image = UIImage(named: "homeTabBarIcon")
        self.tabBar.items![0].selectedImage = UIImage(named: "home_selected_icon")
        self.tabBar.items![1].image = UIImage(named: "search_tabba_icon")
        self.tabBar.items![1].selectedImage = UIImage(named: "explore_selected_icon")
        self.tabBar.items![2].image = UIImage(named: "add_icon")
        self.tabBar.items![2].selectedImage = UIImage(named: "add_icon")
        self.tabBar.items![3].image = UIImage(named: "tab_my_Library_icon")
        self.tabBar.items![3].selectedImage = UIImage(named: "tab_my_Library_icon")
        self.tabBar.items![4].image = UIImage(named: "user_tabbar_icon")
        self.tabBar.items![4].selectedImage = UIImage(named: "profile_selected_icon")
        
        self.tabBar.items![0].title = "Home"
        self.tabBar.items![1].title = "Explore"
        self.tabBar.items![2].title = "Post"
        self.tabBar.items![3].title = "My Library"
        self.tabBar.items![4].title = "Profile"
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                self.tabBar.items?[i].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
        if let userId = userId{
            self.selectedIndex = 4
        }
    }
    
    var previousController: UIViewController?
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //when user is in FeedViewController and scroll at last record and want to
        if previousController == viewController {
            if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? HomeScreen {
                
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.scrollToTop()
                    previousController = UIViewController()
                    print("double tap")
                    return true
                }
                print("same")
            }else if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? ExploreScreen {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.scrollToTop()
                    previousController = UIViewController()
                    print("double tap")
                    return true
                }
                print("same")
            }else if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? ProfileTabbarScreen {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.scrollToTop()
                    previousController = UIViewController()
                    print("double tap")
                    return true
                }
                print("same")
            }
        }
        else{
            print("No same")
        }
        
        previousController = viewController
        
//        let control = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
//        control.superVC = self
//        self.navigationController?.pushViewController(control, animated: true)
        
        if let navVC = viewController as? UINavigationController, let vc = navVC.viewControllers.first as? PostTypeScreen {
//            let homeVC = STORYBOARD.home.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
            let control = STORYBOARD.post.instantiateViewController(withIdentifier: "PostTypeScreen") as! PostTypeScreen
            control.superVC = self.homeVC
            self.navigationController?.pushViewController(control, animated: true)
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
            return false
        }
        
//        if viewController.isKind(of: PostTypeScreen.self) {
           //let vc =  PostTypeScreen()
           
//        }
        return true;
    }
}

extension UIImage{
    //Draws the top indicator by making image with filling color
    class func drawTabBarIndicator(color: UIColor, size: CGSize, onTop: Bool) -> UIImage {
        let indicatorHeight = size.height / 20
        let yPosition = onTop ? 0 : (size.height - indicatorHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: yPosition, width: size.width, height: indicatorHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
