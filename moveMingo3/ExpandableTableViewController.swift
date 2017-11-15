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
    @IBOutlet weak var colorStrip: UIImageView!

    @IBOutlet weak var tableTitle: UILabel!
    @IBOutlet weak var fleckStrip: UIImageView!
//    var data : NSMutableData = NSMutableData()
    var feedItems: NSArray = NSArray()
    var selectedLocation : EventModel = EventModel()
    var selectedEvent: EventModel!
    var selectedEventAddress: String!
    
    let URL_CREATE_INTEREST:String = "http://apps.healthyinthehills.com/manage_interests.php"
    
    let URL_CHECK_IN:String = "http://apps.healthyinthehills.com/manage_attendance.php"
    
    
    override func viewDidLoad() {
        // set the ui if viewing interested events
        if (event_select_type == "interested") {
            self.colorStrip.image = UIImage(named: "greenStrip")
            self.tableTitle.text = "Interested Events"
            self.fleckStrip.image = UIImage(named: "greenFleckStrip")
        }
        // set for viewing current events for check in
        if (event_select_type == "current") {
            self.colorStrip.image = UIImage(named: "brownStrip")
            self.tableTitle.text = "Check In"
        }
        
        print(event_select_type)
        
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
        if ((feedItems[indexPath.section] as! EventModel).expanded! && event_select_type != "interested" && event_select_type != "attended") {
            print("finished setting")
            return 250
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
        // define the cell based on whether the event is occuring now or in the future
        let event = feedItems[indexPath.section] as! EventModel
        let eventStartTime = event.start_date?.components(separatedBy: " ")
        let eventDateStr = eventStartTime?[0]
        
        // get the current time
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own

        let eventDate = dateFormatter.date(from: eventDateStr!)
        
        
        // determine if the event is happening today or in the future
        if(currentDate < eventDate!) {
            let cell = Bundle.main.loadNibNamed("UpcomingEventDetailCell", owner: self, options: nil)?.first as! UpcomingEventDetailCell
            
            cell.eventDetails.text = event.details
            
            // add the interested action
            cell.interested.tag = Int(event.event_id!)!
            cell.points.text = event.points! + " pts"
            if(Int(event.count!)! > 0) {
                cell.peopleGoing.text = event.count! + " people interested"
            } else {
                cell.peopleGoing.text = "Be the first!"
            }
            cell.interested.addTarget(self, action:#selector(userIsInterested), for: .touchUpInside)
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("OccurringEventDetailCell", owner: self, options: nil)?.first as! OccurringEventDetailCell
            cell.eventDetails.text = event.details
            
            // add the check in action to the cell
            cell.checkIn.tag = Int(event.event_id!)!
            cell.points.text = event.points! + " pts"
            if(Int(event.count!)! > 0) {
                cell.peopleCheckedIn.text = event.count! + " people interested"
            } else {
                cell.peopleCheckedIn.text = "Be the first!"
            }
            cell.checkIn.addTarget(self, action:#selector(userIsCheckingIn), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        (feedItems[section] as! EventModel).expanded = !(feedItems[section] as! EventModel).expanded!
        
        tableView.beginUpdates()
        for i in 0 ..< 1{
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    
    
    // make a new record
    @objc func userIsInterested(sender:UIButton){
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "My Interests", message: "Would you like to add this to your interested events?", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Add Event", style: .default) { action in
            // create a new record
            print("the user is interested in something")
            print(sender.tag)
            //created NSURL
            let requestURL:NSURL = NSURL(string: self.URL_CREATE_INTEREST)!
            
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            print("the current user is")
            print(current_user_id)
            
            //getting values for insert
            
            let user_id = "\(current_user_id)"
            let event_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "user_id="+user_id+"&event_id="+event_id;
            print(postParameters)
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: .utf8)!
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                (data, response, error) in
                
                if error != nil{
                    print("error is \(String(describing: error))")
                    return;
                }
                print(data!)
                print("parsing response...")
                //parsing the response
                do {
                    //converting resonse to NSDictionary
                    
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    //parsing the json
                    if let parseJSON = myJSON {
                        
                        //creating a string
                        var msg : String!
                        var err : String!
                        
                        //getting the json response
                        msg = parseJSON["message"] as! String?
                        err = parseJSON["error"] as! String?
                        //printing the response
                        print(msg)
                        print(err)
                        
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        
        return
        
    }
    
    
    @objc func userIsCheckingIn(sender:UIButton){
        let alertController = UIAlertController(title: "Check In!", message: "Enter the event code to earn your points", preferredStyle: .alert)
        

        alertController.addAction(UIAlertAction(title: "Check in", style: .default, handler: {
            alert -> Void in
            //Section 1
            let code = alertController.textFields![0] as UITextField
            print(code.text ?? "")
            
            print("the user is checking in to something")
            print(sender.tag)
            //created NSURL
            let requestURL:NSURL = NSURL(string: self.URL_CHECK_IN)!
            
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            print("the current user is")
            print(current_user_id)
            
            //getting values for insert
            
            let user_id = "\(current_user_id)"
            let event_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "user_id="+user_id+"&event_id="+event_id+"&code="+code.text!;
            print(postParameters)
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: .utf8)!
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print("error is \(String(describing: error))")
                    return;
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print(httpStatus.statusCode)
                }
                print(data!)
                print("parsing response...")
                //parsing the response
                do {
                    //converting resonse to NSDictionary
                    
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .  mutableContainers) as? NSDictionary
                    
                    //parsing the json
                    if let parseJSON = myJSON {
                        
                        //creating a string
                        var msg : String!
                        var err : String!
                        
                        //getting the json response
                        msg = parseJSON["message"] as! String?
                        err = parseJSON["error"] as! String?
                        //printing the response
                        print(msg)
                        print(err)
                        
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()

            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
            
        //Section 2
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Event Code"
            textField.textAlignment = .center
            textField.isSecureTextEntry = true
        })
        
        self.present(alertController, animated: true)
        

        
        return
        
    }

    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected")
//        let simpleVC = SimpleViewController()
//
//        print("initialize")
//        simpleVC.customInit(imageName: "BackgroundMountain")
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("push to navigation")
//        self.navigationController?.pushViewController(simpleVC, animated: true)
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
