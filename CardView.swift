//
//  CardView.swift
//  HitThat
//
//  Created by Jake Seaton on 3/27/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class CardView: UIView {
    var object:PFObject?
    override init(){
        super.init()
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    func setup(){
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.33
        self.layer.shadowOffset = CGSizeMake(0,1.5)
        self.layer.shadowRadius = 4.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
}
