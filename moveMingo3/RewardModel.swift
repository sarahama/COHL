//
//  Reward.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/27/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import Foundation

class RewardModel: NSObject {

    //properties
    
    var name: String?
    var cost: String?
    var stock: String?
    var for_sale: Bool?
    var available: Bool?
    var completed: Bool?
    var reward_id: Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct
    
    init(reward_id: Int, name: String, cost: String, stock: String, for_sale: Bool, available: Bool?, completed: Bool) {
        
        self.reward_id = reward_id
        self.name = name
        self.cost = cost
        self.stock = stock
        self.for_sale = for_sale
        self.available = available
        self.completed = completed
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(String(describing: name))"
        
    }
    
}
