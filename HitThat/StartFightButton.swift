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
        self.layer.borderColor = Colors.opponentColor1.CGColor
        self.setTitleColor(Colors.opponentColor1, forState: .Normal)

    }
}
