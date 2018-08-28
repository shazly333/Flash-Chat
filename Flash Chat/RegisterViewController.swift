//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        if let email = emailTextfield.text,let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error != nil{
                print(error!)
                    
                }
                else{
                SVProgressHUD.dismiss()
                self.saveUserInDatabase(email: email)
                print("el7mad llh")
                self.performSegue(withIdentifier: "gotoCahtTable", sender:self)
                
                }
            
            
            }
        }
        else {
            if emailTextfield.text == nil {
                emailTextfield.placeholder = "You Should Enter Your Email"
            }
            
            if  passwordTextfield.text == nil {
                emailTextfield.placeholder = "You Should Enter Your Password"
            }
        }
        

        
        
    }
    func saveUserInDatabase(email: String){
        let newUser = User(email: email)
        let id = Auth.auth().currentUser?.uid
        self.ref.child("users/\(id!)/email").setValue(newUser.email)

        
        
        
        
    }
    
    
}
