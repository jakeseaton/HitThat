//
//  TWTButton.swift
//  TB_TwitterHeader
//
//  Created by Yari D'areglia on 10/01/15.
//  Copyright (c) 2015 Yari D'areglia. All rights reserved.
//

import UIKit

class TWTButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 238.0/255.0, alpha: 1.0).CGColor
        
    }

}
