//
//  SettingsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/10/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController, AccountModelProtocal {

    var user_account = UserModel()
    let URL_UPDATE_USER:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_user.php"
    let name = UITextField()
    let name_label = UILabel()
    let email = UITextField()
    let email_label = UILabel()
    let phone = UITextField()
    let phone_label = UILabel()
    let errorMessage = UILabel()
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
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
            let accountModel = AccountModel()
            accountModel.delegate = self
            accountModel.downloadItems(select_type: "get_user_info")
            
            // name
            name_label.frame = CGRect(x: 30, y: 175, width: self.view.bounds.size.width - 60 , height: 20)
            name_label.text = "name"
            name_label.textColor = UIColor.lightGray
            
            self.view.addSubview(name_label)
            
            name.layer.borderWidth = 1.0
            name.layer.cornerRadius = 3
            name.layer.borderColor = UIColor.lightGray.cgColor
            name.frame = CGRect(x: 30, y: 200, width: self.view.bounds.size.width - 60 , height: 30)
            
            
            self.view.addSubview(name)
            

            
            // email
            
            email_label.frame = CGRect(x: 30, y: 235, width: self.view.bounds.size.width - 60 , height: 20)
            email_label.text = "email"
            email_label.textColor = UIColor.lightGray
            
            self.view.addSubview(email_label)
            
            email.layer.borderWidth = 1.0
            email.layer.cornerRadius = 3
            email.layer.borderColor =  UIColor.lightGray.cgColor
            email.frame = CGRect(x: 30, y: 260, width: self.view.bounds.size.width - 60 , height: 30)
            
            self.view.addSubview(email)
            
            // phone
            
            phone_label.frame = CGRect(x: 30, y: 295, width: self.view.bounds.size.width - 60 , height: 20)
            phone_label.text = "phone"
            phone_label.textColor = UIColor.lightGray
            
            self.view.addSubview(phone_label)
            
            phone.layer.borderWidth = 1.0
            phone.layer.cornerRadius = 3
            phone.layer.borderColor =  UIColor.lightGray.cgColor
            phone.frame = CGRect(x: 30, y: 320, width: self.view.bounds.size.width - 60 , height: 30)
            
            self.view.addSubview(phone)
            
            // space to show feedback if they gave invalid input
            //let errorMessage = UILabel()
            errorMessage.textColor = UIColor.red
            errorMessage.frame = CGRect(x: 30, y: 380, width: self.view.bounds.size.width - 60 , height: 40)
            errorMessage.text = ""
            self.view.addSubview(errorMessage)
            
            // button to save changes
            let update = UIButton()
            update.setTitle("Save Changes", for: [])
            update.backgroundColor = #colorLiteral(red: 0.3668780923, green: 0.5994322896, blue: 0.5997635126, alpha: 1)
            update.frame = CGRect(x: 30, y: self.view.bounds.size.height - 80, width: self.view.bounds.size.width - 60 , height: 40)
            self.view.addSubview(update)
            
            update.addTarget(self, action:#selector(updateUserSettings), for: .touchUpInside)
        }
        
    }
    
    func userItemsDownloaded(_ users: NSArray) {
        
        var user_account = UserModel()
        for user in users{
            user_account = user as! UserModel
        }
        print(user_account.name ?? "hi")
        name.text = user_account.name
        email.text = user_account.email
        phone.text = user_account.phone

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserSettings(sender: UIButton){

        //created NSURL
        let requestURL:NSURL = NSURL(string: self.URL_UPDATE_USER)!
            
            
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL as URL)
            
        //setting the method to post
        request.httpMethod = "POST"
            
        //getting values for insert
            
        let user_id = "\(current_user_id)"
        let new_name_email = name.text!+"&email="+email.text!
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters1 = "&user_id="+user_id+"&name="+new_name_email
        let postParameters = "select_type=update_settings"+postParameters1+"&phone="+phone.text!
    
        print(postParameters)
            
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: .utf8)!
            
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
                
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            print(data!)
            print("parsing response...")
            //parsing the response
            do {
                //converting resonse to NSDictionary
                    
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .  mutableContainers) as? NSDictionary
                    
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    var err : String!
                        
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    err = parseJSON["error"] as! String?
                    //printing the response
                    print(msg)
                    print(err)
                        
                
                    if( err == "true"){
                        self.errorMessage.text = "*"+(myJSON?.value(forKey: "message") as? String)!
                    } else {
                        print("redirect")
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    
                        self.present(profileViewController, animated: true, completion: nil)
                        return

                    
                    }
                }
            } catch {
                print(error)
            }
        }
            
        task.resume()
    
        return
        

    }

}
