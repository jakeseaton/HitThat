// This is a customized pod. I wrote the functionality, but some of the animation stuff is not mine.

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class VersusViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate {

    @IBAction func versusTapped(sender: AnyObject) {
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
    @IBOutlet weak var containerView: UIView!
    @IBAction func keepPlaying(segue:UIStoryboardSegue){}
    // To Set
    @IBOutlet weak var displayName: UILabel!
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
         // userToDisplay!.objectForKey("fullName") as AnyObject as? String
        self.displayName.text = userToDisplay!.objectForKey("alias") as AnyObject as? String
        if let img = userToDisplay!.objectForKey("profilePhoto") as AnyObject as? PFFile{
            img.getDataInBackgroundWithBlock(){
                data, error in
                self.headerImageView.image = UIImage(data: data)
                self.headerBlurImageView?.image = self.headerImageView?.image?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
            }
        }
        if let table = self.childViewControllers.last as? VersusTableViewController{
            table.userToDisplay = self.userToDisplay!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.next()
        self.indicator.hidden = true
        self.headerLabel.text = "PUNCH TO FIGHT!"
        self.headerLabel.textColor = UIColor.redColor() //Colors.color2
        println("view did load")
        scrollView.delegate = self
    }
    
    @IBAction func locatePressed(sender: AnyObject) {
    }
    override func viewWillAppear(animated: Bool) {
        println("view will appear")
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
        self.becomeFirstResponder()
        
        // Header - Image

    }
    override func viewWillDisappear(animated: Bool) {
//        AppDelegate.Motion.Manager.stopAccelerometerUpdates()
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (motion == UIEventSubtype.MotionShake){
            SnatchParseAPI().storeAFightFromVersusScreen(userToDisplay!)
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
        if !indicator.isAnimating(){
            indicator.hidden = false
            indicator.startAnimating()
            let query = PFUser.query()
            // specify what user we want.
            println("starting query")
            query.getFirstObjectInBackgroundWithBlock(){
                (object, error) in
                if error == nil{
                    self.userToDisplay = object as? PFUser
                    self.indicator.stopAnimating()
                    self.indicator.hidden = true
                    println("refreshed--new user")
                }
            }
        }
    }
}