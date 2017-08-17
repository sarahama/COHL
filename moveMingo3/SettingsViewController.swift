//
//  SettingsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/10/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // let them know if they are a facebook user, their profile info and account info
        // all comes from FB, they cannot change anything through settings
        if (FBSDKAccessToken.current() != nil ) {
            // notify them there are no settings they can change
            let message = UILabel()
            message.text = "All settings are imported through Facebook. If you would like to change your personal info, it must be changed on Facebook."
            message.textColor = UIColor.black
            message.font = message.font.withSize(14)
            message.numberOfLines = 4
            message.frame = CGRect(x: 30, y: 300, width: self.view.bounds.size.width - 60 , height: 100)
            self.view.addSubview(message)
            
        } else {
            // if they're not a facebook user display their setting options
            
            // name
            let name = UITextField()
            name.text = "your name"
            name.frame = CGRect(x: 30, y: 200, width: self.view.bounds.size.width - 60 , height: 50)
            self.view.addSubview(name)
            
            // email
            let email = UITextField()
            email.text = "your name"
            email.frame = CGRect(x: 30, y: 275, width: self.view.bounds.size.width - 60 , height: 50)
            self.view.addSubview(email)
            
            // link to change password
            
            // button to save changes
            let update = UIButton()
            update.setTitle("Save Changes", for: [])
            update.frame = CGRect(x: 30, y: 400, width: self.view.bounds.size.width - 60 , height: 50)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
