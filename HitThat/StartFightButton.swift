//
//  StartFightButton.swift
//  HitThat
//
//  Created by Jake Seaton on 4/16/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class StartFightButton: LocateButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2.0
//        self.backgroundColor = Colors.opponentColor1
        self.layer.borderColor = UIColor.whiteColor().CGColor  //Colors.opponentColor1.CGColor
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal) //Colors.opponentColor1
        self.backgroundColor = Colors.opponentColor1

    }
}
