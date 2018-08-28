//
//  ChatRoomTableViewController.swift
//  Flash Chat
//
//  Created by El-Shazly on 7/17/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework
import SVProgressHUD
class ChatRoomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var groupChat = GroupChat()
    var ref: DatabaseReference!
    var id = ""

    @IBOutlet weak var hieght: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var myEmail = Auth.auth().currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        groupChat.messages.removeAll()
        groupChat.senders.removeAll()
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        table.delegate = self
        TextField.delegate = self
        configureTableView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        table.addGestureRecognizer(tapGesture)
        
        ref = Database.database().reference()
        ref.child("GroupChats/\(groupChat.id)/Messages").observe(.childAdded) { (snapShot) in
            let snapshotValue = snapShot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            self.groupChat.messages.append(text)
            self.groupChat.senders.append(sender)
            self.table.reloadData()
            self.scrollToBottom()
            
    }
        ref.child("GroupChats/\(groupChat.id)/Date").observe(.value) { (snapShot) in
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let date = dateFormatter.date(from: snapShot.value as! String)
            self.groupChat.date = date!
            
        }

        
        table.separatorStyle = .none
        
    }


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupChat.messages.count
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = groupChat.messages[indexPath.row]
        cell.senderUsername.text = groupChat.senders[indexPath.row]
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            //Set background to blue if message is from logged in user.
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            //Set background to grey if message is from another user.
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }

        return cell
    }
    @objc func tableViewTapped() {
        TextField.endEditing(true)
    }
    
    
    
    func configureTableView() {
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 120.0
        
        
    }
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.hieght.constant = 320
            self.view.layoutIfNeeded()
        }
    }

    
    
    @IBAction func addFriend(_ sender: Any) {
        
        var emailField = UITextField()
        var flag = 0
        let alert = UIAlertController(title: "Add New Friend To The Group Chat", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Friend", style: .default) { (action) in
            self.ref.child("users/").observeSingleEvent(of: .value, with: { (snapShot) in
                for child in snapShot.children {
                    let id = (child as! DataSnapshot).key
                    let emailPath = (child as AnyObject).childSnapshot(forPath: "/email")
                    let email = emailPath.value as? String
                    if email == emailField.text! {
                       self.ref.child("users/\(id)/GroupChat/\(self.groupChat.id)/").setValue(self.groupChat.id)
                        SVProgressHUD.showSuccess(withStatus: "Your friend has been added successfully")
                        flag = 1;
                    }
                }
                if flag == 0
                {
                    SVProgressHUD.showError(withStatus: "Not found user with this email")
                }
                
            })
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Friend"
            emailField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.hieght.constant = 50
            self.view.layoutIfNeeded()
        }
    }
   
    @IBAction func sendPressed(_ sender: Any) {
        TextField.endEditing(true)
        TextField.isEnabled = false
        sendButton.isEnabled = false
        if TextField.text != "" {
            self.ref.child("GroupChats/\(groupChat.id)/Messages").childByAutoId().setValue(["MessageBody":self.TextField.text!,"Sender":myEmail])
             self.ref.child("GroupChats/\(groupChat.id)/Date").setValue("\(Date())")
            self.TextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.TextField.text = ""

        }
        
        
        
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.groupChat.messages.count > 3 {
            self.table.reloadData()
            let indexPath = IndexPath(row: self.groupChat.messages.count-1, section: 0)
            self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            }
            return
        }
    }
    @IBAction func back(_ sender: Any) {
        ref.child("GroupChats/\(groupChat.id)/Messages").removeAllObservers()
        ref.child("GroupChats/\(groupChat.id)/Date").removeAllObservers()
        dismiss(animated: true, completion: nil)
    }
}
