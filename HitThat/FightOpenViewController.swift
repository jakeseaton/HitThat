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
        self.userStaminaLabel.text = self.userStamina!.description
        }
    }
    var opponentStamina:CGFloat?{
        didSet{
            println(self.opponentStamina)
            self.opponentStaminaBar?.setProgress(self.opponentStamina!, animated:true)
            self.opponentStaminaLabel.text = self.opponentStamina!.description
            
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
    func updateUI(){
        // doing this synchronously for now
        if let origin = self.originUser{
            if let recipient = self.recipientUser{
                let originImage = SnatchParseAPI().getAUsersProfilePicture(origin)
                let recipientImage = SnatchParseAPI().getAUsersProfilePicture(recipient)
                self.userImage.image = self.userIsOrigin! ? originImage : recipientImage
                self.opponentImage.image  = self.userIsOrigin! ? recipientImage : originImage
            }
        }
        
    }
    private func setStaminaBars(fight:PFObject){
        self.userStaminaBar?.hideStripes = true
        self.opponentStaminaBar?.hideStripes = true

        self.userStaminaBar?.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        self.opponentStaminaBar?.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        self.userStaminaBar?.progressTintColors = [Colors.color1, Colors.color2]//self.colors
        self.opponentStaminaBar?.progressTintColors = [Colors.color1, Colors.color2]//self.colors
        self.userStaminaBar?.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
        self.opponentStaminaBar?.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
        let originStamina = fight["originStamina"] as AnyObject as CGFloat
        let recipientStamina = fight["recipientStamina"] as AnyObject as CGFloat
        self.userStamina = userIsOrigin! ? originStamina : recipientStamina
        self.opponentStamina = userIsOrigin! ? recipientStamina : originStamina
        self.userStaminaLabel.text = userStamina?.description
        self.opponentStaminaLabel.text = opponentStamina?.description
    }
    
    override func viewDidLoad() {
        println("viewDidLoad")
        super.viewDidLoad()
        if let fight = fightToDisplay{
            PFUser.query().getObjectInBackgroundWithId(fight["recipient"].objectId, block:{
                    (result, error) in
                    self.recipientUser = result as? PFUser
                // this is ugly--think of a way to get it out of here
                    self.setStaminaBars(fight)
                })
            PFUser.query().getObjectInBackgroundWithId(fight["origin"].objectId){
                    (result, error) in
                    self.originUser = result as? PFUser
                }
            self.setStaminaBars(fight)
        }
            updateUI()
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
            self.userIsOrigin! ? SnatchParseAPI().notifyPunchedUser(self.recipientUser!) : SnatchParseAPI().notifyPunchedUser(self.originUser!)
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
