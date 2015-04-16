//
//  FightOpenViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightOpenViewController: UIViewController, CFPressHoldButtonDelegate{
    let motionKit = MotionKit()
    var soundToPlay:AVAudioPlayer?
    var counter = 0
    var timer =  NSTimer()
    var locked = false
//    var lock = false
    @IBOutlet weak var fightAgainst: UILabel!
    @IBOutlet weak var opponentHitpoints: UILabel!
    @IBOutlet weak var opponentBlur: UIVisualEffectView!
    @IBOutlet weak var userBlur:UIVisualEffectView!
    @IBAction func manualPunchPressed(sender: AnyObject) {
        self.opponentBlur?.layer.cornerRadius = self.opponentBlur.frame.size.width/2
        if isUsersTurn!{
            self.handlePunch(CGFloat(0.10), punchType: .Jab, punchLocation: .Gut)
        }
        else{
            UIAlertView(title: "Wait your turn", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
            //self.isUsersTurn = true
        }
    }
    @IBAction func goBackPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(Constants.ReturnFromFightToVersus, sender: nil)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.destinationViewController)
    }
    // Public API

    var isUsersTurn:Bool?{
        willSet{
            self.swapBlurs(newValue!)
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
        if !locked{
            locked = true
            counter = counter + 1
            println("tick \(counter), timer stopped")
            // Stopping timer
            //self.timer.invalidate()
            if let curr = fightToDisplay{
                let query = ParseAPI().fightsQuery()
                query.getObjectInBackgroundWithId(curr.objectId){
                    (object, error) in
                    if (error == nil){
                        self.fightToDisplay = object
                        self.locked = false
                        // Restarting timer
                    }
                    // else that fight no longer exists
                    else{
                        //UIAlertView(title: "You Won!", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
                        self.performSegueWithIdentifier(Constants.ReturnFromFightToVersus, sender: nil)
                        //                    self.dismissViewControllerAnimated(<#flag: Bool#>, completion: <#(() -> Void)?##() -> Void#>)//self.dismissViewControllerAnimated(true, completion: nil )
                    }
                }
            }
        }
    }
    

    // Stamina Properties and Outlets
    var userStamina:CGFloat?{
        willSet{
            if newValue < userStaminaBar.progress{
                if newValue <= 0{
                    self.timer.invalidate()
                    if userIsOrigin!{
                        ParseAPI().fightWasCompleted(fightToDisplay!, winner: recipientUser!, loser: originUser!)
                    }
                    else{
                        ParseAPI().fightWasCompleted(fightToDisplay!, winner: originUser!, loser: recipientUser!)
                    }
                    //UIAlertView(title: "YOU LOST!", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
                    self.soundToPlay = SoundAPI().getDieSound()
                    self.soundToPlay!.play()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
//                    self.lock = true
                    self.soundToPlay = userIsOrigin! ? SoundAPI().getGruntSoundForUser(originUser!) : SoundAPI().getGruntSoundForUser(recipientUser!)
                    self.soundToPlay!.play()
//                    self.lock = false
//                    if !lock{
//                        
//                    }
                    self.isUsersTurn = true
                }
            }
        self.userStaminaBar?.setProgress(newValue!, animated: true)
        }
        didSet{
            self.userStaminaBar?.indicatorTextDisplayMode = .Progress
        }
    }
    var opponentStamina:CGFloat?{
        willSet{
            if newValue <= 0 {
                self.timer.invalidate()
                if userIsOrigin!{
                    ParseAPI().fightWasCompleted(fightToDisplay!, winner: originUser!, loser: recipientUser!)
                }
                else{
                    ParseAPI().fightWasCompleted(fightToDisplay!, winner: recipientUser!, loser: originUser!)
                }
                self.soundToPlay = SoundAPI().getVictorySound()
                soundToPlay?.play()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.opponentStaminaBar?.setProgress(newValue!, animated:true)
        }
        didSet{
            self.opponentStaminaBar?.indicatorTextDisplayMode = .Progress
        }
    }
    
    @IBOutlet weak var userStaminaBar: YLProgressBar!
    @IBOutlet weak var opponentStaminaBar: YLProgressBar!
    
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

    func updateUI(){
        if let currentFight = fightToDisplay{
            if let lastTurn = currentFight["lastTurn"] as? PFUser{
                if PFUser.currentUser().objectId == lastTurn.objectId{
                    self.isUsersTurn = false
                }
            }
            
            else{
                self.isUsersTurn = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.opponentBlur.hidden = true
        self.userBlur?.pressHoldButtonDelegate = self
        self.opponentHitpoints?.textColor = Colors.opponentColor1
        self.isUsersTurn = true
        self.soundArray = SoundAPI().getArrayOfFightSoundPlayers()
        self.victorySound = SoundAPI().getVictorySound()
        self.lossSound = SoundAPI().getLossSound()
        // Colors().favoriteBackGroundColor(self)
        Colors().configureStaminaBar(userStaminaBar!, user:true)
        Colors().configureStaminaBar(opponentStaminaBar!, user:false)
        Colors().favoriteBackGroundColor(self)
        Shapes().circularImage(userImage)
        Shapes().circularImage(opponentImage)
        
        let user = PFUser.currentUser()
        let fight = self.fightToDisplay!
        let origin = fight["origin"] as PFUser
        let recipient = fight["recipient"] as PFUser
        
        if (origin.objectId == user.objectId){
            self.userIsOrigin = true
            self.originUser = user
            // This can be done with fetch data, because rn it's just a pointer
            self.recipientUser = ParseAPI().userQuery().getObjectWithId(recipient.objectId) as? PFUser
            let opponentAlias = self.recipientUser?.objectForKey("alias") as String
            self.fightAgainst.text = "Fight against: \(opponentAlias)"
        }
        else{
            self.userIsOrigin = false
            self.recipientUser = user
            // synchronous queries for user info,b ec
            self.originUser = ParseAPI().userQuery().getObjectWithId(origin.objectId) as? PFUser
            let opponentAlias = self.originUser?.objectForKey("alias") as String
            self.fightAgainst.text = "Fight against: \(opponentAlias)"
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
//        if fightToDisplay?["lastTurn"] as PFUser == PFUser.currentUser(){
//            self.isUsersTurn = false
//        }
//        else{
//            self.isUsersTurn = true
//        }

    }
    override func viewWillAppear(animated: Bool) {
        // AppDelegate.Motion.Manager.startAccelerometerUpdates()
    }
    override func viewDidAppear(animated: Bool) {
        //self.becomeFirstResponder()
//        timer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeInterval, target: self, selector: Selector("refreshFight"), userInfo: nil, repeats: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(Constants.TimeInterval, target: self, selector: "refreshFight", userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(animated: Bool) {
        self.motionKit.stopDeviceMotionUpdates()
        //AppDelegate.Motion.Manager.stopAccelerometerUpdates()
        timer.invalidate()
    }
    // Mark := Analyzing Motion
    
    
    // Mark := Handling Punches
    func handlePunch(damage:CGFloat, punchType:PunchType,
        punchLocation:PunchLocation){
        soundToPlay = SoundAPI().soundNameToAudioPlayer(MotionAPI.motionsToSounds[punchType]!)
        self.soundToPlay!.play()
            let hitpoints = Int(damage * 100)
            self.opponentHitpoints.text = "- \(hitpoints) HP"
            let message = MotionAPI.MessageForPunchLocation[punchLocation]
            self.fightAgainst.text = message
        let newStamina:CGFloat = self.opponentStamina! - damage
            self.opponentStamina = newStamina
            fightToDisplay?.setObject(PFUser.currentUser(), forKey: "lastTurn")
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
    //Mark : Press Hold Delegation
    func didStartHolding(targetView: UIView!) {
        // change the style instead?
        self.userBlur.hidden = true

        if self.isUsersTurn!{
            motionKit.getDeviceMotionObject(interval: MotionAPI.interval) {
                (deviceMotion) in
                MotionAPI().analyzeMotion(deviceMotion, sender:self)
            }
            
        }
        else{
            UIAlertView(title: "Wait your turn", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
            //self.isUsersTurn = true
        }

    }

    func didFinishHolding(targetView: UIView!) {
        if isUsersTurn!{self.userBlur.hidden = false}
        self.motionKit.stopDeviceMotionUpdates()
    }
    func swapBlurs(userTurn:Bool){
        self.userBlur?.hidden = userTurn ? false : true
        self.opponentBlur?.hidden = userTurn
    }
}
