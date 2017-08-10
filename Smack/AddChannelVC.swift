//
//  AddChannelVC.swift
//  Smack
//
//  Created by Hein Htet on 8/10/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let channelName = nameTextField.text , nameTextField.text != "" else {
            return
        }
        guard let channelDesc = descriptionTextField.text else {
            return
        }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeBtnPressed(_:)))
        
        bgView.addGestureRecognizer(closeTouch)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "name",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
            
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description",attributes: [NSForegroundColorAttributeName: smackPurplePlaceHolder])
    }
    
    func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
