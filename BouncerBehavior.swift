//
//  BouncerBehavior.swift
//  Bouncer
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class BouncerBehavior: UIDynamicBehavior {
   
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        // not a reference view thing, but we want to vconfigure it, so we use lazy
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

    // now these are child behavior
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(BlockBehavior)
    }
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
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
