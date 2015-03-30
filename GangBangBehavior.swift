//
//  GangBangBehavior.swift
//  snatch
//
//  Created by Jake Seaton on 3/29/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class GangBangBehavior: UIDynamicBehavior {
    // Mark :- Code from Drop it
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    // feature of the language--lazy variables do not have to depend on initializers
    lazy var BlockBehavior : UIDynamicItemBehavior = {
        let lazilyCreatedBlockBehavior = UIDynamicItemBehavior()
        lazilyCreatedBlockBehavior.allowsRotation = true
        lazilyCreatedBlockBehavior.elasticity = 0.85
        lazilyCreatedBlockBehavior.friction = 0
        lazilyCreatedBlockBehavior.resistance = 0
        return lazilyCreatedBlockBehavior
        }()
    
    lazy var dropBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = true
        lazilyCreatedDropBehavior.elasticity = 0.75
        return lazilyCreatedDropBehavior
    }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(BlockBehavior)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    func addBarrier(path: UIBezierPath, named name: String){
        //        UIImage *patternImg = [UIImage imageNamed:@"SomePattern.png"];
        //        UIColor *fill = [UIColor colorWithPatternImage:patternImg];
        //        [path fill];
        if let curr = PFUser.currentUser(){
            if let img = curr["profilePicture"] as AnyObject as? PFFile {
                img.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    if error != nil {
                        println("ERROR RETRIEVING IMAGE")
                    }
                    else{
                        let fill = UIColor(patternImage: UIImage(data:imageData)!)
                        self.collider.removeBoundaryWithIdentifier(name)
                        self.collider.addBoundaryWithIdentifier(name, forPath: path)
                    }
                }
            }
            else{
                println("this didn't work")
            }
        }
        
    }
    
    func addDrop(drop:UIView){
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop:UIView){
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
    func addBlock(Block:UIView){
        dynamicAnimator?.referenceView?.addSubview(Block)
        gravity.addItem(Block)
        collider.addItem(Block)
        BlockBehavior.addItem(Block)
    }
    
    func removeBlock(Block:UIView){
        gravity.removeItem(Block)
        collider.removeItem(Block)
        BlockBehavior.removeItem(Block)
        Block.removeFromSuperview()
        
    }
    

    
}
