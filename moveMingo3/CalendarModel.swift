//
//  CalendarModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 3/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import Foundation

protocol CalendarModelProtocal: class {
    func itemsDownloaded(_ items: NSArray)
}

class CalendarModel: NSObject, URLSessionDataDelegate{

    //properties
    
    weak var delegate: CalendarModelProtocal!
    
    var data : NSMutableData = NSMutableData()

    //this will be changed to the path on WH&W's server
    //let urlPath: String =
    let URL_GET_UPCOMING_EVENTS:String = "http://apps.healthyinthehills.com/manage_events.php"
    

    func downloadItems(select_type: String) {
        
        let requestURL = NSURL(string: URL_GET_UPCOMING_EVENTS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        var postParameters = "select_type="+select_type
        if(select_type != "all"){
            postParameters = "select_type="+select_type+"&user_id="+"\(current_user_id)"
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
            
            //parsing the response
            do {
                //converting response to NSDictionary
                var eventJSON: NSDictionary!
                eventJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                let events_list: NSMutableArray = NSMutableArray()
               
            
                let jsonElements:  NSArray = eventJSON["events"] as! NSArray
                
                
                for element in jsonElements
                {
                    let element1 = element as! NSDictionary
                    
                    let event = EventModel()
                    
                    //the following insures none of the JsonElement values are nil through optional binding
                    let name:String = element1["Event_Name"] as! String!
                    let address:String = element1["Event_Address"] as! String!
                    let start_date:String = element1["Event_Start_Date"] as! String!
                    let end_date:String = element1["Event_End_Date"] as! String!
                    let details:String = element1["Event_Details"] as! String!
                    let event_id:Int = element1["Event_ID"] as! Int!
                    let points:Int = element1["Event_Points"] as! Int!
                    let count:Int = element1["Count"] as! Int!
                    
                    event.name = name
                    event.details = details
                    event.address = address
                    event.start_date = start_date
                    event.end_date = end_date
                    event.expanded = false
                    event.event_id = "\(event_id)"
                    event.points = "\(points)"
                    event.count = "\(count)"
                        
                    
                    events_list.add(event)
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.delegate.itemsDownloaded(events_list)
                    
                })
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }

}
