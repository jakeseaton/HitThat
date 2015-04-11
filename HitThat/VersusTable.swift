//
//  VersusTable.swift
//  HitThat
//
//  Created by Jake Seaton on 4/10/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class VersusTable: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scrollEnabled = false
        self.allowsSelection = false
        self.backgroundColor = UIColor.clearColor()
    }
}
