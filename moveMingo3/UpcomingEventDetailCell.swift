//
//  UpcomingEventDetailCell.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/6/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class UpcomingEventDetailCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var peopleGoing: UILabel!
    
    @IBOutlet weak var eventDetails: UILabel!
    
    @IBOutlet weak var interested: UIButton!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
