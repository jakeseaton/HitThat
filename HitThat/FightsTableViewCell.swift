//
//  FightsTableViewCell.swift
//  snatch
//
//  Created by Jake Seaton on 3/25/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightsTableViewCell: PFTableViewCell {
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // do the segue here
        // Configure the view for the selected state
    }

}
