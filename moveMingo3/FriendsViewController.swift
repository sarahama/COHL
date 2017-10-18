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
            // get the user's contacts
            addressList()
        }
        
        findFriends = false
        friendsToggle.addTarget(self, action:#selector(changeView), for: .touchUpInside)
        
        // load the table
        DispatchQueue.main.async {
            self.friendsTable.reloadData()
            return
        }
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
            let requestButton = UIButton(frame: CGRect(x: 210, y: 25, width: 50, height: 25))
            requestButton.backgroundColor = #colorLiteral(red: 0.4145818852, green: 0.8846340674, blue: 0.8758338858, alpha: 1)
            requestButton.setTitle("Add", for: [])
            requestButton.setTitleColor(.white, for: .normal)
            requestButton.tag = Int(user.user_id!)
            requestButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            requestButton.layer.cornerRadius = 5
            requestButton.layer.borderWidth = 1
            requestButton.layer.borderColor = UIColor.white.cgColor
            
            requestButton.tag = Int(user.user_id!)
            requestButton.addTarget(self, action: #selector(requestFriend), for: .touchUpInside)
            
            header.addSubview(requestButton)
        } else if (user.responded == 0) {
            header.backgroundColor = UIColor.lightGray
            // add the friend request button
            let acceptButton = UIButton(frame: CGRect(x: 165, y: 25, width: 75, height: 25))
            acceptButton.backgroundColor = #colorLiteral(red: 0.4145818852, green: 0.8846340674, blue: 0.8758338858, alpha: 1)
            acceptButton.setTitle("Accept", for: [])
            acceptButton.setTitleColor(.white, for: .normal)
            acceptButton.tag = Int(user.user_id!)
            acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            acceptButton.layer.cornerRadius = 5
            acceptButton.layer.borderWidth = 1
            acceptButton.layer.borderColor = UIColor.white.cgColor
            
            acceptButton.tag = Int(user.user_id!)
            acceptButton.addTarget(self, action: #selector(acceptFriend), for: .touchUpInside)
            
            header.addSubview(acceptButton)
            
            let denyButton = UIButton(frame: CGRect(x: 240, y: 25, width: 75, height: 25))
            denyButton.backgroundColor = #colorLiteral(red: 0.8846340674, green: 0.4721505637, blue: 0.3952890262, alpha: 1)
            denyButton.setTitle("Deny", for: [])
            denyButton.setTitleColor(.white, for: .normal)
            denyButton.tag = Int(user.user_id!)
            denyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            denyButton.layer.cornerRadius = 5
            denyButton.layer.borderWidth = 1
            denyButton.layer.borderColor = UIColor.white.cgColor
            
            denyButton.tag = Int(user.user_id!)
            denyButton.addTarget(self, action: #selector(denyFriend), for: .touchUpInside)
            
            header.addSubview(denyButton)
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
            // set it to show friends to connect to, send the contact string
            accountModel.downloadItems(select_type: "view_unconnected_friends", phone_list: contactArrayString)
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
        // Use code below from the RewardsViewController as a template
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "Friend Request", message: "Would you like to add this friend?", preferredStyle: .actionSheet)
        
        
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
            let friend_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "select_type=request_friend&user_id="+user_id+"&friend_id="+friend_id;
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
            // reload the table
            let accountModel = AccountModel()
            accountModel.delegate = self
            accountModel.downloadItems(select_type: "view_unconnected_friends", phone_list: self.contactArrayString)
            DispatchQueue.main.async {
                self.feedItems = NSArray()
                self.friendsTable.reloadData()
                return
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        return
        
    }
    

    // accept a friend
    func acceptFriend(sender:UIButton){
        // Use code below from the RewardsViewController as a template
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "Friend Request", message: "Would you like to accept this friend?", preferredStyle: .actionSheet)
        
        
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
            let friend_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "select_type=request_response&user_id="+user_id+"&friend_id="+friend_id+"&accept=1";
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
            // reload the table
            let accountModel = AccountModel()
            accountModel.delegate = self
            accountModel.downloadItems(select_type: "view_friends")
            DispatchQueue.main.async {
                self.feedItems = NSArray()
                self.friendsTable.reloadData()
                return
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        return
        
    }
    
    // accept a friend
    func denyFriend(sender:UIButton){
        // Use code below from the RewardsViewController as a template
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "Friend Request", message: "Are you sure you want to deny this request?", preferredStyle: .actionSheet)
        
        
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
            let friend_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "select_type=request_response&user_id="+user_id+"&friend_id="+friend_id+"&accept=0";
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
            // reload the table
            let accountModel = AccountModel()
            accountModel.delegate = self
            accountModel.downloadItems(select_type: "view_friends")
            DispatchQueue.main.async {
                self.feedItems = NSArray()
                self.friendsTable.reloadData()
                return
            }
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        return
        
    }
    

    
    
    // function to retrieve all contact phone numbers as a CSV string
    func addressList(){
        let contactStore = CNContactStore()
        let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey]
        let request1 = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
        
        try? contactStore.enumerateContacts(with: request1) { (contact, error) in
            for phone in contact.phoneNumbers {
                print(((phone.value) as CNPhoneNumber).stringValue)
                // build the string
                self.contactArrayString = self.contactArrayString + (((phone.value) as CNPhoneNumber).stringValue) + ","
            }
        }
    
    }
}
