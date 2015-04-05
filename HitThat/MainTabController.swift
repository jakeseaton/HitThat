//
//  MainTabController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/4/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    override func viewDidAppear(animated: Bool) {
        if let currUserName = PFUser.currentUser(){
            super.viewDidAppear(true)
        }
        else{
            super.viewDidAppear(true)
            performSegueWithIdentifier(Constants.NoUserSegue, sender: self)
        }
    }
}
