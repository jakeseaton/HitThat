//
//  VersusTableViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/4/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class VersusTableViewController: UITableViewController {
    var userToDisplay:PFUser?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var fightingSinceLabel: UILabel!
    @IBOutlet weak var jailTimeLabel: UILabel!
    @IBOutlet weak var hitsWithLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let user = PFUser.currentUser(){
////            self.userToDisplay = user
//        }
    }
    
    private func updateUI(){
        // change this to bio...you just forgot to save it.
        self.bioLabel.text = "Bio: " + (userToDisplay!.objectForKey("fullName") as AnyObject as? String)!
        let winsInt = userToDisplay?.objectForKey("wins") as Int
        let jailTimeInt = userToDisplay?.objectForKey("jailtime") as Int
        self.winsLabel.text = "Wins: \(winsInt)"
        self.jailTimeLabel.text = "Jail Time: \(jailTimeInt) year(s)"
        self.weightLabel.text = "Weight: " + (userToDisplay?.objectForKey("weight") as String)
        self.heightLabel.text = "Height: " + (userToDisplay?.objectForKey("height") as String)
        self.hitsWithLabel.text = "Hits With: " + (userToDisplay?.objectForKey("hitsWith") as String)
        let date = userToDisplay?.objectForKey("fightingSince") as NSDate
        self.fightingSinceLabel.text = "Fighting Since: " + date.description
    }
}
