//
//  SnatchParseAPI.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct SnatchParseAPI {
//    static var currentUserPicture:UIImage?{
//        if let curr = PFUser.currentUser(){
//            if let img = curr["profilePicture"] as AnyObject as? PFFile {
//                img.getDataInBackgroundWithBlock {
//                (imageData: NSData!, error: NSError!) -> Void in
//                if !error {
//                    let image = UIImage(data:imageData)
//                    return image
//                }
//            }
//            {
//                return img
//            }
//            else{
//                return nil
//            }
//        }
//        else{
//            return nil
//        }
//    }
//    
    static var currentUserFullName:String?{
        if let curr = PFUser.currentUser(){
            return curr["fullName"] as AnyObject as? String
        }
        else{
            return nil
        }
    }
    static var currentUserName:String? {
        if let curr = PFUser.currentUser(){
            return curr.username
        }
        else {
            return nil
        }
    }
//    var currentUserFacebookFriends:Array?{
//        
//    }
//    var currentUserRatio:(Int,Int)?{
//        if let cuf = currentUserFights {
//            if let cus = currentUserSnatches{
//                
//            }
//        }
//    }
    
    static var currentUserWantsToFight:[PFObject]{
        var query = PFQuery(className: "Fights")
        query.whereKey("origin", equalTo:currentUserName!)
        var answer:[PFObject] = []
        query.findObjectsInBackgroundWithBlock(){
            (objects: [AnyObject]!, error:NSError!) in
            if error != nil {
                println("ERROR")
            } else{
                if let results = objects as? [PFObject]{
                    answer = results
                }
            }
        }
        return answer
    }
    
    // I think this is all happening asynchronously
    static var currentUserWantsToSnatch:[PFObject]{
        var query = PFQuery(className: "Snatches")
        query.whereKey("origin", equalTo:currentUserName!)
        var answer:[PFObject] = []
        query.findObjectsInBackgroundWithBlock(){
            (objects:[AnyObject]!, error:NSError!) in
            if error != nil{
                println("ERROR")
                
            }else{
                if let results = objects as? [PFObject]{
                    answer = results
                }
            }
        }
        return answer
    }
    // DO WE NEED TO DO MULTITHREADING HERE? ARE THESE QUERIES HAPPENING OFF THE MAIN THREAD?
    static var currentUserFights:[PFObject]{
        var query = PFQuery(className:"Fights")
        // this is bad code..need to do if let
        query.whereKey("recipient", equalTo:currentUserName!)
        var answer:[PFObject] = []
        query.findObjectsInBackgroundWithBlock(){
            (objects: [AnyObject]!, error:NSError!) in
            if error != nil {
                println("ERROR")
            } else{
                if let results = objects as? [PFObject]{
                    answer = results
                }
            }
        }
        return answer
    }
    // THIS ALL HAPPENS ASYNCHRONOUSLY
    static var currentUserSnatches:[PFObject]{
        var query = PFQuery(className:"Snatches")
        query.whereKey("recipient", equalTo:currentUserName!)
        var answer:[PFObject] = []
        query.findObjectsInBackgroundWithBlock(){
            (objects, error:NSError!) in
            if error != nil{
                println("ERROR")
            } else{
                if let results = objects as? [PFObject]{
                    answer = results
                }
            }
        }
        // need to make currentUserSnatches return a BF Task that we can evaluate
//        query.findObjectsInBackground().continueWithSuccessBlock{
//            (task:BFTask!) -> AnyObject in
//            
//        }
        return answer
        
    }
//    static var currentUserLocation:CLLocationCoordinate2D{
//        var query = PFQuery(className: "Locations"){
//            query.whereKey("username", equalTo:currentUserName!)
//            var answer
//        }
//    }
    
    static var userRatio:(Int, Int) {
        let snatches:Int = currentUserSnatches.count
        let fights:Int = currentUserFights.count
        return (snatches, fights)
    }
//    static var currentUserLocation:CLLocation{
//        var query = PFQuery(ClassName:"Locations")
//        query.whereKey(username, equalTo(currentUserName!)
//        var answer: CLLocation = AppDelegate.Motion.Manager.
//        query.findObjectsInBackgroundWithBlock(){
//            (objects, error) in
//            if error != nil{
//                println("ERROR")
//            }else{
//                if let results = objects as? [PFObject]{
//                    
//                }
//            }
//                
//        }
//    }

    func updateUserLocation(location: CLLocation){
        var query = PFQuery(className:"Locations")
        query.whereKey("username", equalTo:SnatchParseAPI.currentUserName!)
        query.getFirstObjectInBackgroundWithBlock{
            (object, error) in
            if error != nil{
                // did not find any locaiton for the current user
                println("ERROR")
                let object = PFObject(className: "Locations")
                object["username"] = SnatchParseAPI.currentUserName!
                object["location"] = location
                object.saveInBackground()
            } else{
                object.setObject(location, forKey: "location")
            }
        }
    }
    func storeASnatch(post:PFObject){
        if let curr = PFUser.currentUser().username{
            println("\(post)")
//            post.addObject(curr, forKey: "votedOn")
//            post.add("votedOn",curr)
            PFUser.currentUser().addObject(post.objectId, forKey: "seen")
            PFUser.currentUser().saveInBackground()
            let object = PFObject(className: "Snatches")
            object["origin"] = curr
            object["recipient"] = post.objectForKey("origin") as AnyObject as? String
            object["post"] = post
            object.saveInBackground()
        }
        
    }
    func storeASnatchOrFight(post:PFObject, fight:Bool){
        // first, store that the user wants to get snatch or fight
        if let originOfPost = post.objectForKey("origin") as AnyObject as? String{
            let objectToStore = fight ? PFObject(className: "Fights") : PFObject(className: "Snatches")
            objectToStore["origin"] = PFUser.currentUser().username
            objectToStore["recipient"] = originOfPost
            objectToStore["post"] = post
            let query = PFUser.query()
            query.whereKey("username", equalTo:originOfPost)
            query.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                if error != nil{
                    println(error)
                }
                else{
                    println(objects)
                    if let originUser = objects[0] as? PFUser{
                        objectToStore["recipientName"] = originUser["fullName"] as String
                        objectToStore.saveInBackground()
                    }
                    else{
                        println("could not convert to PFUser")
                    }
                }
                
                
            }
            // Find devices associated with that user
            let pushQuery = PFInstallation.query()
            pushQuery.whereKey("user", matchesQuery: query)
            
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            let fullName = PFUser.currentUser().objectForKey("fullName") as AnyObject as String
            let pushMessage = fight ? "\(fullName) wants to hit you." : "\(fullName) wants to hit that!"
            push.setMessage(pushMessage)
            push.sendPushInBackground()
            /* Could do badges like this
            let data = [
            "alert" : "The Mets scored! The game is now tied 1-1!",
            "badge" : "Increment",
            "sounds" : "cheering.caf"
            ]
            let push = PFPush()
            push.setChannels(["Mets"])
            push.setData(data)
            push.sendPushInBackground()
            */
        }
        // then, increment the user's seen posts
        PFUser.currentUser().addObject(post.objectId, forKey: "seenPosts")
        PFUser.currentUser().saveInBackground()
    }
    
    func resetBadges(){
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
    }
    func notifyTrackedUser(user: PFUser){
        let userQuery = PFUser.query()
        userQuery.whereKey("username", equalTo: user.username)
        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery: userQuery)
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        let fullName = PFUser.currentUser().objectForKey("fullName") as AnyObject as String
        let pushMessage = "\(fullName) is tracking your location!"
        push.setMessage(pushMessage)
        push.sendPushInBackground()
    }
    func storeAFightFromVersusScreen(recipient:PFUser){
        if let originUser = PFUser.currentUser(){
            let object = PFObject(className: "Fights")
            object["origin"] = originUser
            object["recipient"] = recipient
            object.saveInBackground()
        }
    }
    func getAUsersProfilePicture(user:PFUser) -> UIImage {
        let img = user["profilePicture"] as AnyObject as? PFFile
        let data = img?.getData()
        return UIImage(data: data!)!
    }
//    func getAUsersProfilePhoto(user:PFUser) -> UIImage{
//        if let img = user["profilePhoto"] as AnyObject as? PFFile{
//            let task = img.getDataInBackground()
//            return task
//        }
//        else{
//            return nil
//        }
//    }
}