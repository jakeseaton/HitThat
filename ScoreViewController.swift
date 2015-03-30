//
//  ScoreViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSnatches: UILabel!
    @IBOutlet weak var userBeats: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    @IBAction func cancelPressed(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func updateUI(){
        var snatches = 0
        var fights = 0
        if let curr = PFUser.currentUser(){
            if let img = curr["profilePicture"] as AnyObject as? PFFile {
                println("got their profile picture from the object")
                img.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    println("fired the block in the background")
                    if error != nil {
                        println("ERROR RETRIEVING IMAGE")
                    }
                    else{
                        print("set profile picture image")
                        self.profilePicture.image = UIImage(data:imageData)
                    }
                }
            }
            else{
                println("this didn't work")
            }
            if let currentUserName = curr.username{
                let snatchesQuery = PFQuery(className:"Snatches")
                println("\(currentUserName)")
                snatchesQuery.whereKey("recipient", equalTo:currentUserName)
                snatchesQuery.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                    if let results:[AnyObject] = objects{
                        println("\(results)")
                        snatches = results.count
                        self.userSnatches.text = "\(snatches) want to hit that!"
                    }
                }
                let fightsQuery = PFQuery(className:"Fights")
                fightsQuery.whereKey("recipient", equalTo:currentUserName)
                fightsQuery.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                    if let results:[AnyObject] = objects{
                        println("\(results)")
                        fights = results.count
                        self.userBeats.text = "\(fights) want to hit you."
                    }
                }
            }
            if let currFullName = curr.objectForKey("fullName") as AnyObject as? String{
                userName.text = currFullName
            }
        }
    }
    
    override func viewDidLoad() {
     super.viewDidLoad()
        updateUI()
    }
}
