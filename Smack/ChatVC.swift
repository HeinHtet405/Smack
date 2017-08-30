//
//  ChatVC.swift
//  Smack
//
//  Created by Hein Htet on 8/7/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUserLabel: UILabel!
    
    // Variables
    var isTyping = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For Keyboard
        view.bindToKeyboard()
        
        //TableView 
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        sendBtn.isHidden = true
        
        //Hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (success) in
          if success {
            self.tableView.reloadData()
            if MessageService.instance.messages.count > 0 {
              let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
               self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
            }
          }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name &&
                    channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUserLabel.text = "\(names) \(verb) typing a message"
            }else {
                self.typingUserLabel.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            //get Channels
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    func handleTap() {
        view.endEditing(true)
    }
    
    func channelSelected (_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                //Do stuff with channels
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No Channels yet!"
                }
            }
        }
    }
    
    @IBAction func sendMessageBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else {
                return
            }
            guard let message = messageTextField.text else { return
            }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                 SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
                }
            })
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id  else {
            return
        }
        
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func sendMessageField(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id  else {
            return
        }
        if messageTextField.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
