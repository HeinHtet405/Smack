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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For Keyboard
        view.bindToKeyboard()
        
        //TableView 
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Hide keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (success) in
            self.tableView.reloadData()
            //TODO:
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
