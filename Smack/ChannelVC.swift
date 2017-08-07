//
//  ChannelVC.swift
//  Smack
//
//  Created by Hein Htet on 8/7/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

}
