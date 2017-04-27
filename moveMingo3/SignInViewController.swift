///Users/sarahmacadam/Documents/Apple development/moveMingo3/moveMingo3
//  SignInViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
     
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    func loginButtonDidLogOut (_ loginButton:FBSDKLoginButton!) {
        print("logged out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error! ) {
        if error != nil {
            print(error)
            return
        }
        
        print("logged in with facebook successfully...")
        
        print(FBSDKAccessToken.current())
        
        // check if the user already exists
        // if the user does not exist, create a new record
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        
        self.present(homeViewController, animated: true, completion: nil)
        return
        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
//            (connection, result, err) in
//            
//            if err != nil {
//                print("Failed to get graph request: ", err)
//                return
//            }
//            print(result)
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // utilize the php script to see if a user already exists for this access token
    func checkUserHasRegistered() {
        return
    }
    
    // utilize the php script to create a new user record with this access token
    func createNewUser() {
        return
    }
    

    
}
