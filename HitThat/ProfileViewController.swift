//
//  ProfileViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userFights:UILabel!
    @IBOutlet weak var userWins:UILabel!
    @IBOutlet weak var userLosses:UILabel!

    @IBAction func cancelPressed(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI(){
            ParseAPI().installAUsersProfilePicture(userToDisplay!, target: profilePicture)
            let queryOrigin = ParseAPI().fightsQuery()
            let queryRecipient = ParseAPI().fightsQuery()
            queryOrigin.whereKey("origin", equalTo: PFUser.currentUser())
            queryRecipient.whereKey("recipient", equalTo: PFUser.currentUser())
            let fightsQuery = PFQuery.orQueryWithSubqueries([queryOrigin, queryRecipient])
        fightsQuery.countObjectsInBackgroundWithBlock(){
            (total, error) in
            if (error == nil){
                self.userFights?.text = "Fights: \(total)"
            }
        }
        let winsQuery = ParseAPI().winsQuery(userToDisplay!)
        let lossQuery = ParseAPI().lossQuery(userToDisplay!)
        winsQuery.countObjectsInBackgroundWithBlock(){
            (total, error) in
            if (error == nil) {
                self.userWins?.text = "Wins: \(total)"
            }
            
        }
        lossQuery.countObjectsInBackgroundWithBlock(){
            (total, error) in
            if (error == nil){
                self.userLosses?.text = "Losses: \(total)"
            }
            
        }
        self.userName.text = ParseAPI().stringOfUnwrappedUserProperty("fullName", user: userToDisplay!)
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
