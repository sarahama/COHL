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
    var eventStart: String!
    
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
        self.eventPoints = event.points!
        self.eventAddress = event.address!
        self.section = section
        self.delegate = delegate
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
        
        // add the event points
        let eventPoints = UILabel()
        eventPoints.text = self.eventPoints
        eventPoints.font = eventPoints.font.withSize(16)
        eventPoints.frame = CGRect(x: 30, y: 40, width: 250, height: 35)
        self.contentView.addSubview(eventPoints)
        
        // add the event address
        let eventAddress = UILabel()
        eventAddress.text = self.eventAddress
        eventAddress.font = eventAddress.font.withSize(14)
        eventAddress.frame = CGRect(x: 30, y: 60, width: 250, height: 35)
        self.contentView.addSubview(eventAddress)
        
        // add the event date
        let eventDate = UILabel()
        eventDate.text = self.eventStart
        eventDate.font = eventDate.font.withSize(14)
        eventDate.frame = CGRect(x: 30, y: 80, width: 150, height: 35)
        self.contentView.addSubview(eventDate)
        
        // add the event time
        let eventTime = UILabel()
        eventTime.text = "3:00 PM"
        eventTime.font = eventTime.font.withSize(14)
        eventTime.frame = CGRect(x: 190, y: 80, width: 100, height: 35)
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
