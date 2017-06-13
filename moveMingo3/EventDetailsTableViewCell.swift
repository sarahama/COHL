
//
//  EventDetailsTableViewCell.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 5/11/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class EventDetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var eventTitle: UILabel!

    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var check_in: UIButton!
    
    
    @IBOutlet weak var interested: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
