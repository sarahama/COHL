//
//  SignUpViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class SignInWithoutFBViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let URL_USER_LOGIN:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_user.php"
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var smallMessages: UILabel!
    
    @IBOutlet var bottomGuide: NSObject!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        emailText.addTarget(self, action:#selector(self.emailTextFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        
        passText.addTarget(self, action:#selector(self.passTextFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)

        loginButton.addTarget(self, action:#selector(signUpUser), for: .touchUpInside)
        //loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(self.signUpUser)))
        //storeTo.addTarget(self, action:#selector(changeView), for: .touchUpInside)
    }


    func animateTextField(textField: UITextField, up: Bool, distance: Int)
    {
        let movementDistance:CGFloat = CGFloat(distance)
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        textField.frame = textField.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func emailTextFieldDidBeginEditing (sender: UIGestureRecognizer) {
        print("move email")
        self.animateTextField(textField: emailText, up:true, distance: -150)
    }
    
    func passTextFieldDidBeginEditing(sender: UIGestureRecognizer)
    {
        print("move password")
        self.animateTextField(textField: passText, up:true, distance: -180)
    }
        
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false, distance: -150)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //the button action function
    func signUpUser(sender:UIButton) {
    
        let select_type = "sign_in_user"
        let requestURL = NSURL(string: URL_USER_LOGIN)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "select_type="+select_type+"&email="+emailText.text!+"&password="+passText.text!
        
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: .utf8)!
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            //exiting if there is some error
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            print(data!)
            print("parsing response...")

            do {
                //converting response to NSDictionary
                var userJSON: NSDictionary!
                userJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
                if(!(userJSON.value(forKey: "error") as! String == "true")){
                    
                    current_user_id = userJSON["user"] as! Int
                    
                    print("current user is")
                    print(current_user_id)
                    // change the view to the home page
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                    
                    // use the global var to tag they have logged in without fb
                    using_fb = false
                    
                    self.present(homeViewController, animated: true, completion: nil)
                    return
                    
                }

                
            } catch {
                //error message in case of invalid credential
                print("Invalid username or password")
            }
        }
        task.resume()
    }
}
