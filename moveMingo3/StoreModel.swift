//
//  StoreModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/27/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import Foundation

protocol StoreModelProtocal: class {
    func itemsDownloaded(_ items: NSArray)
}


class StoreModel: NSObject, URLSessionDataDelegate {

    //properties
    
    weak var delegate: StoreModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    //this will be changed to the path on WH&W's server
    //let urlPath: String =
    let URL_GET_STORE:String = "http://apps.healthyinthehills.com/manage_store.php"
    
    
    func downloadItems(select_type: String) {
        
        let requestURL = NSURL(string: URL_GET_STORE)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        
        var postParameters: String!
        
        // add the user id to the post parameters
        if(select_type == "view_user_rewards"){
            postParameters = "action="+select_type+"&user_id="+"\(current_user_id)"
        } else {
            postParameters = "action="+select_type
        }
        print(postParameters)
        
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
            
            //parsing the response
            do {
                //converting response to NSDictionary
                var rewardJSON: NSDictionary!
                rewardJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                

                
                let rewards_list: NSMutableArray = NSMutableArray()
                
                var jsonElement: NSDictionary = NSDictionary()
                let jsonElements:  NSArray = rewardJSON["rewards"] as! NSArray
                
                for i in 0...(jsonElements.count-1)
                {
                    
                    jsonElement = jsonElements[i] as! NSDictionary
                    
                    let reward = RewardModel()
                    
                    //the following insures none of the JsonElement values are nil through optional binding
                    let name:String = jsonElement["Reward_Name"] as! String!
                    let cost:Int = jsonElement["Reward_Cost"] as! Int!
                    let stock:Int = jsonElement["Reward_Stock"] as! Int!
                    let reward_id:Int = jsonElement["Reward_ID"] as! Int!
                    
                    reward.reward_id = reward_id
                    reward.name = name
                    reward.cost = "\(cost)"
                    reward.stock = "\(stock)"
             
                    if(select_type == "view_user_rewards"){
                        let completed:Bool = jsonElement["Redeem_Completed"] as! Bool!
                        let available:Bool = jsonElement["Reward_Available_For_PickUp"] as! Bool!
                        
                        reward.completed = completed
                        reward.available = available
                    }
                    
                    
                    rewards_list.add(reward)
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.delegate.itemsDownloaded(rewards_list)
                    
                })
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }

    
}
