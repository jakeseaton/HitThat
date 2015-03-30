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
//    var ParseAPI = SnatchParseAPI()
    @IBAction func goHome(segue:UIStoryboardSegue){
        println("someone unwound back to me!")
    }
    
    @IBAction func hitThatPressed(sender: AnyObject) {
        self.swipeableView.swipeTopViewToRight()
    }
    @IBAction func hitThemPressed(sender: AnyObject) {
        self.swipeableView.swipeTopViewToLeft()
    }
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    var allPosts = [PFObject]()
    var loadCardFromXIB:Bool = false
    var derpColor = 0
    var colors = [
        "Turquoise",
        "Green Sea",
        "Emerald",
        "Nephritis",
        "Peter River",
        "Belize Hole",
        "Amethyst",
        "Wisteria",
        "Wet Asphalt",
        "Midnight Blue",
        "Sun Flower",
        "Orange",
        "Carrot",
        "Pumpkin",
        "Alizarin",
        "Pomegranate",
        "Clouds",
        "Silver",
        "Concrete",
        "Asbestos"
    ];
    var colorIndex = 0

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
            textView.font = UIFont.systemFontOfSize(24)
            textView.editable = false
            textView.selectable = false
            // Change this to something silly when you clear the user table
            textView.text = result.objectForKey("text") as AnyObject as String
            if derpColor == 0 {
                view.backgroundColor = UIColor.orangeColor()
                derpColor = 1
            }
            else{
                derpColor = 0
                view.backgroundColor = UIColor.yellowColor()
            }

//            view.backgroundColor = self.colorForName(colors[colorIndex])
//            colorIndex += 1
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
            println("user shook the device")
            self.swipeableView.swipeTopViewToLeft()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
//        self.resignFirstResponder()
    }

}
