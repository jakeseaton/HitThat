//
//  WhiteLabel.swift
//  HitThat
//
//  Created by Jake Seaton on 4/13/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class WhiteLabel:UILabel{
    override func awakeFromNib() {
        self.textColor = UIColor.whiteColor()   
    }
}