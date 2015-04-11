//
//  ParseAPI.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct ParseAPI {
    
    func userQuery()->PFQuery{
        let query = PFUser.query()
        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        return query
    }
    
    func fightsQuery()-> PFQuery{
        let query = PFQuery(className: "Fights")
//        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        return query
    }
    func installationQuery() -> PFQuery{
        let query = PFInstallation.query()
        query.cachePolicy = PFCachePolicy.CacheElseNetwork
        return query
        
    }
    func winsQuery(user: PFUser) -> PFQuery{
        let query = PFQuery(className: "Wins")
        query.whereKey("winner", equalTo:user)
        query.orderByDescending("createdAt")
        return query
    }
    func lossQuery(user:PFUser) -> PFQuery{
        let query = PFQuery(className: "Wins")
        query.whereKey("loser", equalTo: user)
        query.orderByDescending("createdAt")
        return query
    }
    
    func updateUserLocation(){
        if let user = PFUser.currentUser(){
            PFGeoPoint.geoPointForCurrentLocationInBackground(){
                (geopoint, error) in
                if (error == nil){
                    PFUser.currentUser()["location"] = geopoint
                    PFUser.currentUser().saveEventually()
                }
            }
        }
    }
    func distanceToUser(otherUser:PFUser) -> CGFloat{
        if let location = PFUser.currentUser()?.objectForKey("location") as? PFGeoPoint{
            if let opponentLocation = otherUser.objectForKey("location") as? PFGeoPoint{
                return CGFloat(location.distanceInMilesTo(opponentLocation))
            }
            else{
                // idk
                return CGFloat(1)
            }
        }
        else{
            // idk
            return CGFloat(1)
        }
    }

    func storeASnatchOrFight(post:PFObject, fight:Bool){
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
        let uQuery = userQuery()
        uQuery.whereKey("username", equalTo: user.username)
        let pushQuery = installationQuery()
        pushQuery.whereKey("user", matchesQuery: uQuery)
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        let alias = stringOfCurrentUserProperty("alias")
        let pushMessage = "\(alias) is tracking your location!"
        push.setMessage(pushMessage)
        push.sendPushInBackground()
    }
    
    func storeAFightFromVersusScreen(recipient:PFUser) -> PFObject? {
        if let originUser = PFUser.currentUser(){
            let data = [
                "origin": originUser,
                "originStamina":CGFloat(1),
                "originAlias" : stringOfUnwrappedUserProperty("alias", user: originUser),
                "recipient": recipient,
                "recipientStamina": CGFloat(1),
                "recipientAlias": stringOfUnwrappedUserProperty("alias", user: recipient)
            ]
            let object = PFObject(className: "Fights", dictionary:data)
            object.saveInBackground()
            
            // Find devices associated with that user
            let pushQuery = installationQuery()
            pushQuery.whereKey("user", equalTo: recipient)
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            let alias = stringOfUnwrappedUserProperty("alias", user: originUser)
            let pushMessage = "\(alias) wants to fight you."
            push.setMessage(pushMessage)
            push.sendPushInBackground()
            
            // Tell the App Delegate to REFRESH THE TABLE
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.refreshTable()
            
            return object
        }
        else{return nil}
        
    }
    func notifyPunchedUser(recipientOfPunch:PFUser, fightObject:PFObject, sound: String){
        let alias = stringOfCurrentUserProperty("alias")
        let data = [
            "alert" : "\(alias) punched you!",
            "badge" : "Increment",
            "sounds" : sound,
            "fightObject" : fightObject.objectId
        ]
        let pushQuery = installationQuery()
        pushQuery.whereKey("user", equalTo:recipientOfPunch)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackground()
        
        // Update the user that just punched location.
       updateUserLocation()
    }
    
    // these run synchronously...
    func getAUsersProfilePicture(user:PFUser) -> UIImage {
        let img = user["profilePicture"] as AnyObject as? PFFile
        let data = img?.getData()
        return UIImage(data: data!)!
    }
    func getAUsersProfilePhoto(user:PFUser) -> UIImage{
        let img = user["profilePhoto"] as AnyObject as? PFFile
        let data = img?.getData()
        return UIImage(data:data!)!
    }
    
    // these don't
    func installAUsersProfilePicture(user:PFUser, target:UIImageView){
        let img = user["profilePicture"] as AnyObject as? PFFile
        img?.getDataInBackgroundWithBlock(){
            (data, error) in
            if error == nil{
                target.image = UIImage(data: data)
            }
        }
    }
    func installAUsersProfilePhoto(user:PFUser, target:UIImageView, optionalBlurTarget:UIImageView?){
        let img = user["profilePhoto"] as AnyObject as? PFFile
        img?.getDataInBackgroundWithBlock(){
            (data, error) in
            if error == nil{
                let resultImage = UIImage(data:data)
                target.image = resultImage
                if let blurTarget = optionalBlurTarget{
                    blurTarget.image = resultImage?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
                }
            }
        }
    }
    
    func stringOfCurrentUserProperty(key:String) -> String{
        let answer = PFUser.currentUser().objectForKey(key) as AnyObject as String
        return answer
        
    }
    func stringOfUnwrappedUserProperty(key:String, user: PFUser) -> String{
        return user.objectForKey(key) as AnyObject as String
    }
    func incrementFightCountOfUsers(originUser:PFUser, recipientUser:PFUser){
        let key = "fightCount"
        originUser.incrementKey(key)
        recipientUser.incrementKey(key)
        originUser.saveInBackground()
        recipientUser.saveInBackground()
    }
    func incrementCountersFromFightResult(winner:PFUser, loser:PFUser){
        winner.incrementKey("wins")
        winner.saveEventually()
        loser.incrementKey("losses", byAmount: -1)
        loser.saveInBackground()
    }
    func resetSeen(){
        if let currUser = PFUser.currentUser(){
            let empty:[PFUser] = []
            PFUser.currentUser().setObject(empty, forKey: "seen")
            PFUser.currentUser().saveInBackground()
            
        }
    }
    func clearAllFights(){
        if let currUser = PFUser.currentUser(){
            let queryOrigin = fightsQuery()
            queryOrigin.whereKey("origin", equalTo:currUser)
            queryOrigin.findObjectsInBackgroundWithBlock(){
                (objects, error) in
                println("origin")
                println(objects)
                if error == nil{
                    for object in objects{
                        object.deleteInBackground()
                    }
                }
            }
            let queryRecipient = fightsQuery()
            queryRecipient.whereKey("recipient", equalTo:currUser)
            queryRecipient.findObjectsInBackgroundWithBlock(){
                (objects, error) in
                println(objects)
                println("recipient")
                if error == nil{
                    for object in objects{
                        object.deleteInBackground()
                    }
                }
            }
        }
    }
    func fightWasCompleted(fight: PFObject, winner:PFUser, loser:PFUser){
        loser.fetchInBackgroundWithBlock(){
            (result, error) in
            if (error == nil){
                let data = ["fight":fight, "winner": winner, "winnerAlias":winner["alias"] as String, "loser":loser, "loserAlias":result["alias"] as String]
                let object = PFObject(className: "Wins", dictionary: data)
                object.saveInBackground()
            }
        }
        fight.deleteInBackgroundWithBlock(){
            (succeeded, error) in
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.refreshTable()
        }
    }
    func userIsMale(user:PFUser) -> Bool{
        user.fetchIfNeeded()
        return(stringOfUnwrappedUserProperty("gender", user: user) == "male")
    }
}