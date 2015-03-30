//
//  MainViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/24/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
//    var parse = SnatchParseAPI()
    var currentPost:PFObject?{
        willSet(newValue) {
            postText.text = newValue?.objectForKey("text") as? String
        }
    }
    @IBOutlet weak var postText: UITextView!
    
    @IBAction func snatchPressed(sender: AnyObject) {
        if let snatchToStore = currentPost{
            SnatchParseAPI().storeASnatch(snatchToStore)
        }
    }
    
    @IBAction func fightPressed(sender: AnyObject) {
    }
    override func viewDidLoad() {
        if let currentUserName = SnatchParseAPI.currentUserName{
            displayAPostTheUserHasntVotedOn(currentUserName)
        }
    }
    
    
    func displayAPostTheUserHasntVotedOn(userName:String){
        // make sure the user hasn't already voted on this post
//        let queryForSnatches = PFQuery(className:"Snatches")
//        queryForSnatches.whereKey(key: String!, notEqualTo: <#AnyObject!#>)
        let userVotedOn = PFUser.currentUser().objectForKey("votedOn") as [String]
        let query = PFQuery(className: "Posts")
        //            query.whereKey("origin", notEqualTo: currentUserName)
        query.findObjectsInBackgroundWithBlock(){
            (objects, error) in
            if let results = objects as? [PFObject]{
                let filteredResults = results.filter{
//                    println("\(userVotedOn)")
//                    println("$0,\($0)")
                    return !contains(userVotedOn, $0.objectId)
                }
                if !filteredResults.isEmpty{
                    let currentPost = filteredResults[0]
                    self.currentPost = currentPost
                }
//                if !results.isEmpty{
//                    let currentPost = results[0]
//                    self.currentPost = currentPost
//                }
                else{
                    println("no more posts that this user hasn't created or commented on!")
                }
                //                    self.postText.text = currentPost.objectForKey("text") as? String
            }
        }
    }
}
