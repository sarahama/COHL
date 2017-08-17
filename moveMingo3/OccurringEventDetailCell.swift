//
//  OccurringEventDetailCell.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/6/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class OccurringEventDetailCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var peopleCheckedIn: UILabel!
    
    @IBOutlet weak var checkIn: UIButton!
    
    @IBOutlet weak var eventDetails: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
