//
//  LocateButton.swift
//  HitThat
//
//  Created by Jake Seaton on 3/31/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class LocateButton: UIButton {
    override func awakeFromNib(){
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor//Colors.color2.CGColor
        self.setTitleColor(Colors.color1, forState: .Normal)
    }
}
