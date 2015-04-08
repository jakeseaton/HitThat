//
//  FightOpenViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightOpenViewController: UIViewController {
    
    @IBAction func goBackPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Public API
    var fightToDisplay:PFObject?{
        didSet{
            updateUI()
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
    var userIsOrigin:Bool?
    

    // Stamina Properties and Outlets
    var userStamina:CGFloat?{
        didSet{
        self.userStaminaBar?.setProgress(self.userStamina!, animated: true)
        }
    }
    var opponentStamina:CGFloat?{
        didSet{
            self.opponentStaminaBar?.setProgress(self.opponentStamina!, animated:true)
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

    func updateUI(){}
    
    override func viewDidLoad() {
        
        self.soundArray = SoundAPI().getArrayOfSoundsPlayers()
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
        AppDelegate.Motion.Manager.startAccelerometerUpdates()
    }
    override func viewDidAppear(animated: Bool) {
        self.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (motion == UIEventSubtype.MotionShake){
            self.soundArray?.randomItem().play()
            var newPercentage = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            let curr = self.opponentStamina!
            let dif = curr - newPercentage
            self.opponentStamina = dif
            if userIsOrigin!{ParseAPI().notifyPunchedUser(self.recipientUser!)}
            else{ParseAPI().notifyPunchedUser(self.originUser!)}
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
