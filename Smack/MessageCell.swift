//
//  MessageCell.swift
//  Smack
//
//  Created by Hein Htet on 8/11/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(message: Message) {
        messageBodyLabel.text = message.message
        userNameLabel.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }

}
