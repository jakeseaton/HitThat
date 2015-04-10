//
//  FightOpenViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightOpenViewController: UIViewController{
    let motionKit = MotionKit()
    @IBAction func stopUpdatesPressed(sender: AnyObject) {
        self.motionKit.stopDeviceMotionUpdates()
    }
    @IBAction func manualPunchPressed(sender: AnyObject) {
        self.handlePunch(CGFloat(0.25))
    }
    @IBAction func punchPressed(sender:AnyObject){
        if self.isUsersTurn!{
            motionKit.getDeviceMotionObject(interval: 0.2) {
                (deviceMotion) in
                MotionAPI().analyzeMotion(deviceMotion, sender:self)
            }
            
        }
        else{
            UIAlertView(title: "Wait your turn", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
            self.isUsersTurn = true
        }
        
    }
    @IBAction func goBackPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Public API

    var isUsersTurn:Bool?{
        willSet{
            self.turnLabel.text = newValue! ? "YOU TURN" : "THEIR TURN"
        }
    }
    var userIsOrigin:Bool?
    var fightToDisplay:PFObject?{
        didSet{
            updateUI()
        }
        willSet{
            if let hack = userIsOrigin{
                setStaminaBars(newValue!)
            }
        }
    }
    var originUser:PFUser?{
        didSet{
            updateUI()
        }
    }
    var recipientUser:PFUser?{
        didSet{
            updateUI()
        }
    }
    func refreshFight(){
        if let curr = fightToDisplay{
            let query = ParseAPI().fightsQuery()
            query.getObjectInBackgroundWithId(curr.objectId){
                (object, error) in
                if (error == nil){
                    self.fightToDisplay = object
                }
            }
        }
    }
    

    // Stamina Properties and Outlets
    var userStamina:CGFloat?{
        willSet{
        self.userStaminaBar?.setProgress(newValue!, animated: true)
        }
    }
    var opponentStamina:CGFloat?{
        willSet{
            self.opponentStaminaBar?.setProgress(newValue!, animated:true)
        }
    }
    
    @IBOutlet weak var userStaminaBar: YLProgressBar!
    @IBOutlet weak var opponentStaminaBar: YLProgressBar!
    @IBOutlet weak var turnLabel: UILabel!
    
    private func setStaminaBars(fight:PFObject){
        let originStamina = fight["originStamina"] as AnyObject as CGFloat
        let recipientStamina = fight["recipientStamina"] as AnyObject as CGFloat
        self.userStamina = userIsOrigin! ? originStamina : recipientStamina
        self.opponentStamina = userIsOrigin! ? recipientStamina : originStamina
    }
    
    // Image
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var opponentImage: UIImageView!
    
    // Sounds
    var soundArray:[AVAudioPlayer]?
    var victorySound:AVAudioPlayer?
    var lossSound:AVAudioPlayer?

    func updateUI(){}
    
    override func viewDidLoad() {

        self.isUsersTurn = true
        self.soundArray = SoundAPI().getArrayOfSoundsPlayers()
        self.victorySound = SoundAPI().getVictorySound()
        self.lossSound = SoundAPI().getLossSound()
        Colors().favoriteBackGroundColor(self)
        Colors().configureStaminaBar(userStaminaBar!)
        Colors().configureStaminaBar(opponentStaminaBar!)
        
        let user = PFUser.currentUser()
        let fight = self.fightToDisplay!
        let origin = fight["origin"] as PFUser
        let recipient = fight["recipient"] as PFUser
        
        if (origin.objectId == user.objectId){
            self.userIsOrigin = true
            self.originUser = user
            self.recipientUser = ParseAPI().userQuery().getObjectWithId(recipient.objectId) as? PFUser
        }
        else{
            self.userIsOrigin = false
            self.recipientUser = user
            // synchronous queries for user info,b ec
            self.originUser = ParseAPI().userQuery().getObjectWithId(origin.objectId) as? PFUser
        }
        
        setStaminaBars(self.fightToDisplay!)

        if self.userIsOrigin!{
            ParseAPI().installAUsersProfilePicture(self.originUser!, target: self.userImage)
            ParseAPI().installAUsersProfilePicture(self.recipientUser!, target: self.opponentImage)

        }
        else{
            ParseAPI().installAUsersProfilePicture(self.recipientUser!, target: self.userImage)
            ParseAPI().installAUsersProfilePicture(self.originUser!, target: self.opponentImage)
        }
    }
    override func viewWillAppear(animated: Bool) {
        // AppDelegate.Motion.Manager.startAccelerometerUpdates()
    }
    override func viewDidAppear(animated: Bool) {
        //self.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        self.motionKit.stopDeviceMotionUpdates()
        //AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
    // Mark := Analyzing Motion
    
    
    // Mark := Handling Punches
    func handlePunch(damage:CGFloat){
        self.soundArray?.randomItem().play()
        let newStamina:CGFloat = self.opponentStamina! - damage
        if newStamina <= 0 {
            self.victorySound?.play()
            UIAlertView(title: "YOU WIN!", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
            if userIsOrigin!{
                ParseAPI().fightWasCompleted(fightToDisplay!, winner:PFUser.currentUser(), loser: fightToDisplay!["recipient"] as PFUser)
            }else{
                ParseAPI().fightWasCompleted(fightToDisplay!, winner:fightToDisplay!["recipient"] as PFUser, loser:fightToDisplay!["origin"] as PFUser)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.opponentStamina = newStamina
        if userIsOrigin!{
            // update the stamina on the database
            self.fightToDisplay?.setObject(opponentStamina, forKey: "recipientStamina")
            fightToDisplay?.saveInBackground()
            ParseAPI().notifyPunchedUser(self.recipientUser!, fightObject:fightToDisplay!, sound:SoundAPI.notificationSound)
        }
        else{
            self.fightToDisplay?.setObject(opponentStamina, forKey: "originStamina")
            fightToDisplay?.saveInBackground()
            ParseAPI().notifyPunchedUser(self.originUser!, fightObject:fightToDisplay!, sound:SoundAPI.notificationSound)
            
        }
        self.isUsersTurn = false
    }
}
