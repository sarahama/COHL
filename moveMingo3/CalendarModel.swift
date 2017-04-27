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
    let urlPath: String = "http://localhost/cohl_service.php"
    

    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        var session: Foundation.URLSession!
        let configuration = URLSessionConfiguration.default
        
        
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url)
        
        task.resume()
        
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
        
    }
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do {
            //jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSMutableArray
            
            let jsonResult1 = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as? NSArray
            
            jsonResult = NSMutableArray(array: jsonResult1!)
            
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let events: NSMutableArray = NSMutableArray()
        
        for i in 1...jsonResult.count
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
            
            events.add(event)
   
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(events)
            
        })
   }
}
