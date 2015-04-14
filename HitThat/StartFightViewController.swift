//
//  StartFightViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/10/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class StartFightViewController: UIViewController, CFPressHoldButtonDelegate {
    
    let motionKit = MotionKit()
    
        @IBAction func manualPunchPressed(sender: AnyObject) {
            self.handlePunch(CGFloat(0.10), punchType: .Jab, punchLocation: .Gut)
        }
    
    @IBOutlet weak var punchBlur: BlurView!
        // Public API
        var userIsOrigin = true

        var fightToDisplay:PFObject?{
            willSet{
                setStaminaBars(newValue!)
            }
        }
        var recipientUser:PFUser?
    
        var opponentStamina:CGFloat?{
            willSet{
                self.opponentStaminaBar?.setProgress(newValue!, animated:true)
            }
        }
        
        @IBOutlet weak var opponentStaminaBar: YLProgressBar!

        private func setStaminaBars(fight:PFObject){
            let recipientStamina = fight["recipientStamina"] as AnyObject as CGFloat
            self.opponentStamina = recipientStamina
        }
        
        // Image
        @IBOutlet weak var opponentImage: UIImageView!
        
        // Sounds
        var soundArray:[AVAudioPlayer]?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.punchBlur?.pressHoldButtonDelegate = self
            self.soundArray = SoundAPI().getArrayOfFightSoundPlayers()
            Colors().favoriteBackGroundColor(self)
            Colors().configureStaminaBar(opponentStaminaBar!, user: false)
            
            let user = PFUser.currentUser()

            let recipient:PFUser = fightToDisplay?["recipient"] as PFUser
            recipient.fetchIfNeeded()
            self.recipientUser = recipient
            setStaminaBars(self.fightToDisplay!)
            ParseAPI().installAUsersProfilePicture(recipient, target: self.opponentImage)
        }

        override func viewWillDisappear(animated: Bool) {
            self.motionKit.stopDeviceMotionUpdates()
        }
        
        
        // Mark := Handling Punches
    func handlePunch(damage:CGFloat, punchType:PunchType, punchLocation:PunchLocation){
            switch punchType{
            case .Block:
                println("block!")
            case .Jab:
                println("Jab")
            case .Uppercut:
                println("uppercut!")
            case .Kick:
                println("kick!")
            default:
                break
            }
            self.soundArray?.randomItem().play()
            let newStamina:CGFloat = self.opponentStamina! - damage
            self.opponentStamina = newStamina
            self.fightToDisplay!.setObject(opponentStamina, forKey: "recipientStamina")
            fightToDisplay!.setObject(PFUser.currentUser(), forKey: "lastTurn")
            fightToDisplay!.saveInBackground()
            ParseAPI().notifyPunchedUser(self.recipientUser!, fightObject:fightToDisplay!, sound:SoundAPI.notificationSound)
            Constants().refreshFightsTable()
            self.performSegueWithIdentifier(Constants.FightStartedSegue, sender: self.fightToDisplay!)
            //self.performSegueWithIdentifier(Constants.UnwindFromNewFight, sender: self)
            
        }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.FightStartedSegue{
            if let fightOpenViewController = segue.destinationViewController as? FightOpenViewController{
                fightOpenViewController.fightToDisplay = self.fightToDisplay
            }
        }
    }
    func didStartHolding(targetView: UIView!) {

        // change the style instead?
        self.punchBlur.hidden = true
            motionKit.getDeviceMotionObject(interval: MotionAPI.interval) {
                (deviceMotion) in
                MotionAPI().analyzeMotion(deviceMotion, sender:self)
            }
        
    }
    
    func didFinishHolding(targetView: UIView!) {
        self.punchBlur.hidden = false
        self.motionKit.stopDeviceMotionUpdates()
    }
}
