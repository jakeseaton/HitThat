//
//  MotionAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/9/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation
import CoreMotion

struct MotionAPI{
    func analyzeMotion(deviceMotion:CMDeviceMotion, sender:AnyObject){
        let accelerationX = deviceMotion.userAcceleration.x
        let accelerationY = deviceMotion.userAcceleration.y
        let accelerationZ = deviceMotion.userAcceleration.z
        let rotationX = deviceMotion.rotationRate.x
        let attitideYaw = deviceMotion.attitude.yaw
        println(accelerationZ)
        if (accelerationZ < -3.0){
            let scaledDamage = abs(accelerationZ) / Double(10)
            if let fightOpenViewController = sender as? FightOpenViewController{
                fightOpenViewController.motionKit.stopDeviceMotionUpdates()
                dispatch_async(dispatch_get_main_queue()){
                    fightOpenViewController.handlePunch(CGFloat(scaledDamage))
                }
            }
        }
    }
}
