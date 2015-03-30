//
//  TabBarController.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstItem = self.tabBar.items![0] as UITabBarItem
        firstItem.selectedImage = UIImage(named:Constants.HomeSelectedImage)
        let secondItem = self.tabBar.items![1] as UITabBarItem
        secondItem.selectedImage = UIImage(named:Constants.UserSelectedImage)
        let thirdItem = self.tabBar.items![2] as UITabBarItem
        thirdItem.selectedImage = UIImage(named: Constants.FightsSelectedImage)
        let fourthItem = self.tabBar.items![3] as UITabBarItem
        fourthItem.selectedImage = UIImage(named:Constants.SnatchesSelectedImage)
//        let secondItem = tabBarController.tabBar.items![1] as UITabBarItem
//        secondItem.selectedImage = UIImage(named: "home-selected")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if let currUserName = SnatchParseAPI.currentUserName{
            super.viewDidAppear(true)
        }
        else{
            super.viewDidAppear(true)
            performSegueWithIdentifier(Constants.LogInSegue, sender: self.view)
        }
    }
}
