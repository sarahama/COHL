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
    
    let URL_GET_STORE:String = "http://apps.healthyinthehills.com/manage_store.php"
    
    
    func customInit(reward: RewardModel, section: Int){
        
        self.reward_id = reward.reward_id!
        self.rewardTitle = reward.name!
        self.rewardCost = reward.cost! + " points"
        self.rewardStock = reward.stock! + " in stock"
        self.section = section
        
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
