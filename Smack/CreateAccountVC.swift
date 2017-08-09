//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Hein Htet on 8/7/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var bgColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            
            //Handle Generate Background Color
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func createAccountPressed(_sender: Any) {
        
        // Show Activity Indicator
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let name = userNameText.text, userNameText.text != "" else {
            return
        }
        guard let email = emailText.text , emailText.text != "" else { return }
        guard let pass = passText.text , passText.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("Register Success!")
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        print("Success")
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                                 // Sender (Like Broadcast Reciever)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
   
    @IBAction func pickAvatarPressed(_sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        //Add Color with animation
        UIView.animate(withDuration: 0.2) {
           self.userImg.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
      performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    func setupView(){
        
        // Initial State Hide Indicator
        spinner.isHidden = true
        
        //Change TextField Placeholder Color Programtically
        userNameText.attributedPlaceholder = NSAttributedString(string: "username",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
        emailText.attributedPlaceholder = NSAttributedString(string: "email",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
        passText.attributedPlaceholder = NSAttributedString(string: "password",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
        
        // For Software Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func handleTap() {
        view.endEditing(true)
    }

    
    
    
    
    
    
}
