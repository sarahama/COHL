//
//  CustomInputTextField.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 8/16/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class CustomInputTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, 15, 0, 15))
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, 15, 0, 15))
    }

}
