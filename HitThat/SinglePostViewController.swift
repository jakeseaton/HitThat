//
//  SinglePostViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class SinglePostViewController: UIViewController {
    
    @IBAction func snatchPressed(sender: AnyObject) {
        if let currentObject = objectToDisplay{
            if let origin = currentObject.objectForKey("origin") as AnyObject as? String{
                let object = PFObject(className: "Snatches")
                object["origin"] = SnatchParseAPI.currentUserName
                object["recipient"] = origin
                object["post"] = objectToDisplay
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo:origin)
                query.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                    if let originUser = objects[0] as? PFUser{
                        object["recipientName"] = originUser["fullName"] as String
                        object.saveInBackgroundWithBlock(){
                            (success,error) in
                            self.performSegueWithIdentifier(Constants.SnatchedSegue, sender: self.objectToDisplay)
                        }
                    }else{
                        println("could not convert to PFUser")
                    }
                }
                // increment the post, or something
                // idk
            }
        }
        else{
            println("ERROR--No User")
        }
        
        // store this post in the background as one that the user has snatched
        // then give that as the sender for the segue
    }
    
    @IBAction func fightPressed(sender: AnyObject) {
        if let currentObject = objectToDisplay{
            if let origin = currentObject.objectForKey("origin") as AnyObject as? String{
                let object = PFObject(className: "Fights")
                object["origin"] = SnatchParseAPI.currentUserName
                object["recipient"] = origin
                object["post"] = objectToDisplay
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo:origin)
                query.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                    if let originUser = objects[0] as? PFUser{
                        object["recipientName"] = originUser["fullName"] as String
                        object.saveInBackgroundWithBlock(){
                            (success,error) in
                            self.performSegueWithIdentifier(Constants.SnatchedSegue, sender: self.objectToDisplay)
                        }
                    }else{
                        println("could not convert to PFUser")
                    }
                }
                // increment the post, or something
                // idk
            }
        }
        else{
            println("ERROR--No User")
        }
    }
    @IBOutlet weak var postText: UILabel!
//    var toDisplay:String?
    var objectToDisplay:PFObject?
//    init(postToDisplay:PFObject){
//        if let derp = postToDisplay.objectForKey("text") as? String{
//            println("yay?")
//            self.postText = derp
//        }
//        else{
//            println("wow fuck this")
//        }
//        
////        self.postText.text = postToDisplay.objectForKey("text") as? String
//        super.init(nibName: nil, bundle: nil);
//        
//    }
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var query = PFQuery(className:"Posts")
//        query.whereKey("objectId", equalTo: confusion!.objectId)
//        query.findObjectsInBackgroundWithBlock(){
//            (objects, error) in
//            if let results = objects as? [PFObject]{
//                let derp = results[0].objectForKey("text") as? String
////                println("\(results[0].objectForKey("text"))")
////                println(derp)
//            }
//        }
//        // Do any additional setup after loading the view.
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentObject = objectToDisplay{
            if let textToDisplay = currentObject.objectForKey("text") as AnyObject as? String{
                postText.text = textToDisplay
            }
        }
        //                    if let newText = objectToDisplay.objectForKey("text") as AnyObject as? String{
        //                        //                    objectForKey("text") as? AnyObject as? String{
        //                        println("worked")
        ////                        fullPostView.postText.text = newText
        //                        fullPostView.toDisplay = newText
        //                    }

//        if let currentPostText = toDisplay{
//           postText.text = toDisplay
//            
//        }
//        var label = UILabel()
//        label.text = postText
//        // WTF WHY IS NONE OF THIS WORKINGGG
//        self.view.addSubview(label)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
