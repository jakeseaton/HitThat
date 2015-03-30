//
//  MainNavigationController.swift
//  snatch
//
//  Created by Jake Seaton on 3/28/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidAppear(animated: Bool) {
        if let currUserName = PFUser.currentUser(){
            super.viewDidAppear(true)
        }
        else{
            super.viewDidAppear(true)
            performSegueWithIdentifier(Constants.LogInSegue, sender: self.view)
        }
    }
}
