//
//  EventTableCell.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 3/21/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {

    //properties
    @IBOutlet weak var eventTitle: UIButton!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var grayAdd: UIImageView!
    
    @IBOutlet weak var bulletPoint: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
