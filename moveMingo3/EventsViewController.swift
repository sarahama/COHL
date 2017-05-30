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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates and initialize homeModel
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let calendarModel = CalendarModel()
        calendarModel.delegate = self
        calendarModel.downloadItems()
    
        // load the table
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
        
    }
    
    func itemsDownloaded(_ items: NSArray) {
        
        feedItems = items
        
        self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        print("size of events list")
        print(feedItems.count)
        return feedItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        print("here")
        let cellIdentifier: String = "BasicCell"

        let myCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! EventTableCell
        
        // Get the event to be shown
        let item: EventModel = feedItems[indexPath.row] as! EventModel
        
        // Set the title, address, and time for each cell
        myCell.eventTitle!.setTitle(item.name, for: UIControlState())
        myCell.address!.text = item.address
        myCell.date!.text = item.start_date
        
        print("cell title")
        print(myCell.eventTitle)
        
        
        return myCell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
