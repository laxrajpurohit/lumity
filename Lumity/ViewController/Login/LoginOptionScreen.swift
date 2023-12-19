//
//  LoginOptionScreen.swift
//  Source-App
//
//  Created by Nikunj on 25/03/21.
//

import UIKit

class LoginOptionScreen: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var onBoardingCollectionView: UICollectionView!
    @IBOutlet weak var pageCobtrolImageView: UIImageView!
   
    @IBOutlet weak var firstDotView: UIView!
    @IBOutlet weak var secondDotView: UIView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var getStartedView: UIView!
    @IBOutlet weak var loginView: UIView!

    
    @IBOutlet weak var appNameLabel: GradientLabel!
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        initalDetail()
    }
    
    func initalDetail(){
        onBoardingCollectionView.delegate = self
        onBoardingCollectionView.dataSource = self
        self.onBoardingCollectionView.register(UINib(nibName: "LoginIntroCell", bundle: nil), forCellWithReuseIdentifier: "LoginIntroCell")
        self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)


//        self.appNameLabel.applyGradient(colours: , cornurRadius: 0)
//        self.loginView.applyGradient(colours: [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
    }
   
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print(indexPath)
        
        if indexPath == 0{
            pageCobtrolImageView.image = UIImage(named: "first_page_controller")
//            self.firstDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)

            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)

//            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
            
            self.firstDotView.layer.borderWidth = 0
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
        }else{
            pageCobtrolImageView.image = UIImage(named: "secound_page_controller")
            
//            self.secoundDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 0
            
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)
            
            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            
        }
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if indexPath == 0{
            self.pageCobtrolImageView.image = UIImage(named: "first_page_controller")
//            self.firstDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           
            self.firstDotView.layer.borderWidth = 0
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)

            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
        }else{
            self.pageCobtrolImageView.image = UIImage(named: "secound_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.secoundDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 0
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let indexPath = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if indexPath == 0{
            self.pageCobtrolImageView.image = UIImage(named: "first_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)

            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            
//            self.firstDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           
            self.firstDotView.layer.borderWidth = 0
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }else{
            self.pageCobtrolImageView.image = UIImage(named: "secound_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.secoundDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 0
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let indexPath = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)

        if indexPath == 0{
            pageCobtrolImageView.image = UIImage(named: "first_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)

            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.firstDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           
            self.firstDotView.layer.borderWidth = 0
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }else{
            pageCobtrolImageView.image = UIImage(named: "secound_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.secoundDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 0
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let indexPath = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)

        if indexPath == 0{
            pageCobtrolImageView.image = UIImage(named: "first_page_controller")
            
            self.firstDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           
            self.firstDotView.layer.borderWidth = 0
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)

            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            
        }else{
            pageCobtrolImageView.image = UIImage(named: "secound_page_controller")
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.removeGradient(selectedGradientView: self.firstDotView)
            self.firstDotView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
//            self.secoundDotView.backgroundColor = #colorLiteral(red: 0.4956882596, green: 0.7179026008, blue: 0.7612629533, alpha: 1)
            self.firstDotView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 2
            self.firstDotView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            
            self.firstDotView.layer.borderWidth = 0
        }
    }
    
    func removeGradient(selectedGradientView:UIView){
        selectedGradientView.layer.sublayers = selectedGradientView.layer.sublayers?.filter { theLayer in
                !theLayer.isKind(of: CAGradientLayer.classForCoder())
          }
    }
    
    //MARK: - ACTIONS
    @IBAction func onGetStarted(_ sender: Any) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpScreen
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "EnterInviteCodeScreen") as! EnterInviteCodeScreen
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = STORYBOARD.login.instantiateViewController(withIdentifier: "LoginScreen") as! LoginScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
extension LoginOptionScreen: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.onBoardingCollectionView.dequeueReusableCell(withReuseIdentifier: "LoginIntroCell", for: indexPath) as! LoginIntroCell
        if indexPath.row == 0{
            cell.introImageView.image = UIImage(named: "ic_on_boarding_first")
            cell.detailLabel.text = "Lumity is an information sharing platform to engage in positive, productive content with your like-minded, growth-oriented learning community."
        }else{
            cell.introImageView.image = UIImage(named: "ic_on_boarding_secound")
            cell.detailLabel.text = "The butterfly said to the sun, \"They can't stop talking about my transformation. I can only do it once in my lifetime. If only they knew, they can do it at any time and in countless ways.\"\n-Dodinsky"
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
}
class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}
