//
//  BezierPathsView.swift
//  Dropit
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {

    // Dictionary
    private var bezierPaths = [String:UIBezierPath]()

    func setPath(path:UIBezierPath?, named name: String){
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    override func drawRect(rect:CGRect){
        for (_,path) in bezierPaths{
            path.stroke()
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
