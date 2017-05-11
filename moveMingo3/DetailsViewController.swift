//
//  DetailsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 5/11/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource {
    
    // Properties declarations at the top of the class
    var address: String!
    var event: EventModel!
    
    let URL_CREATE_INTEREST:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_interests.php"

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.tableHeaderView = UIImageView(image: photo)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // At the end of the class
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")  as! EventDetailsTableViewCell
        cell.eventTitle!.text = event.name
        cell.address!.text = event.address
        cell.details!.text = event.details
        cell.details.numberOfLines = 0
        // define action for the interested button
        cell.interested.addTarget(self, action:#selector(userIsInterested), for: .touchUpInside)
        
        let url = NSURL(string: "http://Sarahs-MacBook-Pro-2.local/COHL/images/5k.jpg")
        cell.photo.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
        
        return cell
    }

    
    // make a new record
    func userIsInterested(){
        print("the user is interested in something")
        print(event.event_id)
        //created NSURL
        let requestURL:NSURL = NSURL(string: URL_CREATE_INTEREST)!
        
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        print("the current user is")
        print(current_user_id)
        
        //getting values for insert

        let user_id = "\(current_user_id)"
            
            
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "user_id="+user_id+"&event_id="+event.event_id!;
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
        
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        
        self.present(homeViewController, animated: true, completion: nil)
        return

    }

}
