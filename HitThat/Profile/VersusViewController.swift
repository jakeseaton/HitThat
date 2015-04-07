// This is a customized pod. I wrote the functionality, but some of the animation stuff is not mine.

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class VersusViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var userSawLoginScreen = false
    var soundArray:[AVAudioPlayer]?
    @IBOutlet weak var distanceLabel:UILabel!
    @IBAction func nextTapped(sender: AnyObject) {
        self.next()
    }
    @IBAction func versusTapped(sender: AnyObject) {
        // play some sount
        self.next()
    }
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    var blurredHeaderImageView:UIImageView?
    @IBAction func keepPlaying(segue:UIStoryboardSegue){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.centerContainer!.centerViewController = self
        // figure out some way to check what state it is in. 
        // appDelegate.centerContainer!.toggleDrawerSide(.Right, animated: true, completion: nil)
    }
    // To Set
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var bioLabel:UILabel!
    @IBOutlet weak var displayName: UILabel!
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
            tv.reloadData()

        }
    }
    private func updateUI(){
         // userToDisplay!.objectForKey("fullName") as AnyObject as? String
        self.displayName.text = userToDisplay!.objectForKey("alias") as AnyObject as? String
        self.bioLabel.text = userToDisplay?.objectForKey("bio") as? String
        if let img = userToDisplay!.objectForKey("profilePhoto") as AnyObject as? PFFile{
            img.getDataInBackgroundWithBlock(){
                data, error in
                self.headerImageView.image = UIImage(data: data)
                self.headerBlurImageView?.image = self.headerImageView?.image?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
            }
        }
        if let location = PFUser.currentUser()?.objectForKey("location") as? PFGeoPoint{
            if let opponentLocation = userToDisplay?.objectForKey("location") as? PFGeoPoint{
                let distance = location.distanceInMilesTo(opponentLocation)
                self.distanceLabel.text = "Distance : " + distance.description + "mi"
            }
        }
    }
    
    @IBAction func dateThemPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(Constants.GenericProfileSegue, sender: self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.GenericProfileSegue{
            if let next = segue.destinationViewController as? GenericProfileViewController{
                next.userToDisplay = sender?.userToDisplay
            }
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tv.allowsSelection = false
        self.tv.backgroundColor = UIColor.clearColor()
        self.soundArray = SoundAPI().getArrayOfSoundsPlayers()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        self.next()
        self.indicator.hidden = true
        self.headerLabel.text = "PUNCH TO FIGHT!"
        self.headerLabel.textColor = Colors.color2
        scrollView.delegate = self
    }
    
    @IBAction func locatePressed(sender: AnyObject) {
    }
    override func viewWillAppear(animated: Bool) {
        println("view will appear")
        self.becomeFirstResponder()
        AppDelegate.Motion.Manager.startAccelerometerUpdates()
        backgroundView.backgroundColor = UIColor.clearColor()
        headerImageView = UIImageView(frame: header.bounds)
//        if let img = userToDisplay?["profilePhoto"] as? PFFile{
//            img.getDataInBackgroundWithBlock {
//                (imageData, error) -> Void in
//                if error != nil {
//                    println("ERROR RETRIEVING IMAGE")
//                }
//                else{
//                    self.headerImageView?.image = UIImage(data:imageData)
//                    //                        self.avatarImage.image = UIImage(data:imageData)
//                }
//            }
//        }
//        else{
//            self.headerImageView?.image = UIImage(named: "backgroundGradient")
//        }
        // this gets the current user's profile photo
//        if let userObject = PFUser.currentUser(){
//            //            println("\(userObject)")
//            
//            if let img = userObject["profilePhoto"] as AnyObject as? PFFile {
//                img.getDataInBackgroundWithBlock {
//                    (imageData, error) -> Void in
//                    if error != nil {
//                        println("ERROR RETRIEVING IMAGE")
//                    }
//                    else{
//                        self.headerImageView?.image = UIImage(data:imageData)
//                        //                        self.avatarImage.image = UIImage(data:imageData)
//                    }
//                }
//            }
//        }
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = self.headerImageView?.image?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
        Colors().gradient(self)
//        if let user = PFUser.currentUser(){
//            userToDisplay = user
//        }
        // get a random user here!
        
    }
    override func viewDidAppear(animated: Bool) {
        println("view did appear")
        if let currUserName = PFUser.currentUser(){
            super.viewDidAppear(true)
        }
        else{
            super.viewDidAppear(true)
            if !self.userSawLoginScreen{
                performSegueWithIdentifier(Constants.NoUserSegue, sender: self)
                self.userSawLoginScreen = true
            }
        }
        self.becomeFirstResponder()
        
        
        // Header - Image

    }

    override func viewWillDisappear(animated: Bool) {
        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (motion == UIEventSubtype.MotionShake){
            SnatchParseAPI().storeAFightFromVersusScreen(userToDisplay!)
            self.soundArray?.randomItem().play()
            self.performSegueWithIdentifier(Constants.GenericProfileSegue, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    func next(){
        self.scrollView.setContentOffset(CGPointZero, animated: true)
        if !indicator.isAnimating(){
            indicator.hidden = false
            indicator.startAnimating()
            // specify what user we want.
            println("starting query")
            let query = PFUser.query()
            // allows it to continue every time. Delete this to never see the same user again.
            PFUser.currentUser()["seen"] = []
            PFUser.currentUser().save()
            if let currUser = PFUser.currentUser(){
                query.whereKey("objectId", notEqualTo:currUser.objectId)
                if let display = userToDisplay{
                    PFUser.currentUser().addObject(display.objectId, forKey: "seen")
                    PFUser.currentUser().saveInBackground()
                    query.whereKey("objectId", notEqualTo: display.objectId)
                }
                var seen = currUser["seen"] as [PFUser]
                query.whereKey("objectId", notContainedIn: seen)
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
                        println("no more users")
                    }
                }
            }
        }
    }
    var categories = ["gender", "height", "weight", "reach", "wins", "jailTime", "bestMove", "bodyType", "GPA", "lookingFor"]
    // TableView Data Source/Delegate Stuff
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VersusCell") as VersusCell
        cell.backgroundColor = UIColor.clearColor()
        let category = categories[indexPath.row]
        let userCategory: AnyObject? = PFUser.currentUser()?.objectForKey(category)
        let opponentCategory: AnyObject? = userToDisplay?.objectForKey(category)
        switch category{
            case "bodyType":
                cell.categoryLabel?.text = "B.T"
                break
            case "bestMove":
                cell.categoryLabel?.text = "|"
                break
            case "jailTime":
                cell.categoryLabel?.text = "J.T."
                break
            case "lookingFor":
                cell.categoryLabel?.text = "For"
                break
        default:
            cell.categoryLabel?.text = category.uppercaseString
            break
            
        }
        cell.userLabel.text =  userCategory?.description
        cell.opponentLabel.text = opponentCategory?.description
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}