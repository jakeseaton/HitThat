//
//  RandomArray.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

extension Array{
    func randomItem() -> T{
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
