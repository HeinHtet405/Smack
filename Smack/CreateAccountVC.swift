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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createAccountPressed(_sender: Any) {
        guard let email = emailText.text, emailText.text != "" else {
            return
        }
        guard let pass = passText.text, passText.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("register user!")
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
