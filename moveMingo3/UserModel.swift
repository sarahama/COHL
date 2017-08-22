//
//  UserModel.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/17/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    //properties
    
    var name: String?
    var email: String?
    var profile_path: String?
    var date_joined: String?
    var current_points: String?
    var total_points: String?
    var phone:String?
    var user_id:Int?

    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @start_date, @end_date, @organization, @color, @details, and @points parameters
    
    init(name: String, email: String, date_joined: String, profile_path: String, current_points: String, total_points: String, phone: String, user_id: Int) {
        
        self.name = name
        self.email = email
        self.date_joined = date_joined
        self.profile_path = profile_path
        self.current_points = current_points
        self.total_points = total_points
        self.phone = phone
        self.user_id = user_id
    }
    
}
