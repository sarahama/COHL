//
//  ProfileViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 2/6/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate{


    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            print(accessToken)
            
            let logoutButton = FBSDKLoginButton()
            
            
            view.addSubview(logoutButton)
            
            // position the login button in the view
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -20))
            
            // constraints to center the login button in the view
            let leading = NSLayoutConstraint(item: logoutButton,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .leading,
                                             multiplier: 1.0,
                                             constant: 50.0)
            let trailing = NSLayoutConstraint(item: logoutButton,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: -50.0)
            
            self.view.addConstraint(leading)
            self.view.addConstraint(trailing)
            
            logoutButton.delegate = self
            logoutButton.readPermissions = ["email", "public_profile"]
            
            getFaceBookInfo()
        }
        // Do any additional setup after loading the view.
    }
    
    func getFaceBookInfo(){
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                let name = data["name"] as? String
                print("user's name is")
                print(name!)
                self.profileName.text = name
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.profilePic.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
        
    }
    
    func loginButtonDidLogOut (_ loginButton:FBSDKLoginButton!) {
        print("logged out of facebook")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! WelcomePageViewController
        
        self.present(welcomeViewController, animated: true, completion: nil)
        return
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error! ) {
        if error != nil {
            print(error)
            return
        }
        
        print("still logged in with facebook...")
        
        print(FBSDKAccessToken.current())

        return
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
