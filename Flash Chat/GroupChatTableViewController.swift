//
//  GroupChatTableViewController.swift
//  Flash Chat
//
//  Created by El-Shazly on 7/16/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
class GroupChatTableViewController: UITableViewController {

    var groupChats:[GroupChat] = []
    var groupChatsID:[String] = []

    var ref: DatabaseReference!
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        id = (Auth.auth().currentUser?.uid)!
        ref.child("users/\(id)/GroupChat/").observe(.childAdded) { (snapShot) in
        let idGroup = (snapShot.value as? String)!
        self.ref.child("GroupChats/\(idGroup)").observeSingleEvent(of: .value, with: { (snapShpt) in
            self.groupChats.append(GroupChat.getGroupChat(snapShot: snapShpt))
            self.groupChats.sort(by: { (group1, group2) -> Bool in
                return (group1.date.compare(group2.date)) == ComparisonResult.orderedDescending
            })
            
            self.tableView.reloadData()
            })
            self.ref.child("GroupChats/\(idGroup)/Date").observe(.value) { (snapShot) in
                for groupChat in self.groupChats{
                    if groupChat.id == idGroup {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                        let date = dateFormatter.date(from: snapShot.value as! String)
                        groupChat.date = date!
                        self.groupChats.sort(by: { (group1, group2) -> Bool in
                            return (group1.date.compare(group2.date)) == ComparisonResult.orderedDescending
                        })
                        self.tableView.reloadData()
                    }
                }

            }

            
        }
    }

    @IBAction func addNewGroupChat(_ sender: Any) {
        
        var nameField = UITextField()
        let alert = UIAlertController(title: "Add New Group Chat", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Group Chat", style: .default) { (action) in
        let myEmail = Auth.auth().currentUser?.email
        let idGroupChat = self.ref.child("GroupChats/").childByAutoId().key
            self.ref.child("GroupChats/\(idGroupChat)").updateChildValues(["emails":[myEmail], "name":nameField.text ?? "","text":[],"owner":[], "Date":"\(Date())"])
        self.ref.child("users/\(self.id)/GroupChat/\(idGroupChat)/").setValue(idGroupChat)
            
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Group Chat"
            nameField = alertTextField

        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupChats.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatCell", for: indexPath)
        cell.textLabel?.text = groupChats[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupChat = groupChats[indexPath.row]
        performSegue(withIdentifier: "gotoChat", sender: groupChat)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? UINavigationController {
            if let chatRoom = nv.viewControllers.first as? ChatRoomTableViewController {
            chatRoom.groupChat = sender as! GroupChat
            }
        }
            
    }

    @IBAction func logOut(_ sender: Any) {
       try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
