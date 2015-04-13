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
    override func awakeFromNib() {
        super.awakeFromNib()
        Colors().favoriteBackGroundColor(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = PFUser.currentUser(){
            // ParseAPI().installAUsersProfilePicture(currentUser, target: self.userImage!)
            ParseAPI().installAUsersProfilePhoto(currentUser, target: self.userImage, optionalBlurTarget: nil)
        }
        Colors().gradient(self)

        // Do any additional setup after loading the view.
    }
    func updateUI(){
        if let curr = PFUser.currentUser(){
            ParseAPI().installAUsersProfilePhoto(curr, target: userImage, optionalBlurTarget: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row){
        case 0:
            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.CenterViewControllerIdentifier) as VersusViewController
//            var centerNavController = UINavigationController(rootViewController: centerViewController)
            self.switchCenterContainer(centerViewController)
            break
        case 1:
            var scoreViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
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
            println(Constants.menuItems[3])
//            var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsFormViewController") as SettingsFormViewController
//            self.switchCenterContainer(centerViewController)
            break
        case 4:
            println(Constants.menuItems[4])
            break
        case 5:
            // log in
            self.logInSelected()
            break
        case 6:
            ParseAPI().resetSeen()
            ParseAPI().clearAllFights()
            break
        default:
            println("\(Constants.menuItems[indexPath.row]) is selected")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MenuCellRestorationIdentifier, forIndexPath: indexPath) as MenuCell
        cell.menuLabel.text = Constants.menuItems[indexPath.row]
        cell.menuIcon.image = UIImage(named: Constants.menuIcons[indexPath.row])
        return cell

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.scrollEnabled = false
        return Constants.menuItems.count
    }
    func switchCenterContainer(newCenterController:UIViewController){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.centerContainer!.centerViewController = newCenterController
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func logInSelected(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let versusViewController = appDelegate.centerContainer!.centerViewController as? VersusViewController{
            versusViewController.performSegueWithIdentifier(Constants.NoUserSegue, sender: versusViewController)
        }
        
    }

}
