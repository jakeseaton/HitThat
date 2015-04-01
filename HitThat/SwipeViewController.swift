//
//  SwipeViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 3/27/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate {
    var currLocation : PFGeoPoint?
    let colors = Colors.ColorsArray
//    var ParseAPI = SnatchParseAPI()
    @IBAction func goHome(segue:UIStoryboardSegue){
        println("someone unwound back to me!")
    }

    @IBOutlet weak var progressBar: YLProgressBar!
    
    @IBAction func hitThatPressed(sender: AnyObject) {
        self.swipeableView.swipeTopViewToRight()
    }
    @IBAction func hitThemPressed(sender: AnyObject) {
        self.swipeableView.swipeTopViewToLeft()
    }
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    var allPosts = [PFObject]()
    var loadCardFromXIB:Bool = false
    var colorIndex = 0
    private func updateProgressBar(){
        var newPercentage = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        self.progressBar.setProgress(newPercentage, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeableView.delegate = self
        PFGeoPoint.geoPointForCurrentLocationInBackground(){
            (geopoint, error) in
            if error != nil {
                println("ERROR CANNOT FETCH LOCATION from PFGEOPOINT")
            }
            else{
                self.currLocation = geopoint
            }
        }
//        self.progressBar.type = .Flat
        self.progressBar.hideStripes = true
        self.progressBar.hideTrack = true
        self.progressBar.indicatorTextLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
        self.progressBar.progressTintColors = [Colors.color1, Colors.color2]//self.colors
        self.progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.Progress
        self.progressBar.setProgress(1, animated: true)
//        self.progressBar.backgroundColor = UIColor.clearColor()
//        self.progressBar.trackTintColor = UIColor.clearColor()
//        _progressBar.type                     = YLProgressBarTypeFlat;
//        _progressBar.hideStripes              = YES;
//        _progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
//        _progressBar.progressTintColors       = rainbowColors;
        
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
        if let cardView = view as? CardView{
            // store that object in the snatches database
            if let post = cardView.object{
                let API = SnatchParseAPI()
                API.storeASnatchOrFight(post, fight: false)
            }
        }
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeLeft view: UIView!) {
        // store that object in the fights database
        if let cardView = view as? CardView{
            if let post = cardView.object{
                let API = SnatchParseAPI()
                API.storeASnatchOrFight(post, fight: true)
            }
        }
        println("swiped left")
    }
    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {}
    func swipeableView(swipeableView: ZLSwipeableView!, didEndSwipingView view: UIView!, atLocation location: CGPoint) {}
    //MARK: Swipeable View DataSource
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        if (self.colorIndex < self.colors.count){
            // .frame?
            let query = PFQuery(className: "Posts")
            query.orderByDescending("createdAt")
//            let userSeenPosts = PFUser.currentUser().objectForKey("seenPosts") as AnyObject as [String]
            // ADD THIS LINE TO MAKE SURE THEY NEVER SEE THE SAME POST TWICE
            // query.whereKey("objectId", notContainedIn: userSeenPosts)
        
            if let queryLoc = currLocation{
                query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 10)
            }
            // if there is a user, make sure there are things they haven't seen yet.
            let result = query.getFirstObject()
//            PFUser.currentUser().addObject(result.objectId, forKey: "seenPosts")
//            PFUser.currentUser().saveInBackground()
//            if result != nil{
//                
//            }
//            else{
//                return nil
//            }
            var view = CardView(frame: swipeableView.bounds)
            view.object = result
            var textView = UITextView(frame: view.bounds)
            textView.backgroundColor = UIColor.clearColor()
            textView.textColor = UIColor.whiteColor()
            textView.font = UIFont.systemFontOfSize(24)
            textView.editable = false
            textView.selectable = false
            // Change this to something silly when you clear the user table
            textView.text = result.objectForKey("text") as AnyObject as String
            view.backgroundColor = colors[colorIndex]
            let gradient: CAGradientLayer = CAGradientLayer()
//            gradient.colors = [Colors.PomegranateColor.CGColor, Colors.AlizarinColor.CGColor]
            gradient.colors = [Colors.color1.CGColor, Colors.color2.CGColor]
            gradient.locations = [0.0 , 1.0]
//            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
            // THIS DOES THE GRADIENTS
//            view.layer.insertSublayer(gradient, atIndex: 0)
            colorIndex = (colorIndex + 1) % colors.count
//            view.backgroundColor = self.colorForName(colors[colorIndex])
            // I really don't want to do this
//            if (loadCardFromXIB){
//                println("lol")
//        
//            }
            
            view.addSubview(textView)
            return view
        }
        return view
    }
    // MARL:- HELPERS
//    func colorForName(index:String){
//        let sanitizedName = index.stringByReplacingOccurrencesOfString(" ", withString: "")
//        // deal with all the stupid colors
//        
//    }
    private func alert(message:String){
        let alert = UIAlertController(title: "Oops, something went wrong", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        // the handler is the last argument, and we want to use a closure so we're going to put it outside the parenthesis
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default){(action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
            updateProgressBar()
            self.swipeableView.swipeTopViewToLeft()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
//        self.resignFirstResponder()
    }

}
