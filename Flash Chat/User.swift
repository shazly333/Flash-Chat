//
//  User.swift
//  Flash Chat
//
//  Created by El-Shazly on 7/16/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation


class User{
    
    var email:String
    var groupsChat: [GroupChat] = []
    
    init(email:String) {
        self.email = email
    }
    
    
    
}
