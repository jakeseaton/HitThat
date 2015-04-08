//
//  Shapes.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct Shapes{
    func circularImage(img:UIImageView){
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true
    }
}