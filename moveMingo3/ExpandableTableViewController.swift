//
//  ExpandableTableViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 6/12/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class ExpandableTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalendarModelProtocal, ExpandableHeaderViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var feedItems: NSArray = NSArray()
    var selectedLocation : EventModel = EventModel()
    var selectedEvent: EventModel!
    var selectedEventAddress: String!
    
//    var sections = [
//    
//        Section(genre: "Animation",
//                movies: ["The Lion King", "Tarzan", "Tangled"],
//                expanded: false),
//        
//        Section(genre: "Superhero",
//                movies: ["Wonder Woman", "Batman"],
//                expanded: false),
//        
//        Section(genre: "Thriller",
//                movies: ["Disturbia", "Get Out"],
//                expanded: false)
//        
//    ]
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates and initialize homeModel
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let calendarModel = CalendarModel()
        calendarModel.delegate = self
        calendarModel.downloadItems(select_type: event_select_type)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of feed items
        print("size of events list")
        print(feedItems.count)
        return feedItems.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("setting height")
        if ((feedItems[indexPath.section] as! EventModel).expanded)! {
            print("finished setting")
            return 200
        } else {
            print("finished setting")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let header = ExpandableHeaderView()
        header.customInit(event: (feedItems[section] as! EventModel), section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = "details"
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        (feedItems[section] as! EventModel).expanded = !(feedItems[section] as! EventModel).expanded!
        
        tableView.beginUpdates()
        for i in 0 ..< 1{
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let simpleVC = SimpleViewController()
        // simpleVC.customInit(imageName: sections[indexPath.section].movies[indexPath.row])
        print("initialize")
        simpleVC.customInit(imageName: "BackgroundMountain")
        tableView.deselectRow(at: indexPath, animated: true)
        print("push to navigation")
        self.navigationController?.pushViewController(simpleVC, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
