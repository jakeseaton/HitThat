//
//  FightOpenViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightOpenViewController: UIViewController {
    
    var userIsOrigin:Bool?
    
    @IBAction func goBackPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var userStamina:CGFloat?{
        didSet{
        self.userStaminaBar?.setProgress(self.userStamina!, animated: true)
        self.userStaminaLabel?.text = self.userStamina!.description
        }
    }
    var opponentStamina:CGFloat?{
        didSet{
            self.opponentStaminaBar?.setProgress(self.opponentStamina!, animated:true)
            self.opponentStaminaLabel?.text = self.opponentStamina!.description
        }
    }
    @IBOutlet weak var userStaminaBar: YLProgressBar!
    @IBOutlet weak var opponentStaminaBar: YLProgressBar!
    // @IBOutlet weak var recipientStamina: YLProgressBar!
    
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
    var fightToDisplay:PFObject?{
        didSet{
            updateUI()
        }
    }
    

    @IBOutlet weak var userStaminaLabel:UILabel!
    @IBOutlet weak var opponentStaminaLabel:UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var opponentImage: UIImageView!
    
    func updateUI(){}
    private func setStaminaBars(fight:PFObject){
        let originStamina = fight["originStamina"] as AnyObject as CGFloat
        let recipientStamina = fight["recipientStamina"] as AnyObject as CGFloat
        self.userStamina = userIsOrigin! ? originStamina : recipientStamina
        self.opponentStamina = userIsOrigin! ? recipientStamina : originStamina
        self.userStaminaLabel?.text = userStamina?.description
        self.opponentStaminaLabel?.text = opponentStamina?.description
    }
    
    override func viewDidLoad() {
        self.userStaminaBar?.hideStripes = true
        self.opponentStaminaBar?.hideStripes = true
        self.userStaminaBar?.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        self.opponentStaminaBar?.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        self.userStaminaBar?.progressTintColors = [Colors.color1, Colors.color2]//self.colors
        self.opponentStaminaBar?.progressTintColors = [Colors.color1, Colors.color2]//self.colors
        self.userStaminaBar?.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
        self.opponentStaminaBar?.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
        
        let user = PFUser.currentUser()
        let fight = self.fightToDisplay!
        let origin = fight["origin"] as PFUser
        let recipient = fight["recipient"] as PFUser
        
        if (origin.objectId == user.objectId){
            self.userIsOrigin = true
            self.originUser = user
            self.recipientUser = PFUser.query().getObjectWithId(recipient.objectId) as? PFUser
        }
            
        else{
            self.userIsOrigin = false
            self.recipientUser = user
            self.originUser = PFUser.query().getObjectWithId(fight["origin"].objectId) as? PFUser
        }
        setStaminaBars(self.fightToDisplay!)

        let originImage = SnatchParseAPI().getAUsersProfilePicture(self.originUser!)
        let recipientImage = SnatchParseAPI().getAUsersProfilePicture(self.recipientUser!)
        if self.userIsOrigin!{
            self.userImage.image = originImage
            self.opponentImage.image = recipientImage
        }
        else{
            self.userImage.image = recipientImage
            self.opponentImage.image = originImage
        }


        // Do any additional setup after loading the view.
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
            var newPercentage = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            let curr = self.opponentStamina!
            println(curr)
            println(newPercentage)
            let dif = curr - newPercentage
            println(dif)
            self.opponentStamina = dif
            println(recipientUser)
            println(originUser)
            if userIsOrigin!{
                SnatchParseAPI().notifyPunchedUser(self.recipientUser!)
            }
            else{
               SnatchParseAPI().notifyPunchedUser(self.originUser!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
