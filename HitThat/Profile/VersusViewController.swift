//
//  VersusViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 3/30/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class VersusViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    // UI
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    // Names
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var displayName: UILabel!
    // Tables
    @IBOutlet weak var userTableView: UserTable!
    @IBOutlet weak var versusTableView:VersusTable!
    @IBOutlet weak var opponentTableView:OpponentTable!
    // Other
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var blurredHeaderImageView:UIImageView?
    
    //MARK: Actions
    @IBAction func fightTapped(sender:AnyObject) {
        if let fightObject = ParseAPI().storeAFightFromVersusScreen(userToDisplay!){
            self.soundArray?.randomItem().play()
            println(fightObject)
            self.performSegueWithIdentifier(Constants.GenericProfileSegue, sender: fightObject)
            //let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        }
        else{
            UIAlertView(title: "LOG IN TO FIGHT", message: nil, delegate: nil, cancelButtonTitle: "ok").show()
        }
    }
    @IBAction func nextTapped(sender: AnyObject) {
        self.next()
    }
    @IBAction func versusTapped(sender: AnyObject) {
        ParseAPI().storeAFightFromVersusScreen(userToDisplay!)
        self.soundArray?.randomItem().play()
        self.performSegueWithIdentifier(Constants.GenericProfileSegue, sender: self)
    }
    
    
    
    // MARK: Segues
    @IBAction func keepPlaying(segue:UIStoryboardSegue){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.centerContainer!.centerViewController = self
        if segue.identifier == Constants.RegistrationCompleteSegue{
            self.updateUI()
        }
        self.next()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.GenericProfileSegue{
            println(segue.destinationViewController.childViewControllers)
            
            if let next = segue.destinationViewController.childViewControllers[0] as? MatchViewController{
                next.userToDisplay = self.userToDisplay
                next.fightToDisplay = sender as? PFObject
            }
        }
    }
    // MARK: Private
    // override func viewWillAppear(animated: Bool) {}
    // override func viewWillDisappear(animated: Bool) {}
    // override func canBecomeFirstResponder() -> Bool {return true}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get first user
        self.next()
        self.indicator.hidden = true
        
        scrollView.delegate = self
        
        // Sound
        self.soundArray = SoundAPI().getArrayOfMatchSoundPlayers()
        
        // UI
        self.headerLabel.textColor = UIColor.whiteColor()//COlors.color2()
        backgroundView.backgroundColor = UIColor.clearColor()
        Colors().favoriteBackGroundColor(self)
        //Colors().gradient(self)
        
        // Header - Image
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        header.clipsToBounds = true

    }
    
    override func viewDidAppear(animated: Bool) {
        if let currUser = PFUser.currentUser(){
            super.viewDidAppear(true)
            // make sure they've registered
//            if !self.userSawLoginScreen{
//                if let alias = currUser["alias"] as? String{}
//                else{
//                    performSegueWithIdentifier(Constants.NoUserSegue, sender: self)
//                }
//            }

        }
        else{
            super.viewDidAppear(true)
            if !self.userSawLoginScreen{
                performSegueWithIdentifier(Constants.NoUserSegue, sender: self)
                self.userSawLoginScreen = true
            }
        }
    }

    private func updateUI(){
        self.displayName.text = ParseAPI().stringOfUnwrappedUserProperty("alias", user: userToDisplay!)
        ParseAPI().installAUsersProfilePhoto(userToDisplay!, target: self.headerImageView, optionalBlurTarget: self.headerBlurImageView)
        self.headerLabel.text = ParseAPI().stringOfUnwrappedUserProperty("alias", user: userToDisplay!)
        
        if let currUser = PFUser.currentUser(){
            self.userDisplayName.text = ParseAPI().stringOfCurrentUserProperty("alias")
        }
        userTableView.reloadData()
        
    }
    // I DIDN'T WRITE THIS
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            header.layer.transform = headerTransform
        }
            // SCROLL UP/DOWN ------------
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    

    // MARK: Public API
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
            opponentTableView.reloadData()
            
        }
    }
    func next(){
        self.scrollView.setContentOffset(CGPointZero, animated: true)
        if !indicator.isAnimating(){
            indicator.hidden = false
            indicator.startAnimating()
            // specify what user we want.
            println("starting query")
            let query = PFUser.query()
            // allows it to continue every time. Delete this to never see the same user again. Raises an exception when you log in for the first time.
            PFUser.currentUser()?["seen"] = []
            PFUser.currentUser()?.saveInBackground()
            if let currUser = PFUser.currentUser(){
                query.whereKey("objectId", notEqualTo:currUser.objectId)
                if let display = userToDisplay{
                    PFUser.currentUser().addObject(display.objectId, forKey: "seen")
                    PFUser.currentUser().saveInBackground()
                    query.whereKey("objectId", notEqualTo: display.objectId)
                }
                var seen = currUser["seen"] as [PFUser]
                query.whereKey("objectId", notContainedIn: seen)
                //query.whereKey("fullName", equalTo:"Jake Seaton")
            }
            query.getFirstObjectInBackgroundWithBlock(){
                (object, error) in
                if error == nil{
                    if object != nil {
                        self.userToDisplay = object as? PFUser
                        self.indicator.stopAnimating()
                        self.indicator.hidden = true
                        println("refreshed--new user")
                    }
                    else{
                        println("no more users to view")
                    }
                }
            }
        }
    }
    var userSawLoginScreen = false
    var soundArray:[AVAudioPlayer]?
    
    // TableView Data Source/Delegate Stuff
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let utv = tableView as? UserTable{
            let cell = utv.dequeueReusableCellWithIdentifier("UserCell") as UserCell
            cell.backgroundColor = UIColor.clearColor()
            let category = Constants.categories[indexPath.row]
            let userCategory: AnyObject? = PFUser.currentUser()?.objectForKey(category)
            cell.userLabel?.text = userCategory?.description
            cell.userLabel?.textColor = UIColor.greenColor()

            return cell
        }
        else if let otv = tableView as? OpponentTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("OpponentCell") as OpponentCell
            cell.backgroundColor = UIColor.clearColor()
            let category = Constants.categories[indexPath.row]
            let opponentCategory: AnyObject? = userToDisplay?.objectForKey(category)
            cell.opponentLabel?.text = opponentCategory?.description
            cell.opponentLabel?.textColor = UIColor.redColor()
            return cell
            
        }
        else {
            let table = tableView as VersusTable
            let cell = tableView.dequeueReusableCellWithIdentifier("VersusCell") as VersusCell
            cell.backgroundColor = UIColor.clearColor()
            let category = Constants.categories[indexPath.row]
            cell.categoryLabel?.text = category.uppercaseString

//            switch category{
//            case "bodyType":
//                cell.categoryLabel?.text = "B.T"
//                break
//            case "bestMove":
//                cell.categoryLabel?.text = "|"
//                break
//            case "jailTime":
//                cell.categoryLabel?.text = "J.T."
//                break
//            case "lookingFor":
//                cell.categoryLabel?.text = "For"
//                break
//            default:
//                cell.categoryLabel?.text = category.uppercaseString
//                break
//            }
            return cell
            
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.categories.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}