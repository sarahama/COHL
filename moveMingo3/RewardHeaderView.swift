//
//  RewardHeaderView.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/27/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
//
//protocol RewardHeaderView{
//    func toggleSection(header: ExpandableHeaderView, section: Int)
//}

class RewardHeaderView: UITableViewHeaderFooterView {

    var section: Int!
    var rewardTitle: String!
    var rewardCost: String!
    var rewardStock: String!
    var status: String!
    
    func customInit(reward: RewardModel, section: Int){
        
        self.rewardTitle = reward.name!
        self.rewardCost = reward.cost! + " points"
        self.rewardStock = reward.stock! + " in stock"
        self.section = section
        self.status = "Status: "
        
        if (reward.completed!){
            self.status = self.status + "completed"
        } else if(reward.available!) {
            self.status = self.status + "ready for pick up at WHW!"
        } else {
            self.status = self.status + "processing order"
        }
        
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
        
        // add the stock
        let rewardStock = UILabel()
        rewardStock.text = self.rewardStock
        rewardStock.font = rewardStock.font.withSize(14)
        rewardStock.frame = CGRect(x: 30, y: 60, width: 250, height: 35)
        self.contentView.addSubview(rewardStock)
        
        
        // add the stock
        let rewardStatus = UILabel()
        rewardStatus.text = self.status
        rewardStatus.font = rewardStock.font.withSize(14)
        rewardStatus.frame = CGRect(x: 30, y: 80, width: 250, height: 35)
        self.contentView.addSubview(rewardStatus)
 
        
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
