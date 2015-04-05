//
//  RegisterViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/28/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate {
    var questionIndex = 0
    var colorIndex = 0
    var colors = Colors.ColorsArray
    @IBOutlet weak var swipeableView:ZLSwipeableView!
    var questions = ["Welcome, please answer these questions to the best of your ability, so that we can find the best matches for you. (Swipe or punch left or right)", "Do you hit with your right or your left?", "Float like a butterfly or sting like a bee?", "Are you allergic to anything?", "What about bees?", "Do you believe in reincarnation?", "Then how do you explain butterflies?","Are you ready to start hitting people? Take a swint to answer yes!","",""]
    override func viewDidLoad(){
        super.viewDidLoad()
        self.swipeableView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        self.swipeableView.dataSource = self
    }
    
    //MARK: Swipeable View Delegate
    func swipeableView(swipeableView: ZLSwipeableView!, swipingView view: UIView!, atLocation location: CGPoint, translation: CGPoint) {
        println("swiping View")
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeRight view: UIView!) {
        // performSegueWithIdentifier("That Segue", sender: self)
        println("swiped right!")
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeLeft view: UIView!) {
        // store that object in the fights database
        println("swiped left")
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {
        println("startedSwipingView")
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didEndSwipingView view: UIView!, atLocation location: CGPoint) {
        println("EndedSwipingView")
    }
    //MARK: Swipeable View DataSource
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        if (self.questionIndex < self.questions.count){
            // .frame?
            var view = CardView(frame: swipeableView.bounds)
            var textView = UITextView(frame: view.bounds)
            textView.text = self.questions[questionIndex]
            view.backgroundColor = colors[colorIndex]
            
            //            view.backgroundColor = self.colorForName(colors[colorIndex])
            //            colorIndex += 1
            // I really don't want to do this
            //            if (loadCardFromXIB){
            //                println("lol")
            //
            //            }
            textView.backgroundColor = UIColor.clearColor()
            textView.font = UIFont.systemFontOfSize(24)
            textView.editable = false
            textView.selectable = false
            view.addSubview(textView)
            self.questionIndex += 1
            colorIndex = (colorIndex + 1) % colors.count

            return view

        }
        else{
//            self.dismissViewControllerAnimated(true){}
            self.performSegueWithIdentifier(Constants.RegisterFormSegue, sender: self)
            return nil
        }
    }
    //MARK:-Core Motion
    override func viewDidAppear(animated: Bool) {
        // if motion manager is avaliable else alert
        //        let motionManager = AppDelegate.Motion.Manager
        //        motionManager.startAccelerometerUpdates()
        self.becomeFirstResponder()
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (motion == UIEventSubtype.MotionShake){
            println("user shook the device")
            self.swipeableView.swipeTopViewToLeft()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
        //        self.resignFirstResponder()
    }

}
