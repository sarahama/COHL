//
//  EventsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 2/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarModelProtocal {

    //Properties
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : EventModel = EventModel()
    @IBOutlet weak var eventListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates and initialize homeModel
        
        self.eventListTableView.delegate = self
        self.eventListTableView.dataSource = self
        
        let calendarModel = CalendarModel()
        calendarModel.delegate = self
        calendarModel.downloadItems()
        
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.eventListTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: EventTableCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EventTableCell
        // Get the event to be shown
        let item: EventModel = feedItems[indexPath.row] as! EventModel
        // Set the title, address, and time for each cell
        myCell.eventTitle!.setTitle(item.name, forState: UIControlState())
        myCell.address!.text = item.address
        myCell.date!.text = item.start_date
        
        return myCell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
