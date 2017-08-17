///Users/sarahmacadam/Documents/Apple development/moveMingo3/moveMingo3
//  SignInViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdamvarll rights reserved.
//

import UIKit

import FBSDKLoginKit



class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //URL to our web service
    let URL_CREATE_USER:String = "http://Sarahs-MacBook-Pro-2.local/COHL/create_new_user.php"
    
    var fb_name: String!
    var fb_id: String!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()


        view.addSubview(loginButton)

        // position the login button in the view
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -20))
        
        // constraints to center the login button in the view
        let leading = NSLayoutConstraint(item: loginButton,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 50.0)
        let trailing = NSLayoutConstraint(item: loginButton,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.view,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: -50.0)

        self.view.addConstraint(leading)
        self.view.addConstraint(trailing)
        
        
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
        if(FBSDKAccessToken.current() != nil)
        {
            if (createNewUser()){
                // track that they are using facebook
                using_fb = true
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                
                self.present(homeViewController, animated: true, completion: nil)
                return
            }
        }
        
        return
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /***
     Makes a post to the php service to create a new
     user if the access token has not already been taken
     ***/
    func createNewUser() -> Bool {
        print("attempting to create new user...")
        //created NSURL
        let requestURL:NSURL = NSURL(string: URL_CREATE_USER)!
       
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        getFaceBookName(completion: {(result)->Void in
            print(result)
            print(self.fb_name, self.fb_id)
        
        
            print("information has been retrieved")
            let first_name = self.fb_name
            let id = self.fb_id

        
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "first_name="+first_name!+"&fb_id="+id!;
            print(postParameters)
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: .utf8)!
        
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                (data, response, error) in
                
                if error != nil{
                    print("error is \(error)")
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
                        current_user_id = (parseJSON["user_id"] as! Int?)!
                        //printing the response
                        print(msg)
                        print(err)
                        print(current_user_id)
                    
                    }
                } catch {
                    print(error)
                }
            
            }

            task.resume()
        })
        return true
    }
    

    
    /***
     Retrieves a user's name
     ***/
    func getFaceBookName(completion:@escaping (_ result:String)->Void) {
        print("retrieve facebook data")
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name, id, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let fb_data = result as! [String : AnyObject]
                
                self.fb_name = (fb_data["name"] as? String)!
                self.fb_id = (fb_data["id"] as? String)!
                completion("done")
            })
            print("begin connection")
            connection.start()
            print("completed")
        }
        return
    }
}
