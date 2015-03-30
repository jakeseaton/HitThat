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
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    struct Motion{
        static let Manager = CMMotionManager()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("ToYMaUSeinWiDsnA5GDW8UhqwGkSwSV7ztvbDRje", clientKey:"s5Wp5niEL9OosYrTwLCk5Ixhg5li7QReiiCoV2kS")
        
        PFFacebookUtils.initializeFacebook()
        var settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        println(settings)
        let alerts = UIUserNotificationSettings(forTypes: (.Alert | .Badge | .Sound), categories: nil)
        //        let badges = UIUserNotificationSettings(forTypes: .Badge, categories: nil)
        //        let sounds = UIUserNotificationSettings(forTypes: .Sound, categories: nil)
        application.registerUserNotificationSettings(alerts)
        //        UIApplication.sharedApplication().registerUserNotificationSettings(badges)
        //        UIApplication.sharedApplication().registerUserNotificationSettings(sounds)
        application.registerForRemoteNotifications()
        settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        println(settings)
        // Override point for customization after application launch.
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
//        let currentInstallation = PFInstallation.currentInstallation()
//        println("registered!")
//        currentInstallation.setDeviceTokenFromData(deviceToken)
//        currentInstallation.channels = ["global"]
//        currentInstallation.saveInBackground()
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        PFFacebookUtils.session().close()
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

