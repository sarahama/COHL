//
//  StoreHeaderFooterView.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/30/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class StoreHeaderFooterView: UITableViewHeaderFooterView {

    
    var section: Int!
    var rewardTitle: String!
    var rewardCost: String!
    var rewardStock: String!
    var reward_id: Int!
    
    let URL_GET_STORE:String = "http://Sarahs-MacBook-Pro-2.local/COHL/manage_store.php"
    
    //    override init(reuseIdentifier: String?) {
    //        super.init(reuseIdentifier: reuseIdentifier)
    //        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    //    func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
    //        let cell = gestureRecognizer.view as! ExpandableHeaderView
    //        delegate?.toggleSection(header: self, section: cell.section)
    //    }
    
    func customInit(reward: RewardModel, section: Int){
        
        self.reward_id = reward.reward_id!
        self.rewardTitle = reward.name!
        self.rewardCost = reward.cost! + " points"
        self.rewardStock = reward.stock! + " in stock"
        self.section = section
        
        //let originalStartDate = event.start_date?.components(separatedBy: " ")
        
        //
        //        let startDate = originalStartDate?[0]
        //        let startTime = originalStartDate?[1]
        //
        
        //        // format the dates
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd" //Your New Date format as per requirement change it own
        //
        //        let dateStartDate = dateFormatter.date(from: startDate!)
        //
        
        
        //
        //        // format the times
        //        let timeFormatter = DateFormatter()
        //        timeFormatter.dateFormat = "h:mm:ss"
        
        
        //        let timeStartTime = dateFormatter.date(from: startDate!)
        //        let timeEndTime = dateFormatter.date(from: endDate!)
        //
        //        self.eventTime = self.eventTime + timeFormatter.string(from: timeStartTime!)
        //            + " - " + timeFormatter.string(from: timeEndTime!)
        //
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add the bullet image
        let bulletImage = UIImageView(image: #imageLiteral(resourceName: "blackBullet"))
        bulletImage.frame = CGRect(x: 5, y: 45, width: 15, height: 15)
        self.contentView.addSubview(bulletImage)
        
        
        // add the rewards title
        let rewardName = UILabel()
        rewardName.text = self.rewardTitle
        rewardName.font = UIFont.boldSystemFont(ofSize: 18)
        rewardName.frame = CGRect(x: 30, y: 20, width: 250, height: 35)
        self.contentView.addSubview(rewardName)
        
        // add the reward cost
        let rewardCost = UILabel()
        rewardCost.text = self.rewardCost
        rewardCost.font = rewardCost.font.withSize(16)
        rewardCost.frame = CGRect(x: 30, y: 40, width: 250, height: 35)
        self.contentView.addSubview(rewardCost)
        
        // add the event address
        let rewardStock = UILabel()
        rewardStock.text = self.rewardStock
        rewardStock.font = rewardStock.font.withSize(14)
        rewardStock.frame = CGRect(x: 30, y: 60, width: 250, height: 35)
        self.contentView.addSubview(rewardStock)
        
        
        
        
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
