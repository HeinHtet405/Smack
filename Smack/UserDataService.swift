//
//  UserDataService.swift
//  Smack
//
//  Created by Hein Htet on 8/8/17.
//  Copyright © 2017 Hein Htet. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avaterName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avaterName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        
        // [0.23425225234, 0.2342342432, 0.24234234234, 1]
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnWrapped = r else {
            return defaultColor
        }
        
        guard let gUnWrapped = g else {
            return defaultColor
        }
        
        guard let bUnWrapped = b else {
            return defaultColor
        }
        
        guard let aUnWrapped = a else {
            return defaultColor
        }
        
        let rfloat = CGFloat(rUnWrapped.doubleValue)
        let gfloat = CGFloat(gUnWrapped.doubleValue)
        let bfloat = CGFloat(bUnWrapped.doubleValue)
        let afloat = CGFloat(aUnWrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannel()
        MessageService.instance.clearMessages()
    }
    
}
