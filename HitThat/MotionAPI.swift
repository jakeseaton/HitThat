//
//  MotionAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/9/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

// Some things I learned about physics
// You would think that when you punch, the greatest acceleration points in the direction that you punch, but it actually turns out that the greatest instantaneous acceleration occurs when your arm stops moving, accelerating the phone to a stop. With this in mind, we can listen for instantaneous acceleration in the opposote direction of where we think someone is punching. Then, when this is across a certain threshold, we know that the user has thrust the phone in the opposite of that direction, and its absolute value will tell us how hard.
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
enum PunchLocation{
    case KneeCap, Gut, Face, Arm, Gizzard, BellyButton, Ass, Crotch, Throat, Nose, Shin, Chest, Slap
}
struct MotionAPI{
    static let motionsToSounds:[PunchType:String] = [
        .Jab : SoundAPI.jabSound,
        .Uppercut : SoundAPI.upperCutSound,
        .Block : SoundAPI.blockSound,
        .Kick : SoundAPI.kickSound
    ]
    static let upLocations:[PunchLocation] = [.Face, .Throat, .Nose]
    static let downLocations:[PunchLocation] = [.KneeCap, .Ass, .Shin]
    static let punchLocations: [PunchLocation] = [.Gut, .Arm, .Gizzard, .BellyButton, .Chest, .Slap]
    static let MessageForPunchLocation:[PunchLocation:String] = [
        .Gut:"Right in the Gut!",
        .Arm:"Jab to the Arm!",
        .Gizzard:"Right in the Gizzard!",
        .BellyButton:"Right in the Belly Button!",
        .Chest:"To the Chest!",
        .Face:"Head Shot!",
        .Throat:"Right in the Throat!",
        .Slap:"Bitch Slap!",
        .Nose:"Broken Nose!",
        .KneeCap:"Shattered Knee Caps!",
        .Ass:"Right in the Ass!",
        .Shin:"Go for the Shins!"
    ]
    static let threshold = 2.0
    static let interval = 0.01
    static let RegisterInterval = 0.1
    static let scale:Double = 25
    
    func analyzeMotion(deviceMotion:CMDeviceMotion, sender:AnyObject){
        let accelerationX = deviceMotion.userAcceleration.x
        let accelerationY = deviceMotion.userAcceleration.y
        let accelerationZ = deviceMotion.userAcceleration.z
        let rotationX = deviceMotion.rotationRate.x
        let attitideYaw = deviceMotion.attitude.yaw
        //println(accelerationX, accelerationY, accelerationZ)
        if let (punchType, punchLocation) = determinePunchType(accelerationX, accelerationY, accelerationZ){
            let damage:Double = calculateDamage(accelerationX, y: accelerationY, z: accelerationZ)
            let scaledDamage = damage / MotionAPI.scale
            if let fightOpenViewController = sender as? FightOpenViewController{
                fightOpenViewController.motionKit.stopDeviceMotionUpdates()
                dispatch_async(dispatch_get_main_queue()){
                    fightOpenViewController.handlePunch(CGFloat(scaledDamage), punchType: punchType, punchLocation: punchLocation)
                }
            }
            if let startFightViewController = sender as? StartFightViewController{
                startFightViewController.motionKit.stopDeviceMotionUpdates()
                dispatch_async(dispatch_get_main_queue()){
                    startFightViewController.handlePunch(CGFloat(scaledDamage), punchType: punchType, punchLocation: punchLocation)
                }
                
            }
            if let registerViewController = sender as? RegisterViewController{
                registerViewController.motionKit.stopDeviceMotionUpdates()
                dispatch_async(dispatch_get_main_queue()){
                    registerViewController.handlePunch(CGFloat(scaledDamage), punchType:punchType, punchLocation: punchLocation)
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
    func determinePunchType(tuple:(Double,Double,Double)) -> (PunchType, PunchLocation)?{
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
        // no motion
        case (.Normal, .Normal, .Normal):
            return nil
        // Phone thrust down
        case (_,.Positive, _):
            println("down!")
            let location = MotionAPI.downLocations.randomItem()
            return (.Jab, location)
        // Phone thrust up
        case (_, .Negative, _):
            println("up!")
            let location = MotionAPI.upLocations.randomItem()
            return (.Uppercut, location)
        // Phone thrust left
        case (.Positive, _, _ ):
            println("Punched with left!")
            let location = MotionAPI.punchLocations.randomItem()
            return (.Jab, location)
        // Phone thrust right
        case (.Negative, _, _):
            println("Punched with right!")
            let location = MotionAPI.punchLocations.randomItem()
            return (.Jab, location)
        // Phone thrust forward
        case (_,_,.Positive):
            println("forward")
            let location = MotionAPI.downLocations.randomItem()
            return (.Jab, location)
        default:
            return nil
        }

    }
}