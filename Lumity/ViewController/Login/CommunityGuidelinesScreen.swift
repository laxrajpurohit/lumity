//
//  CommunityGuidelinesScreen.swift
//  Source-App
//
//  Created by iroid on 28/03/21.
//

import UIKit

class CommunityGuidelinesScreen: UIViewController ,UIScrollViewDelegate{

    //MARK: - OUTLET
    @IBOutlet weak var acceptButtonBGView: dateSportView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var communityLabel: UILabel!
    var isEnd: Bool = false
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
            self.acceptButton.isUserInteractionEnabled = false
        self.acceptButtonBGView.removeGradient(selectedGradientView: self.acceptButtonBGView)
        self.acceptButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
        // Do any additional setup after loading the view.
        self.initialDetail()
    }
    func initialDetail(){
        let attributedPlanString1 = NSMutableAttributedString()
        attributedPlanString1.append(NSAttributedString(string: "“Lumity” is a platform to promote positive and productive content among growth-oriented people. It allows for the sharing of content with those who hold similar passions, interests, and desires in, and for, the world we all share. Our community members seek to better themselves and as a result, our society as a whole.\n\nThis network focuses on consuming useful content that will help drive thoughts and conversations, while simultaneously allowing people to grow, learn, and expand within the areas they find interest in. We recognize that we all possess various learning styles, so at Lumity, we aim to provide a platform with multiple ways in which to absorb knowledge.\n\nFrom financial literacy to leadership development; climate change to mental health and wellness: Whatever it is that you are passionate about, you now have the ability to gain insight to what others are reading, listening to, watching, or learning from at the tip of your fingers. We encourage you to be your full and authentic self through sharing, engaging, and growing in the specific areas that bring you joy and internal wealth.\n\nThese days the internet, and especially social media, can be riddled with negative, polarizing, and combative material that leads to division and hatred rather than unity and love. This is not a platform for bigotry, defamation, harassment, or hatred. Instead, it is a platform to learn from one another in order to grow the collective in a positive direction. We urge community accountability through the ability to report inappropriate and/or offensive content when necessary.\n\nWe hold ourselves to a standard of fair and equal education for all, and for this to occur, we expect deep respect and compassion amongst members of the community. This is an inclusive platform for all to feel comfortable to share their genuine interests and passions. While disagreement will surely occur, this can be done in a healthy and constructive way. Disagreement does not warrant the reporting of others or creating a hostile environment. Rather, we desire meaningful dialogue to discuss big ideas and work towards solutions, rather than further polarizing problems.\n\nSo, when the inevitable happens, and you come across something you do not agree with, scroll past the post, and get to something you better align with. Or… maybe challenge yourself to do just the opposite. Take the time to read, watch, or listen to the item in an objective manner and hear the other side out. You might just learn something new.\n\n", attributes: [.font:UIFont(name: "Calibri", size: 17)!,.foregroundColor:Utility.getUIcolorfromHex(hex: "#000000")]))
        
        attributedPlanString1.append(NSAttributedString(string: "Let’s begin to make the world a better place one shared piece of content at a time.\n\n", attributes: [.font:UIFont(name: "Calibri-Bold", size: 17)!,.foregroundColor:Utility.getUIcolorfromHex(hex: "#000000")]))
        
        communityLabel.attributedText = attributedPlanString1
        
        self.showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Welcome to Lumity! 😊", message: "Thanks so much for joining! Please read the following to understand what we at Lumity represent and the type of values we want this platform and our community members to uphold.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
              //Cancel Action
            
          }))
         
          self.present(alert, animated: true, completion: nil)
      }
    
    
    //MARK: - SCROLL METHOD
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            self.stoppedScrolling()
        }
    }
    
    func stoppedScrolling() {
        if self.isEnd{
            self.acceptButton.isUserInteractionEnabled = true
//            self.acceptButton.layer.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.662745098, blue: 0.7098039216, alpha: 1)
            self.acceptButtonBGView.removeGradient(selectedGradientView: self.acceptButtonBGView)
            self.acceptButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 1)], cornurRadius: 8)
            
        }else{
            self.isEnd = true
            self.acceptButton.isUserInteractionEnabled = false
            self.acceptButtonBGView.removeGradient(selectedGradientView: self.acceptButtonBGView)
            self.acceptButtonBGView.applyGradient(colours:  [#colorLiteral(red: 0.4156862745, green: 0.4078431373, blue: 0.9490196078, alpha: 0.5), #colorLiteral(red: 0.9725490196, green: 0.4666666667, blue: 0.5921568627, alpha: 0.5)], cornurRadius: 8)
            
//            self.acceptButton.layer.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            self.stoppedScrolling()
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onAccept(_ sender: UIButton) {
        let control = STORYBOARD.login.instantiateViewController(withIdentifier: "InterestScreen") as! InterestScreen
        self.navigationController?.pushViewController(control, animated: true)
    }

}
