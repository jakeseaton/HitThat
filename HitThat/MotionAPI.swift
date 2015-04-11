//
//  MotionAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/9/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation
import CoreMotion

enum PunchType{
    case Jab, Uppercut, Block, Kick
}
enum MotionThreshold {
    case Normal//(Float)
    case Positive//(Float)
    case Negative//(Float)
}
struct MotionAPI{
    static let threshold = 2.0
    
    func analyzeMotion(deviceMotion:CMDeviceMotion, sender:AnyObject){
        let accelerationX = deviceMotion.userAcceleration.x
        let accelerationY = deviceMotion.userAcceleration.y
        let accelerationZ = deviceMotion.userAcceleration.z
        let rotationX = deviceMotion.rotationRate.x
        let attitideYaw = deviceMotion.attitude.yaw
        //println(accelerationX, accelerationY, accelerationZ)
        if let punchType = determinePunchType(accelerationX, accelerationY, accelerationZ){
            if let fightOpenViewController = sender as? FightOpenViewController{
                fightOpenViewController.motionKit.stopDeviceMotionUpdates()
                let damage:Double = calculateDamage(accelerationX, y: accelerationY, z: accelerationZ)
                let scaledDamage = damage / Double(10)
                //println(punchType)
                //println(damage)
                dispatch_async(dispatch_get_main_queue()){
                    fightOpenViewController.handlePunch(CGFloat(scaledDamage), punchType: punchType)
                }
            }
            if let startFightViewController = sender as? StartFightViewController{
                startFightViewController.motionKit.stopDeviceMotionUpdates()
                let damage:Double = calculateDamage(accelerationX, y: accelerationY, z: accelerationZ)
                let scaledDamage = damage / Double(10)
                //println(punchType)
                //println(damage)
                dispatch_async(dispatch_get_main_queue()){
                    startFightViewController.handlePunch(CGFloat(scaledDamage), punchType: punchType)
                }
                
            }
        }
        
    }
    
    // calculate the damage as the eucliean length of the acceleration vector
    func calculateDamage(x:Double, y:Double, z:Double) ->  Double{
        println("vector \(x,y,z)")
        let answer:Double = pow(x,2.0)  + pow(y,2.0) + pow(z,2.0)
        return sqrt(answer)
    }
    
    // HOLY FUCK THIS IS UGLY
    func determinePunchType(tuple:(Double,Double,Double)) -> PunchType?{
        var result:(MotionThreshold, MotionThreshold, MotionThreshold) = (.Normal, .Normal, .Normal)
        let (x,y,z) = tuple
        switch (x){
        case let positiveValue where positiveValue > MotionAPI.threshold:
            result.0 = .Positive
        case let negativeValue where negativeValue < -MotionAPI.threshold:
            result.0 = .Negative
        default:
            break
        }
        switch (y){
        case let positiveValue where positiveValue > MotionAPI.threshold:
            result.1 = .Positive
        case let negativeValue where negativeValue < -MotionAPI.threshold:
            result.1 = .Negative
        default:
            break
        }
        switch (z){
        case let positiveValue where positiveValue > MotionAPI.threshold:
            result.2 = .Positive
        case let negativeValue where negativeValue < -MotionAPI.threshold:
            result.2 = .Negative
        default:
            break
        }
        
        switch result {
        case (.Normal, .Normal, .Normal):
            return nil
        case (_,_,.Negative):
            return .Jab
        case (_,.Positive, _):
            return .Uppercut
        case (_,.Negative, _):
            return .Kick
        case(.Positive, _,_):
            return .Block
        case(.Negative, _,_):
            return .Block
        default:
            return .Jab
        }

    }
}