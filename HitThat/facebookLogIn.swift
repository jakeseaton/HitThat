//
//  facebookLogIn.swift
//  snatch
//
//  Created by Jake Seaton on 3/15/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

/*, FBLoginViewDelegate*/




class facebookLogIn: UIViewController  {
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func login(sender: AnyObject) {
        let permissions = ["public_profile", "email", "user_friends", "user_location"]

        PFFacebookUtils.logInWithPermissions(permissions) {
            (user: PFUser!, error: NSError!) -> Void in
            println(error)
            if user == nil {
                NSLog("The user cancelled the Facebook login.")
            }
            else if user.isNew {
                // Associate the device with a user
                self.updateLocation()
                self.associateInstallationWithUser()
                var emptyArray:[PFObject] = []
                PFUser.currentUser().setObject(emptyArray, forKey:"seen")
                PFUser.currentUser().setObject(0, forKey: "wins")
                PFUser.currentUser().setObject(0, forKey: "losses")
                PFUser.currentUser().saveEventually()
                let blankData : [String:AnyObject] = [
                    "alias":"",
                    "bestMove":"",
                    "bio" :"",
                    "bodyType":"",
                    "height":"0' 0",
                    "hitsWith":"",
                    "reach" :"0' 0",
                    "weight":0,
                    "jailTime":0,
                    "lookingFor":"",
                    "tatoos":0,
                    "gpa":0.0
                ]
                PFUser.currentUser().setValuesForKeysWithDictionary(blankData)
                FBRequestConnection.startForMeWithCompletionHandler(){
                    (connection, result, error) in
                    if error == nil {
                        if let facebookId:String = result.objectForKey("id") as? String{
                            PFUser.currentUser().setObject(facebookId, forKey: "fbId")
                            PFUser.currentUser().saveInBackground()
                        }
                    }
                }
                NSLog("User signed up and logged in through Facebook!")
                self.loadData()
                self.performSegueWithIdentifier(Constants.NewUserSegue, sender: self)
            }
            else {
                self.updateLocation()
                self.associateInstallationWithUser()
                FBRequestConnection.startForMeWithCompletionHandler(){
                    (connection, result, error) in
                    if error == nil {
                        if let facebookId:String = result.objectForKey("id") as? String{
                            PFUser.currentUser().setObject(facebookId, forKey: "fbId")
                            PFUser.currentUser().saveInBackground()
                            println("successfully stored their fbId")
                        }
                    }
                }
                FBRequestConnection.startForMyFriendsWithCompletionHandler(){
                    (connection, result, error) in
                    if let friendObjects:AnyObject = result.objectForKey("data") {
                        var friendIds = []
                        PFUser.currentUser().setObject(friendObjects, forKey: "fbFriends")
                        PFUser.currentUser().saveInBackground()
                        // ONLY GETTING DATA BASED ON USERS WHO ALSO USE THE APP AND ARE FACEBOOK FRIENDS
//                        println("friendObjects\(friendObjects)")
                        // Issue a Facebook Graph API request to get your user's friend list
                        //[FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        //    if (!error) {
                        //    // result will contain an array with your user's friends in the "data" key
                        //    NSArray *friendObjects = [result objectForKey:@"data"];
                        //    NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                        //    // Create a list of friends' Facebook IDs
                        //    for (NSDictionary *friendObject in friendObjects) {
                        //    [friendIds addObject:[friendObject objectForKey:@"id"]];
                        //    }
                        //
                        
                        // This is the code for the "see what others think!" thing
                        //    // Construct a PFUser query that will find friends whose facebook ids
                        //    // are contained in the current user's friend list.
                        //    PFQuery *friendQuery = [PFUser query];
                        //    [friendQuery whereKey:@"fbId" containedIn:friendIds];
                        //    
                        //    // findObjects will return a list of PFUsers that are friends
                        //    // with the current user
                        //    NSArray *friendUsers = [friendQuery findObjects];
                        //    }
                        //    }];
                        
                    }
                }
                NSLog("User logged in through Facebook!")
                self.loadData()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        // After logging in with Facebook
        

    }
    private func associateInstallationWithUser(){
        // Associate the device with a user
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
    }
    private func updateLocation(){
        PFGeoPoint.geoPointForCurrentLocationInBackground(){
            (geopoint, error) in
            PFUser.currentUser()["location"] = geopoint
            PFUser.currentUser().saveEventually()
        }
    }
   
    func loadData(){
        let request:FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            if error == nil{
                if let dict = result as? Dictionary<String, AnyObject>{
                    println("me dict \(dict)")
                    let name:String = dict["name"] as AnyObject? as String
                    let gender:String = dict["gender"] as AnyObject? as String
                    let facebookID:String = dict["id"] as AnyObject? as String
                    let email:String = dict["email"] as AnyObject? as String
                    
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                    var URLRequest = NSURL(string: pictureURL)
                    var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                    
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            var picture = PFFile(data: data)
                            PFUser.currentUser().setObject(picture, forKey: "profilePicture")
                            PFUser.currentUser().setObject(picture, forKey:"profilePhoto")
                            PFUser.currentUser().saveInBackground()
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                    PFUser.currentUser().setValue(name, forKey: "fullName")
                    PFUser.currentUser().setValue(email, forKey: "email")
                    PFUser.currentUser().setValue(gender, forKey: "gender")
                    PFUser.currentUser().saveInBackground()
                }
            }
        }
    }
    // can replace this with an outlet at some point!
//    var fbl:FBLoginView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        self.fbl.delegate = self
//        self.fbl.readPermissions=["public_profile", "email", "user_friends", "user_location"]
//        self.fbl = FBLoginView()
//        self.fbl.center = self.view.center
//        self.view.addSubview(self.fbl)
    }
    
//    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
//        println("User Logged In")
//    }
    
//    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
//    println("User: \(user)")
//    println("User ID: \(user.objectID)")
//    println("User Name: \(user.name)")
//        // this was causing a crash for some reason but we really don't care about emailing people
////    var userEmail = user.objectForKey("email") as String
////    println("User Email: \(userEmail)")
//    }
    
//    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//    println("User Logged Out")
//    }
//    
//    func loginView(loginView : FBLoginView!, handleError:NSError) {
//    println("Error: \(handleError.localizedDescription)")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   override func awakeFromNib() {
    Colors().favoriteBackGroundColor(self)
    }
}

//class ViewController: UIViewController, FBLoginViewDelegate {
////
////@IBOutlet var fbLoginView : FBLoginView!
//
//override func viewDidLoad() {
//super.viewDidLoad()
//// Do any additional setup after loading the view, typically from a nib.
//
//
////self.fbLoginView.delegate = self
////self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
//
//}
//
//// Facebook Delegate Methods

//func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
//println("User Logged In")
//}
//
//func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
//println("User: \(user)")
//println("User ID: \(user.objectID)")
//println("User Name: \(user.name)")
//var userEmail = user.objectForKey("email") as String
//println("User Email: \(userEmail)")
//}
//
//func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//println("User Logged Out")
//}
//
//func loginView(loginView : FBLoginView!, handleError:NSError) {
//println("Error: \(handleError.localizedDescription)")
//}
//
//override func didReceiveMemoryWarning() {
//super.didReceiveMemoryWarning()
//// Dispose of any resources that can be recreated.
//}
//
//}
//
