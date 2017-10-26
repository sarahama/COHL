//
//  AccountModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/17/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

import Foundation

protocol AccountModelProtocal: class {
    func userItemsDownloaded(_ users: NSArray)
}

class AccountModel: NSObject, URLSessionDataDelegate{
    
    //properties
    
    weak var delegate: AccountModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    //this will be changed to the path on WH&W's server
    //let urlPath: String =
    let URL_USER_INFO:String = "http://apps.healthyinthehills.com/manage_user.php"
    let URL_GET_FRIENDS:String = "http://apps.healthyinthehills.com/manage_friends.php"
    
    func downloadItems(select_type: String, phone_list: String = "") {
        
        var requestURL = NSURL()
        var phone_list1 = ""
        var phone_list2 = ""
        if (select_type == "get_user_info"){
            requestURL = NSURL(string: URL_USER_INFO)!
        } else if (select_type == "view_unconnected_friends"){
            phone_list1 = "&phone_list="+phone_list
            phone_list2 = phone_list1.replacingOccurrences(of: "\\s", with: "-", options: .regularExpression)
            requestURL = NSURL(string: URL_GET_FRIENDS)!
        } else {
            requestURL = NSURL(string: URL_GET_FRIENDS)!
        }
        
        let request = NSMutableURLRequest(url: requestURL as URL)
        request.httpMethod = "POST"
        
        
        let postParameters = "select_type="+select_type+"&user_id="+"\(current_user_id)"+phone_list2
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: .utf8)!
        print("PJHOENSE")
        print(phone_list2)
        
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
            
            //parsing the response
            do {
                //converting response to NSDictionary
                var userJSON: NSDictionary!
                userJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                let user_list: NSMutableArray = NSMutableArray()
                
                let jsonElements:  NSArray = userJSON["user"] as! NSArray
                
                
                
                for element in jsonElements
                {
                    let element1 = element as! NSDictionary
                    
                    
                    //the following insures none of the JsonElement values are nil through optional binding
                    let name:String = element1["First_Name"] as! String!
                    let user_id:Int = element1["User_ID"] as! Int
                    let total_points:Int = element1["Total_Points"] as! Int!
                    
                    let user = UserModel()
                    user.name = name
                    user.total_points = "\(total_points)"
                    user.user_id = user_id
                    
                    if (select_type == "get_user_info"){
                        let email:String = element1["Email"] as! String!
                        let date_joined:String = element1["Date_Joined"] as! String!
                        let current_points:Int = element1["Current_Points"] as! Int!
                        let profile_path:String = element1["Profile_Path"] as! String!
                        let phone:String = element1["Phone"] as! String
                        
                        user.email = email
                        user.date_joined = date_joined
                        user.current_points = "\(current_points)"
                        user.profile_path = profile_path
                        user.phone = phone
                    } else if (select_type == "view_friends") {
                        // if they are viewing the full list of friends, we need to 
                        // know which friends are actually pending requests
                        let responded:Int = element1["Responded"] as! Int
                        
                        user.responded = responded
                    }
                    
                    
                    user_list.add(user)
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.delegate.userItemsDownloaded(user_list)
                    
                })
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
}
