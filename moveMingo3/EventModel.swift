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
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @start_date, @end_date, @organization, @color, @details, and @points parameters
    
    init(name: String, address: String, start_date: String, end_date: String, organization: String, color: String, details: String, points: String) {
        
        self.name = name
        self.address = address
        self.start_date = start_date
        self.end_date = end_date
        self.organization = organization
        self.color = color
        self.details = details
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Address: \(address), Start: \(start_date)), End: \(end_date)"
        
    }
    
    
}
