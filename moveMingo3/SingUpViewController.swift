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
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var register: UIButton!
    
    @IBOutlet weak var confirm_pass: UITextField!
    //this will be changed to the path on WH&W's server
    //let urlPath: String =
    let URL_CREATE_USER:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_user.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        // Do any additional setup after loading the view.
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
    
    func create_new_user(select_type: String, name: String, password: String) {
        
        let requestURL = NSURL(string: URL_CREATE_USER)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        var postParameters = "select_type="+select_type
        if(select_type != "all"){
            postParameters = "select_type="+select_type+"&name="+name+"&password="+password
        }
        
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
            
//            //parsing the response
//            do {
//                //converting response to NSDictionary
//                var eventJSON: NSDictionary!
//                eventJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                
//                
//                let events_list: NSMutableArray = NSMutableArray()
//                
//                var jsonElement: NSDictionary = NSDictionary()
//                let jsonElements:  NSArray = eventJSON["events"] as! NSArray
//                
//                for i in 0...(jsonElements.count-1)
//                {
//                    
//                    jsonElement = jsonElements[i] as! NSDictionary
//                    
//                    let event = EventModel()
//                    
//                    //the following insures none of the JsonElement values are nil through optional binding
//                    let name:String = jsonElement["Event_Name"] as! String!
//                    let address:String = jsonElement["Event_Address"] as! String!
//                    let start_date:String = jsonElement["Event_Start_Date"] as! String!
//                    let end_date:String = jsonElement["Event_End_Date"] as! String!
//                    let details:String = jsonElement["Event_Details"] as! String!
//                    let event_id:Int = jsonElement["Event_ID"] as! Int!
//                    let points:Int = jsonElement["Event_Points"] as! Int!
//                    let count:Int = jsonElement["Count"] as! Int!
//                    
//                    event.name = name
//                    event.details = details
//                    event.address = address
//                    event.start_date = start_date
//                    event.end_date = end_date
//                    event.expanded = false
//                    event.event_id = "\(event_id)"
//                    event.points = "\(points)"
//                    event.count = "\(count)"
//                    
//                    
//                    events_list.add(event)
//                    
//                }
//                
//                DispatchQueue.main.async(execute: { () -> Void in
//                    
//                    self.delegate.itemsDownloaded(events_list)
//                    
//                })
//                
//            } catch {
//                print(error)
//            }
        }
        task.resume()
        
    }


}
