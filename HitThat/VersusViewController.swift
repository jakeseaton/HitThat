//
//  VersusViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/2/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class VersusViewController: UIViewController {
    // Public API
    var userToDisplay:PFUser?{
        didSet{
            self.updateUI()
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBAction func fightPressed(sender: AnyObject) {
        self.getNewUser()
    }
    private func getNewUser(){
        let query = PFUser.query()
//        let seen:[PFUser] = //PFUser.currentUser().objectForKey("fights")
//        let task = query.getFirstObjectInBackground()
//        userToDisplay = task.result as? PFUser
        query.getFirstObjectInBackgroundWithBlock(){
            result, error in
            self.userToDisplay = result as? PFUser
        }
    }
    
    private func updateUI(){
        self.fullName.text = userToDisplay?.objectForKey("fullName") as? String
        let img = userToDisplay?.objectForKey("profilePicture") as? PFFile
        img?.getDataInBackgroundWithBlock(){
            (imageData, error) -> Void in
            if error != nil {
                println("Error retrieving image")
            }
            else{
                println("got the image")
                self.profilePicture.image = UIImage(data:imageData)
                self.toggleSpinner()
            }
        }
        println("updateUI returned")
    }
    override func viewDidLoad() {
        // add spinner
        self.getNewUser()
    }
    private func toggleSpinner(){
        println("toggled spinner")
    }
}
