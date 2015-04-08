//
//  ScoreViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSnatches: UILabel!
    @IBOutlet weak var userBeats: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userFights:UILabel!
    @IBOutlet weak var userWins:UILabel!

    @IBAction func cancelPressed(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func updateUI(){
            let img = userToDisplay!["profilePicture"] as PFFile
            img.getDataInBackgroundWithBlock(){
                (data, error) in
                if (error == nil){
                self.profilePicture.image = UIImage(data:data)
                }
            }
            let fightsQuery = PFQuery(className: "Fights")
            fightsQuery.whereKey("origin", equalTo:userToDisplay!)
            fightsQuery.whereKey("recipient", equalTo:userToDisplay!)
            fightsQuery.countObjectsInBackgroundWithBlock(){
                (count, error) in
                if (error == nil){
                 self.userFights.text = "\(count) fights."
                }
            }
            self.userName.text = userToDisplay!["fullName"] as? String
    }
    

    override func viewDidLoad() {
     super.viewDidLoad()
        if let curr = PFUser.currentUser(){
            self.userToDisplay = curr
        }
        Shapes().circularImage(self.profilePicture)
        Colors().gradient(self)
    }
}
