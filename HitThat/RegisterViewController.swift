//
//  RegisterViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/28/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate {
    var questionIndex:Int = 0 {
        didSet{
                motionKit.getDeviceMotionObject(interval: MotionAPI.interval) {
                    (deviceMotion) in
                    MotionAPI().analyzeMotion(deviceMotion, sender:self)
                }
        }
    }
    
    //var colorIndex = 0
    //var colors = Colors.ColorsArray
    var motionKit = MotionKit()
    var soundToPlay:AVAudioPlayer?
    @IBOutlet weak var staminaBar:YLProgressBar!
    @IBOutlet weak var swipeableView:ZLSwipeableView!
    @IBOutlet weak var punchLabel:UILabel!
    var questions = ["Welcome to HitThat, the ONLY dating app that lets you find singles near you to match, track, and fight, all with the palm of your hand! Punch with your phone to do some damage and begin the tutorial. It's better with sound!", "First, you'll create a profile, so that potential matches can see your stats.", "Next, view other people near you to find the ones you want to fight!", "Once you've found them, you can locate and track them down.", "Too far away? No problem! You can fight within the app.","Throw the first punch to start a fight.", "On your turn, you can Jab, Uppercut, Kick, or Block. Make sure to get good rotation!","The harder you hit, the more damage you'll do.", "When the fight is over, you'll still be able to see their profile, in case you still want to hit that!", "Ready to start hitting people? Take a swing to answer yes!","",""]
    override func viewDidLoad(){
        super.viewDidLoad()
        self.swipeableView.delegate = self
        Colors().configureStaminaBar(self.staminaBar, user: false)
        self.staminaBar.setProgress(1, animated: true)
        self.punchLabel.textColor = Colors.opponentColor1
    }
    override func viewDidLayoutSubviews() {
        self.swipeableView.dataSource = self
    }
    
    // Mark := Handling Punches
    func handlePunch(damage:CGFloat, punchType:PunchType, punchLocation: PunchLocation){
        soundToPlay = SoundAPI().soundNameToAudioPlayer(MotionAPI.motionsToSounds[punchType]!)
        self.soundToPlay!.play()
        switch punchType{
        case .Jab:
            self.punchLabel.text = "NICE JAB!"
        case .Block:
            self.punchLabel.text = "NICE BLOCK!"
        case .Uppercut:
            self.punchLabel.text = "NICE UPPERCUT!"
        case .Kick:
            self.punchLabel.text = "NICE KICK!"
        default:
            break
        }
        self.swipeableView.swipeTopViewToLeft()
        let newStamina:CGFloat = self.staminaBar.progress - damage
        self.staminaBar.setProgress(newStamina, animated: true)
    }

    
    //MARK: Swipeable View Delegate
    func swipeableView(swipeableView: ZLSwipeableView!, swipingView view: UIView!, atLocation location: CGPoint, translation: CGPoint) {}
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeRight view: UIView!) {}
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeLeft view: UIView!) {}
    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {}
    func swipeableView(swipeableView: ZLSwipeableView!, didEndSwipingView view: UIView!, atLocation location: CGPoint) {}
    
    //MARK: Swipeable View DataSource
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        if (self.questionIndex < self.questions.count){
            // .frame?
            var view = CardView(frame: swipeableView.bounds)
            var textView = UITextView(frame: view.bounds)
            textView.text = self.questions[questionIndex]
            view.backgroundColor = Colors.favoriteBackgroundColor //colors[colorIndex]
            textView.backgroundColor = UIColor.clearColor()
            textView.font = UIFont.systemFontOfSize(24)
            textView.editable = false
            textView.selectable = false
            view.addSubview(textView)
            self.questionIndex += 1
            //colorIndex = (colorIndex + 1) % colors.count

            return view

        }
        else{
            self.performSegueWithIdentifier(Constants.RegisterFormSegue, sender: self)
            return nil
        }
    }
    override func viewWillDisappear(animated: Bool) {
        //AppDelegate.Motion.Manager.stopAccelerometerUpdates()
        //        self.resignFirstResponder()
    }
    
}
