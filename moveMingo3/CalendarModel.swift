//
//  CalendarModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 3/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import Foundation

protocol CalendarModelProtocal: class {
    func itemsDownloaded(items: NSArray)
}

class CalendarModel: NSObject, NSURLSessionDataDelegate{

    //properties
    
    weak var delegate: CalendarModelProtocal!
    
    var data : NSMutableData = NSMutableData()
    
    let urlPath: String = "http://localhost/cohl_service.php" //this will be changed to the path on WH&W's server
    
    func downloadItems() {
        
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
        
    }
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let events: NSMutableArray = NSMutableArray()
        
        for(var i = 0; i < jsonResult.count; i++)
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let event = EventModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["Event_Name"] as? String,
                let address = jsonElement["Event_Address"] as? String,
                let start_date = jsonElement["Event_Start_Date"] as? String,
                let end_date = jsonElement["Event_End_Date"] as? String
            {
                
                event.name = name
                event.address = address
                event.start_date = start_date
                event.end_date = end_date
                
            }
            
            events.addObject(event)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.delegate.itemsDownloaded(events)
            
        })
    }
}
