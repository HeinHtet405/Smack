//
//  LoginVC.swift
//  Smack
//
//  Created by Hein Htet on 8/7/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = userNameTextField.text, userNameTextField.text != "" else {
            return
        }
        
        guard let pass = passTextField.text, passTextField.text != "" else {
            return
        }
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setupView() {
        
        // Initial State Hide Indicator
        spinner.isHidden = true
        
        //Change TextField Placeholder Color Programtically
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
        passTextField.attributedPlaceholder = NSAttributedString(string: "password",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
        
        // For Software Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func handleTap() {
        view.endEditing(true)
    }
    
}
