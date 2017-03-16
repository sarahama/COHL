//
//  Event+CoreDataProperties.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/16/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var name: String?
    @NSManaged var time: NSDate?
    @NSManaged var info: String?
    @NSManaged var location: String?

}
