//
//  EventModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 3/20/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import Foundation

class EventModel: NSObject {
    //properties
    
    var name: String?
    var address: String?
    var start_date: String?
    var end_date: String?
    var organization: String?
    var color: String?
    var details: String?
    var event_id: String?
    var points: String?
    var expanded: Bool?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @start_date, @end_date, @organization, @color, @details, and @points parameters
    
    init(name: String, address: String, start_date: String, end_date: String, organization: String, color: String, details: String, event_id: String, points: String) {
        
        self.name = name
        self.address = address
        self.start_date = start_date
        self.end_date = end_date
        self.organization = organization
        self.color = color
        self.details = details
        self.event_id = event_id
        self.points = points
        self.expanded = false
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(String(describing: name)), Address: \(String(describing: address)), Start: \(String(describing: start_date))), End: \(String(describing: end_date))"
        
    }
    
    
}
