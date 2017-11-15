//
//  FeedbackViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/10/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var message: UITextView!
    
    let URL_CREATE_FEEDBACK:String = "http://apps.healthyinthehills.com/manage_feedback.php"
    
    override func viewDidLoad() {

        super.viewDidLoad()

        message.layer.borderWidth = 1.0
        message.layer.cornerRadius = 8
        message.layer.borderColor = UIColor.lightGray.cgColor
        
        subject.layer.borderWidth = 1.0
        subject.layer.cornerRadius = 8
        subject.layer.borderColor = UIColor.lightGray.cgColor
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Do any additional setup after loading the view.
        submitButton.addTarget(self, action:#selector(userFeedback), for: .touchUpInside)
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
    
    
    // make a new record
    @objc func userFeedback(sender:UIButton){
        
        // submit the feedback

    
        // create a new record
        print("there is feedback")
        
        //created NSURL
        let requestURL:NSURL = NSURL(string: self.URL_CREATE_FEEDBACK)!
            
            
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL as URL)
            
        //setting the method to post
        request.httpMethod = "POST"
            
        //getting values for insert
            
        let user_id = "\(current_user_id)"
        let subjectText = subject.text
        let messageText = message.text
        let partial = subjectText!+"&message="+messageText!
            
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "user_id="+user_id+"&subject="+partial
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
                        
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(profileViewController, animated: true, completion: nil)
        
        return
        
    }


}
