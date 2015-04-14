//
//  BlurView.swift
//  HitThat
//
//  Created by Jake Seaton on 4/13/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class BlurView: UIVisualEffectView {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
}
