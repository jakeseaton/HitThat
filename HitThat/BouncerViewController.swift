//
//  ViewController.swift
//  Bouncer
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class BouncerViewController: UIViewController {

    let bouncer = BouncerBehavior()
    lazy var animator : UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(bouncer)
    }
    func addBlock() -> UIView{
        let block = UIView(frame: CGRect(origin: CGPoint.zeroPoint, size: Constants.BlockSize))
        block.center = CGPoint(x:view.bounds.midX, y:view.bounds.midY)
        view.addSubview(block)
        return block
    }

    var redBlock :UIView?
    // always put your constants in structs to avoid having magic numbers throughout your code
    struct Constants{
        static let BlockSize = CGSize(width: 40, height: 40)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if redBlock == nil{
            redBlock = addBlock()
            redBlock?.backgroundColor = UIColor.redColor()
            bouncer.addBlock(redBlock!)
        }
//        let motionManager = AppDelegate.Motion.Manager
//        if motionManager.accelerometerAvailable{
//            // arguments, error
//            // ALWAYS STOP THIS CODE. Obvious place is viewWillDisappear
//            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {(data, error) -> Void in
//                // set animator to acceleration of the
//                self.bouncer.gravity.gravityDirection = CGVector(dx: data.acceleration.x, dy: -data.acceleration.y)
//            }
//        }
        
    }
    // STOP THE UPDATES TO AVOID KILLING THE BATTERY
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
}

