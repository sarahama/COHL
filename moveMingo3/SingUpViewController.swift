//
//  SingUpViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/1/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController {
    
    var data : NSMutableData = NSMutableData()
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var register: UIButton!
    
    @IBOutlet weak var confirm_pass: UITextField!
    //this will be changed to the path on WH&W's server
    //let urlPath: String =
    let URL_CREATE_USER:String = "http://apps.healthyinthehills.com/manage_user.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        // Do any additional setup after loading the view.
        register.addTarget(self, action:#selector(signUpUser), for: .touchUpInside)
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
    
    //the button action function
    func signUpUser(sender: UIButton) {
        
        let select_type = "sign_up_user"
        let requestURL = NSURL(string: URL_CREATE_USER)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "select_type="+select_type+"&email="+email.text!+"&password="+pass.text!+"&confirm_password="+confirm_pass.text!+"&name="+name.text!+"&phone="+phone.text!
        
        
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
                
                self.errorMessage.text = "*"+(userJSON.value(forKey: "message") as? String)!
                
            } catch {
                //error message in case of invalid credential
                print("Invalid username or password")
            }
        }
        task.resume()
    }


}
