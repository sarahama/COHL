//
//  FriendsHeaderFooterView.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class FriendsHeaderFooterView: UITableViewHeaderFooterView {
    
    var section: Int!
    var userName: String!

    
    
    func customInit(user: UserModel, section: Int){
        
        self.userName = user.name!
        self.section = section
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add the bullet image
        let bulletImage = UIImageView(image: #imageLiteral(resourceName: "tealAdd"))
        bulletImage.frame = CGRect(x: 15, y: 30, width: 15, height: 15)
        self.contentView.addSubview(bulletImage)
        
        
        // add the user name
        let userNameLabel = UILabel()
        userNameLabel.text = self.userName
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        userNameLabel.frame = CGRect(x: 40, y: self.bounds.height/2 - 15, width: 250, height: 35)
        self.contentView.addSubview(userNameLabel)
        
        
        
        
        // change the header background to white
        self.contentView.backgroundColor = UIColor.white
    }
    


}
