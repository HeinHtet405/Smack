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
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createAccountPressed(_sender: Any) {
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
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
   
    @IBAction func pickAvatarPressed(_sender: Any) {
        
    }
    
    @IBAction func pickBGColorPressed(_sender: Any) {
        
    }
    

    @IBAction func closeBtnPressed(_ sender: Any) {
      performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
