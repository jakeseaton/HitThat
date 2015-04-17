//
//  OrangeButton.swift
//  HitThat
//
//  Created by Jake Seaton on 4/17/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class OrangeButton: UIButton {
    override func awakeFromNib(){
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor() //Colors.color1//UIColor.whiteColor()
        self.layer.borderColor = Colors.color1.CGColor//UIColor.whiteColor().CGColor//Colors.color2.CGColor
        self.setTitleColor(Colors.color1, forState: .Normal)
    }
}
