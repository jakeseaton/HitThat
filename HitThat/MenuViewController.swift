//
//  MenuViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    var menuItems = ["Home", "My Profile", "My Fights", "Settings", "About"]
    var menuIcons = ["homeFilled", "userMale", "myFightsIcon", "settingsIcon", "aboutIcon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        Colors().gradient(self)
        if let currentUser = PFUser.currentUser(){
            // this is synchronous for now
            let image = SnatchParseAPI().getAUsersProfilePicture(currentUser)
            self.userImage?.image = image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row){
        case 0:
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.CenterViewControllerIdentifier) as VersusViewController
//            var centerNavController = UINavigationController(rootViewController: centerViewController)
            self.switchCenterContainer(centerViewController)
            break
        case 1:
            var scoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ScoreViewController") as ScoreViewController
            var scoreNavController = UINavigationController(rootViewController: scoreViewController)
            self.switchCenterContainer(scoreNavController)

            break
        case 2:
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true){
                (complete) in
                if (complete){
                    appDelegate.centerContainer!.toggleDrawerSide(.Right, animated: true, completion: nil)
                }
            }
            break
        case 3:
            println(menuItems[3])
//            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsFormViewController") as SettingsFormViewController
//            self.switchCenterContainer(centerViewController)
            break
        case 4:
            println(menuItems[4])
            break
        default:
            println("\(menuItems[indexPath.row]) is selected")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MenuCellRestorationIdentifier, forIndexPath: indexPath) as MenuCell
        cell.menuLabel.text = menuItems[indexPath.row]
        cell.menuIcon.image = UIImage(named: menuIcons[indexPath.row])
        return cell

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.scrollEnabled = false
        return menuItems.count
    }
    func switchCenterContainer(newCenterController:UIViewController){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.centerContainer!.centerViewController = newCenterController
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
