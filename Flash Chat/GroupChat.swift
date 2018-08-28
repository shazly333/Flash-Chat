//
//  GroupChat.swift
//  Flash Chat
//
//  Created by El-Shazly on 7/16/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
class GroupChat{
    var owners: [String] = []
    var messages: [String] = []
    var senders: [String] = []
    var name: String = ""
    var id: String = ""
    var date: Date = Date()

    init(messages:[String], owners:[String], senders:[String],name: String, id: String, date: Date) {
        self.owners = owners
        self.messages = messages
        self.senders = senders
        self.name = name
        self.id = id
        self.date = date

    }
    init() {
        
    }
    static  func getGroupChat(snapShot: DataSnapshot)-> GroupChat{
        
        let emailsPath = snapShot.childSnapshot(forPath: "/emails/")
        let emails = emailsPath.value as? [String]
        let namePath = snapShot.childSnapshot(forPath: "name/")
        let name = namePath.value as? String
        let datePath = snapShot.childSnapshot(forPath: "/emails/")
        let date = emailsPath.value as? Date
        let messages =  snapShot.childSnapshot(forPath: "Messages/")
        var text:[String] = []
        var senders: [String] = []
        for child in messages.children {
            let snapshotValue  = (child as! DataSnapshot).value as! Dictionary<String,String>
           text.append(snapshotValue["MessageBody"]! ?? "")
            senders.append(snapshotValue["Sender"]! ?? "")
            
            
        }
        
        
        //let senders =  snapShot.childSnapshot(forPath: "Messages/senders/").value as? [String]
        
        return (GroupChat(messages: text ?? [], owners: emails ?? [], senders: senders ?? [], name: name ?? "", id: snapShot.key,date: date ?? Date() ))
        
    }
    
    
    
    
    
}
