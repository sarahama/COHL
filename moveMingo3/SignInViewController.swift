//
//  SignInViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin
import FBSDKLoginKit

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        //let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        loginButton.delegate = self
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        print("logged in")
    }
    
//    override func viewDidLoad() {
//        // Add a custom login button to your app
//        let myLoginButton = UIButton(type: .custom)
//        myLoginButton.backgroundColor = UIColor.darkGrayColor()
//        myLoginButton.frame = CGRect(0, 0, 180, 40);
//        myLoginButton.center = view.center;
//        myLoginTitle.setTitle("My Login Button" forState: .normal)
//        
//        // Handle clicks on the button
//        myLoginButton.addTarget(self, action: @selector(self.loginButtonClicked) forControlEvents: .TouchUpInside)
//        
//        // Add the button to the view
//        view.addSubview(myLoginButton)
//    }
    
    // Once the button is clicked, show the login dialog
//    @objc func loginButtonClicked() {
//        let loginManager = LoginManager()
//        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                print("Logged in!")
//            }
//        }
//    }
    
}
