//
//  FriendsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts
import FBSDKLoginKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AccountModelProtocal  {
    
    
    
    @IBOutlet weak var colorStrip: UIImageView!
    
    @IBOutlet weak var tableTitle: UILabel!

    @IBOutlet weak var friendsTable: UITableView!
    
    @IBOutlet weak var friendsToggle: UIButton!
    
    var findFriends = false
    var feedItems: NSArray = NSArray()
    let contactArray: NSMutableArray = NSMutableArray()
    var contactArrayString: String = ""
    
    
    let URL_GET_FRIENDS:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_friends.php"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        //set delegates and initialize homeModel
        
        self.friendsTable.delegate = self
        self.friendsTable.dataSource = self
        
        // they can only connect with friends if they logged in with
        if (FBSDKAccessToken.current() != nil ) {
            let accountModel = AccountModel()
            accountModel.delegate = self
            accountModel.downloadItems(select_type: "view_friends")
        }
        
        findFriends = false
        friendsToggle.addTarget(self, action:#selector(changeView), for: .touchUpInside)
        
        // load the table
        DispatchQueue.main.async {
            self.friendsTable.reloadData()
            return
        }
        // get the user's contacts
        addressList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func userItemsDownloaded(_ users: NSArray) {
        feedItems = users
        self.friendsTable.reloadData()
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of feed items
        if (FBSDKAccessToken.current() != nil ) {
            return feedItems.count
        } else {
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (FBSDKAccessToken.current() == nil ) {
            let header = FriendsHeaderFooterView()
            let user = UserModel()
            user.name = "FB login required to connect"
            header.customInit(user: user, section: section)
            return header
        }
        
        // use the friend header
        let header = FriendsHeaderFooterView()
        let user = feedItems[section] as! UserModel
        header.customInit(user: user, section: section)
        
        // they want to add friends
        if(findFriends) {
            // add the friend request button
            let requestButton = UIButton(frame: CGRect(x: header.bounds.width - 80, y: 30, width: 50, height: 25))
            requestButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            requestButton.setTitle("Add", for: [])
            requestButton.tag = Int(user.user_id!)
            requestButton.addTarget(self, action: #selector(requestFriend), for: .touchUpInside)
            
            header.addSubview(requestButton)
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func changeView(sender:UIButton) {
        // toggle the view store boolean
        
        findFriends = !findFriends
        
        let accountModel = AccountModel()
        accountModel.delegate = self
        
        if (findFriends){
            // set it to show friends to connect to
            accountModel.downloadItems(select_type: "view_connected_friends", phone_list: contactArrayString)
            friendsToggle.setTitle("My Friends", for: .normal)
            tableTitle.text = "FIND FRIENDS"
            
        } else {
            // show their friends
            accountModel.downloadItems(select_type: "view_friends")
            friendsToggle.setTitle("Find Friends", for: .normal)
            tableTitle.text = "MY FRIENDS"
        }
        // load the table
        DispatchQueue.main.async {
            self.feedItems = NSArray()
            self.friendsTable.reloadData()
            return
        }
        
    }
    
    
    // connect with a friend
    func requestFriend(sender:UIButton){
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "My Purchase", message: "Would you like to add this friend?", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
            // create a new record
            print("the user is sending a request")
            print(sender.tag)
            //created NSURL
            let requestURL:NSURL = NSURL(string: self.URL_GET_FRIENDS)!
            
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            print("the current user is")
            print(current_user_id)
            
            //getting values for insert
            
            let user_id = "\(current_user_id)"
            let reward_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "action=purchase&user_id="+user_id+"&reward_id="+reward_id;
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
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        
        return
        
    }
    

    
    
    // function to retrieve contact phone numbers
    func addressList(){
        
        if #available(iOS 9, *)
        {let   store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler:
                {granted, error in
                    guard granted
                        else{
                        let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> HealthyInTheHills to enable contact permission", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
                    let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor] )
                    var cnContacts = [CNContact]()
                    do {try store.enumerateContacts(with: request){
                        (contact, cursor) -> Void in
                        cnContacts.append(contact)
                        }
                    } catch let error
                    {
                        NSLog("Fetch contact error: \(error)")
                    }
                    
                    for contact in cnContacts
                    {
                        let phonenum =  contact.phoneNumbers.first//.value(forKey: "digits") as! String
                        // new class object of contacts data with phone number and username
                        let phoneNumb = contact.phoneNumbers.first
                        if let phoneStruct = phoneNumb!.value as? CNPhoneNumber
                        {_ = phoneStruct.stringValue
                            print(phonenum!)
                        }

                        self.contactArray.add((phonenum?.label)!)
                    }
                    //self.contactArrayString = (self.contactArray as? String)!
                    //print(self.contactArrayString)
                })
        }
    
    }
}
