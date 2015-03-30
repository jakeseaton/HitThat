//
//  GenericProfileViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/21/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class GenericProfileViewController: UIViewController {
    var userToDisplay:PFUser?
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    // need outlets for the table of posts, the picture, etc

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userObject = userToDisplay{
            println("\(userObject)")
            fullName.text = userObject.objectForKey("fullName") as AnyObject as? String
            if let img = userObject["profilePicture"] as AnyObject as? PFFile {
                img.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    if error != nil {
                        println("ERROR RETRIEVING IMAGE")
                    }
                    else{
                        self.profilePicture.image = UIImage(data:imageData)
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func locatePressed(sender: AnyObject) {
        println("locating: \(userToDisplay)")
        performSegueWithIdentifier(Constants.LocateSegueIndentifier, sender: userToDisplay)
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
