//
//  ExpandableHeaderView.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 6/12/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate{
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {

    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    var eventTitle: String!
    var eventPoints: String!
    var eventAddress: String!
    var eventDate: String!
    var eventTime: String!
    var timeColor: UIColor!
    var eventCount: String!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(event: EventModel, section: Int, delegate: ExpandableHeaderViewDelegate){
        
        //self.textLabel?.text = title
        //self.eventTitle = title
        self.eventTitle = event.name!
        self.eventPoints = event.points! + " points"
        self.eventAddress = event.address!
        
        if (event.count == "0"){
            self.eventCount = "Be the first to go!"
        } else if(event.count == "1"){
            self.eventCount = event.count! + " person is interested"
        } else{
            self.eventCount = event.count! + " people are interested"
        }
        self.section = section
        self.delegate = delegate
        let originalStartDate = event.start_date?.components(separatedBy: " ")
        let originalEndDate = event.end_date?.components(separatedBy: " ")
        
        let startDate = originalStartDate?[0]
        let stconfigartTime = originalStartDate?[1]
        
        let endDate = originalEndDate?[0]
        let endTime = originalEndDate?[1]
        
        // format the dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own
        
        let dateStartDate = dateFormatter.date(from: startDate!)
        // let dateEndDate = dateFormatter.date(from: endDate!)
        
        // assume events are only one day long
        self.eventDate = dateFormatter.string(from: dateStartDate!)

        
        // if the event is occurring today, say "Today" and change the color
        let currentDate = Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own
        
        let compareStart = dateFormatter2.date(from: startDate!)
        let compareEnd = dateFormatter2.date(from: endDate!)
        
        if (currentDate >= compareStart! && currentDate <= compareEnd!) {
            self.timeColor = UIColor.init(red: 77.0/255.0, green: 136.0/255.0, blue: 135.0/255.0, alpha: 1)
            self.eventTime = "Today "
        } else {
            self.timeColor = UIColor.black
            self.eventTime = ""
        }
        

        
        // format the times
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"

        
        let timeStartTime = dateFormatter.date(from: startDate!)
        let timeEndTime = dateFormatter.date(from: endDate!)
        
        self.eventTime = self.eventTime + timeFormatter.string(from: timeStartTime!)
            + " - " + timeFormatter.string(from: timeEndTime!)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add the bullet image
        let bulletImage = UIImageView(image: #imageLiteral(resourceName: "blackBullet"))
        bulletImage.frame = CGRect(x: 5, y: 45, width: 15, height: 15)
        self.contentView.addSubview(bulletImage)
        
        // add the plus sign image
        let signImage = UIImageView(image: #imageLiteral(resourceName: "grayAdd"))
        signImage.frame = CGRect(x: 290, y: 45, width: 15, height: 15)
        self.contentView.addSubview(signImage)
        
        // add the event title
        let eventTitle = UILabel()
        eventTitle.text = self.eventTitle
        eventTitle.font = UIFont.boldSystemFont(ofSize: 18)
        eventTitle.frame = CGRect(x: 30, y: 20, width: 250, height: 35)
        self.contentView.addSubview(eventTitle)
        

        
        // add the event address
        let eventAddress = UILabel()
        eventAddress.text = self.eventAddress
        eventAddress.font = eventAddress.font.withSize(14)
        eventAddress.frame = CGRect(x: 30, y: 40, width: 250, height: 35)
        self.contentView.addSubview(eventAddress)
        
        // add the event date
        let eventDate1 = UILabel()
        
        if ((self.eventDate) != nil) {
            // if date is not nil, change the format
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMMM dd, yyyy"
            let dateStartDate = dateFormatter1.date(from: self.eventDate!)
            
            // assume events are only one day long
            let newDate = dateFormatter2.string(from: dateStartDate!)
            eventDate1.text = newDate
            
        } else {
            eventDate1.text = ""
        }
        
        eventDate1.font = eventDate1.font.withSize(14)
        eventDate1.frame = CGRect(x: 30, y: 60, width: self.bounds.size.width - 60 , height: 35)
        self.contentView.addSubview(eventDate1)
        
        // add the event time
        let eventTime = UILabel()
        eventTime.text = self.eventTime
        eventTime.textColor = self.timeColor
        eventTime.font = eventTime.font.withSize(14)
        eventTime.frame = CGRect(x: 30, y: 90, width: self.bounds.size.width - 60 , height: 35)
        self.contentView.addSubview(eventTime)
        
        //self.contentView.addSubview(self.textLabel!)
        //self.textLabel?.textColor = UIColor.black
        
        // change the header background to white
        self.contentView.backgroundColor = UIColor.white
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
