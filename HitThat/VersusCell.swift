//
//  VersusCell.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class VersusCell: UITableViewCell {
    @IBOutlet weak var userLabel:UILabel!
    @IBOutlet weak var opponentLabel:UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
