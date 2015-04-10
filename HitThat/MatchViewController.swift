//
//  MatchViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/21/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    var userToDisplay:PFUser?
    var fightToDisplay:PFObject?
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    // need outlets for the table of posts, the picture, etc
    @IBAction func keepPlayingPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(Constants.KeepPlayingSegue, sender: self)
    }
    
//    self.bioLabel.text = "Bio: " + ParseAPI().stringOfUnwrappedUserProperty("bio", user: userToDisplay!)
//    ParseAPI().installAUsersProfilePhoto(userToDisplay!, target: self.headerImageView, optionalBlurTarget: self.headerBlurImageView)
//    self.distanceLabel.text = "Distance: " + ParseAPI().distanceToUser(userToDisplay!).description + "mi"

    override func viewDidLoad() {
        super.viewDidLoad()
        println("didLoad")
        Colors().gradient(self)
        Shapes().circularImage(self.profilePicture)
        Shapes().circularImage(self.userProfilePicture)
        if let userObject = userToDisplay{
            fullName.text = ParseAPI().stringOfUnwrappedUserProperty("fullName", user: userObject)
            ParseAPI().installAUsersProfilePicture(userObject, target: self.profilePicture)
            

        }
        if let currentUser = PFUser.currentUser(){
           ParseAPI().installAUsersProfilePicture(currentUser, target: self.userProfilePicture)
            userFullName.text = ParseAPI().stringOfCurrentUserProperty("fullName")
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func locatePressed(sender: AnyObject) {
        println("locating: \(userToDisplay)")
        performSegueWithIdentifier(Constants.LocateSegueIndentifier, sender: userToDisplay)
    }
    @IBAction func startFightPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.displayFight(fightToDisplay!)
        println("start fight pressed")
    }
    @IBAction func gangBangPressed(sender: AnyObject) {
        println("gangbanging: \(userToDisplay)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.LocateSegueIndentifier{
            if let locateViewController = segue.destinationViewController as? MapViewController{
                locateViewController.userToLocate = userToDisplay
            }
        }
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
