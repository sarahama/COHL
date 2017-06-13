//
//  PassportViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 2/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class PassportViewController: UIViewController {

    @IBOutlet weak var total_points: UILabel!
    @IBOutlet weak var current_points: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fb_name: UILabel!
    
    let URL_GET_POINTS:String = "http://Sarahs-MacBook-Pro-2.local/COHL/passport_points.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event_select_type = "current"
        if let accessToken = AccessToken.current {
            print(accessToken)
            getFaceBookInfo()
            getPoints()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.fb_name.text = name
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.profilePic.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
        
    }
    
    func getPoints() {
        
        let requestURL = NSURL(string: URL_GET_POINTS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id="+"\(current_user_id)"
        
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
                    let current : Int!
                    let total : Int!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    err = parseJSON["error"] as! String?
                    

                    let pointsJSON = parseJSON["points"] as! NSDictionary
                    current = pointsJSON["Current_Points"] as! Int
                    total = pointsJSON["Total_Points"] as! Int
           
                    
                    //printing the response
                    print(msg)
                    print(err)
                    print(current)
                    print(total)
                    self.total_points.text = "\(total!)"
                    self.current_points.text = "\(current!)" + " PASSPORT POINTS"
                    
                }
            } catch {
                print(error)
            }
            
        }

        task.resume()
        
    }


}
