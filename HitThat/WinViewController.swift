//
//  WinViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/17/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var opponentImage: UIImageView!
    @IBOutlet weak var messageLabel: OrangeLabel!
    var opponent:PFUser?
    var userWon:Bool?{
        didSet{
            updateUI()
        }
    }
    func updateUI(){
        if let won = userWon{
            self.resultLabel?.text = won ? "You WON!" : "You lost!"
            self.messageLabel?.text = won ? "Way to Hit That!" : "Better luck next time..."
        }
        if let opp = opponent{
            opp.fetchIfNeededInBackgroundWithBlock(){
                (data, error) in
                println("needed to fetch/")
                ParseAPI().installAUsersProfilePicture(data as PFUser, target: self.opponentImage)
            }
        }
      
    }
    override func viewDidLoad() {
        updateUI()
        Shapes().circularImage(opponentImage)
    }
}
