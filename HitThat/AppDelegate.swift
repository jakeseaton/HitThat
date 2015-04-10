//
//  AppDelegate.swift
//  HitThat
//
//  Created by Jake Seaton on 3/30/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit
import CoreMotion


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, MSDynamicsDrawerViewControllerDelegate {

    var window: UIWindow?
    var centerContainer:MMDrawerController?
//    struct Motion{
//        static let Manager = CMMotionManager()
//    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("ToYMaUSeinWiDsnA5GDW8UhqwGkSwSV7ztvbDRje", clientKey:"s5Wp5niEL9OosYrTwLCk5Ixhg5li7QReiiCoV2kS")
        
        PFFacebookUtils.initializeFacebook()
        let settings = UIUserNotificationSettings(forTypes: (.Alert | .Badge | .Sound), categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        // Override point for customization after application launch.
//        let navbar = UINavigationBar.appearance()
//        navbar.barTintColor = Colors.navBarTintColor
        application.statusBarStyle = UIStatusBarStyle.LightContent
        
        // implementation of drawer
        var rootViewController = self.window!.rootViewController
        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier(Constants.CenterViewControllerIdentifier) as VersusViewController
        let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier(Constants.LeftViewControllerIdentifier) as MenuViewController
        let rightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier(Constants.RightViewControllerIdentifier) as FightsViewController
        let leftNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        let rightNav = UINavigationController(rootViewController: rightViewController)
        centerContainer = MMDrawerController(centerViewController: centerViewController, leftDrawerViewController: leftViewController, rightDrawerViewController:rightViewController)
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        
        if let notificationPayload: AnyObject = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]{
            // go directly to that screen
            let fightId = notificationPayload.objectForKey("fightObject") as String
            self.centerContainer!.toggleDrawerSide(.Right, animated: true, completion: nil)
            let fightObject = PFObject(withoutDataWithClassName: "Fights", objectId: fightId)
            if let fightsMenu = self.centerContainer!.rightDrawerViewController as? FightsViewController{
                fightsMenu.openFight(fightObject)
            }
            SoundAPI().soundNameToAudioPlayer("punch").play()
        }
        
        

        
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession:PFFacebookUtils.session())
        return wasHandled
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error)
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        PFPush.storeDeviceToken(deviceToken)
        PFPush.subscribeToChannelInBackground("")
        // idk if this is necessary.
//        let currentInstallation = PFInstallation.currentInstallation()
//        currentInstallation.setDeviceTokenFromData(deviceToken)
//        currentInstallation.channels = [""]
//        currentInstallation.saveInBackground()
    }


    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if let fightId = userInfo["fightObject"] as? String{
            self.centerContainer!.toggleDrawerSide(.Right, animated: true, completion: nil)
            let fightObject = PFObject(withoutDataWithClassName: "Fights", objectId: fightId)
            if let currentFight = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController as? FightOpenViewController{
                if (fightId == currentFight.fightToDisplay?.objectId){
                    currentFight.refreshFight()
                }
            }
            else{
                self.displayFight(fightObject)
                PFPush.handlePush(userInfo)
            }
            // if the top view controller.fightToDisplay = fightObject, then update it.
            SoundAPI().soundNameToAudioPlayer("punch").play()
            // self.displayFight(fightObject)
        }
        else{
            PFPush.handlePush(userInfo)
        }
        self.refreshTable()
    }
    func displayFight(fightObject:PFObject){
        fightObject.fetchIfNeeded()
        // check to see if it's already open.
        if let fightsMenu = self.centerContainer!.rightDrawerViewController as? FightsViewController{
            fightsMenu.openFight(fightObject)
        }
    }
    
    func refreshTable(){
        let fightsTable = self.centerContainer!.rightDrawerViewController as FightsViewController
        fightsTable.refresh()
    }
 

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        ParseAPI().resetBadges()
    }
    
    func applicationWillTerminate(application: UIApplication) { PFFacebookUtils.session().close() }

}

