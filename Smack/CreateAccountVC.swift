//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Hein Htet on 8/7/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeBtnPressed(_ sender: Any) {
      performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
