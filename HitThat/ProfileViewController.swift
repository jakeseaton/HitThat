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
    @IBOutlet weak var recentDefeat:UILabel!
    @IBOutlet weak var recentVictory:UILabel!


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
        winsQuery.getFirstObjectInBackgroundWithBlock(){
            (object, error) in
            if (error == nil){
                if let opponentAlias = object.objectForKey("loserAlias") as? String{
                    self.recentVictory?.text = "Most Recent Victory: \(opponentAlias)"
                }
                winsQuery.countObjectsInBackgroundWithBlock(){
                    (total, error) in
                    if (error == nil) {
                        self.userWins?.text = "Wins: \(total)"
                        PFUser.currentUser().setObject(Int(total), forKey: "wins")
                        PFUser.currentUser().saveInBackground()
                    }else{
                        self.userWins?.text = "Wins: 0"
                    }
                }
            }
        }
//        winsQuery.countObjectsInBackgroundWithBlock(){
//            (total, error) in
//            if (error == nil) {
//                self.userWins?.text = "Wins: \(total)"
//                PFUser.currentUser().setObject(Int(total), forKey: "wins")
//                PFUser.currentUser().saveInBackground()
//            }
//
//        }
        lossQuery.getFirstObjectInBackgroundWithBlock(){
            (object, error) in
            if (error == nil){
                if let opponentAlias = object.objectForKey("winnerAlias") as? String{
                    self.recentDefeat?.text = "Most Recent Defeat: \(opponentAlias)"
                }
                lossQuery.countObjectsInBackgroundWithBlock(){
                    (total, error) in
                    if (error == nil) {
                        self.userLosses?.text = "Losses: \(total)"
                    }else{
                        self.userLosses?.text = "Losses: 0"
                    }
                }
            }
        }
        self.userName.text = ParseAPI().stringOfUnwrappedUserProperty("fullName", user: userToDisplay!)
    }
    

    override func viewDidLoad() {
     super.viewDidLoad()
//        self.navigationController?.navigationBar.titleTextAttributes = 
//        [self.navigationController.navigationBar
//            setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        if let curr = PFUser.currentUser(){
            self.userToDisplay = curr
            self.title = ParseAPI().stringOfCurrentUserProperty("fullName")
            
        }
        
        Shapes().circularImage(self.profilePicture)
        self.profilePicture?.layer.borderColor = Colors.favoriteBackgroundColor.CGColor
        self.profilePicture.layer.borderWidth = 3.0
        
        //Colors().gradient(self)
    }
}
