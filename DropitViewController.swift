//
//  DropitViewController.swift
//  Dropit
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {

   
    @IBOutlet weak var gameView: BezierPathsView!
    
    // cannot access own properties and methods until you are done initializing
    lazy var animator: UIDynamicAnimator = {
        // in this case, there is something that has not been initialized, so we use a lazy closure
       let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamicAnimator.delegate = self
        return lazilyCreatedDynamicAnimator
    }()
    let bouncer = BouncerBehavior()
    let dropitBehavior = DropitBehavior()
    // only have it when panning
    var attachment:UIAttachmentBehavior?{
        willSet{
            animator.removeBehavior(attachment)
            gameView.setPath(nil, named:PathNames.Attachment)
        }
        didSet{
            if attachment != nil{
                animator.addBehavior(attachment)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView{
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
                
                
            }
        }
    }
    
    
    @IBAction func drop(sender: AnyObject) {
        drop()
    }
    @IBAction func grabDrop(sender: UIGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state{
        case .Began:
            if let viewToAttachTo = lastDroppedView{
                attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor:gesturePoint)
                lastDroppedView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default:break
            
        }
    }
    var lastDroppedView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(bouncer)
        animator.addBehavior(dropitBehavior)
    }
    struct PathNames{
    static let MiddleBarrier = "Middle Barrier"
    static let Attachment = "Attachment"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x:gameView.bounds.midX-barrierSize.width/2, y: gameView.bounds.midY-barrierSize.height/2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, named:PathNames.MiddleBarrier)
        gameView.setPath(path, named:PathNames.MiddleBarrier)
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    var dropsPerRow = 10
    
    var dropSize:CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width:size, height:size)
    }

    
    func drop(){
        var frame = CGRect(origin:CGPointZero, size:dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame:frame)
        dropView.backgroundColor = UIColor.random
        if let curr = PFUser.currentUser(){
            if let img = curr["profilePicture"] as AnyObject as? PFFile {
                img.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    if error != nil {
                        println("ERROR RETRIEVING IMAGE")
                    }
                    else{
                        dropView.backgroundColor = UIColor(patternImage: UIImage(data:imageData)!)
                        self.dropitBehavior.addDrop(dropView)
                        self.lastDroppedView = (dropView)
                    }
                }
            }
            else{
                println("this didn't work")
            }
        }
    // put little boxes along the top
    }
    
    
}
func removeCompletedRow(){
    println("found a completed row")
}

// private so that only I can use them, and so that it doesn't conflict. private to this file
private extension CGFloat {
    static func random(max:Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor{
    class var random: UIColor {
        switch arc4random()%5{
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.redColor()
        case 3: return UIColor.purpleColor()
        case 4: return UIColor.blackColor()
        default: return UIColor.blackColor()

        }
    }
}