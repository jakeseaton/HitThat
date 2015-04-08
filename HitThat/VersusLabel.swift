//
//  VersusLabel.swift
//  HitThat
//
//  Created by Jake Seaton on 4/8/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class VersusLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = Colors().versusLabelTextColor
    }

}
