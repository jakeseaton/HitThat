//
//  FightsTableViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightsTableViewController: PFQueryTableViewController {
        override init(style:UITableViewStyle, className aClassName:String!){
            super.init(style: style, className: aClassName)
            self.parseClassName = "Fights"
            self.textKey = "recipient"
            self.pullToRefreshEnabled = true
            self.paginationEnabled = true
        }
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> FightsTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as FightsTableViewCell
        let fight:AnyObject = object.objectForKey("recipient") as AnyObject
        let userToFight = PFUser.query().getObjectWithId(fight.objectId) as PFUser
//        cell.userImage.image = ParseAPI().getAUsersProfilePicture(userToFight)
        cell.postText.text = userToFight["fullName"] as AnyObject as? String
//        let post:AnyObject = object.objectForKey("post") as AnyObject
//        let query = PFQuery(className: "Posts")
//        if let fullPost = query.getObjectWithId(post.objectId){
//            cell.postText.text = fullPost["text"] as AnyObject as? String//object.objectForKey("recipientName") as? String
//        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            Colors().gradient(self)
            self.tableView.backgroundColor = Colors.color1
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            
//            if let currentUserName = ParseAPI.currentUserName{
//                let query = PFQuery(className: "Fights")
//                println("current user name:\(currentUserName)")
//                query.whereKey("origin", equalTo: currentUserName)
//                query.findObjectsInBackgroundWithBlock(){
//                    (objects, error) in
//                    println("\(objects)")
//                }
//            }
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            
        }
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            // this is apparently causing the cells to lose all of their formatting...why?
//            self.loadObjects()
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        override func queryForTable() -> PFQuery!{
            let query = PFQuery(className:"Fights")
            
            //            PFGeoPoint.geoPointForCurrentLocationInBackground(){
            //                (geoPoint, error) in
            //                dispatch_async(dispatch_get_main_queue()){
            //                    if error != nil{
            //                        println("ERROR FETCHING USER LOCATION WITH PFGEOPOINT")
            //                        self.alert("Herp Derp")
            //                    }
            //                    else{
            //                        query.whereKey("location", nearGeoPoint:geoPoint, withinMiles:10)
            //                        query.limit = 200
            //                        query.orderByDescending("createdAt")
            //                    }
            //                }
            //
            //            }
            if let user = PFUser.currentUser(){
                query.whereKey("origin", equalTo: user)
            }
//            if let currentUserName = ParseAPI.currentUserName{
//                query.whereKey("origin", equalTo: currentUserName)
//                query.limit = 200;
//                query.orderByDescending("createdAt")
//            }
            return query
        }
        
        override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
            var obj:PFObject? = nil
            if (indexPath.row < self.objects.count){
                // cast it. We want this to crash if it doesn't work
                obj = self.objects[indexPath.row] as? PFObject
            }
            return obj
        }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        //        postText = (tableView.cellForRowAtIndexPath(indexPath) as? PFTableViewCell)?.textLabel?.text!
        //        println("Post Text:\(postText)")
        if let object:PFObject =  self.objectAtIndexPath(indexPath){
            let recipientUser: AnyObject = object["recipient"] as AnyObject
//            let recipientUserName = object.objectForKey("recipient") as AnyObject as String
            let target = PFUser.query().getObjectWithId(recipientUser.objectId)
            self.performSegueWithIdentifier(Constants.ShowFightDetailsSegue, sender: target)
//            let query = PFUser.query()
//            query.whereKey("username", equalTo: recipientUserName)
//            query.getFirstObjectInBackgroundWithBlock(){
//                (target, error) in
//                if error != nil{
//                    println(error)
//                }
//                else{
//                    self.performSegueWithIdentifier(Constants.ShowFightDetailsSegue, sender: target as AnyObject)
//                }
//            }
        }
    }
    // IS THERE A BETTER FUCKING WAY OF DOING THIS
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowFightDetailsSegue {
            if let profileView = segue.destinationViewController as? GenericProfileViewController{
                //                println("\(sender!)")
                if let objectToDisplay = sender as? PFUser{
                    profileView.userToDisplay = objectToDisplay
                    //                    if let newText = objectToDisplay.objectForKey("text") as AnyObject as? String{
                    //                        //                    objectForKey("text") as? AnyObject as? String{
                    //                        println("worked")
                    ////                        fullPostView.postText.text = newText
                    //                        fullPostView.toDisplay = newText
                    //                    }
                }
                
                
                //                if let newText? = sender["text"] as? AnyObject as? String {
                ////                    println("\(newText)")
                ////                    println("\(fullPostView)")
                ////                    println("\(fullPostView.postText)")
                ////                    println("\(fullPostView.postText.text)")
                //
                //                    fullPostView.toDisplay = newText!
                //                }
                
            }
            
            
        }
    }

        
        // MARK: - Table view data source
        /*
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
        }
        
        // returns a pfTableViewCell
        override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell
        {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        cell.postText.text = object.valueForKey("text") as? String
        cell.postText.numberOfLines = 0
        //        let score = object.valueForKey("count") as Int
        //        cell.count.text = "\(score)"
        cell.time.text = "\((indexPath.row + 1) * 3)m ago"
        //        cell.replies.text = "\((indexPath.row+1)*1) replies"
        return cell
        }
        */
        // INSERT OUTLETS FOR BUTTONS ON THE TABLE HERE
        /*
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        return cell
        }
        */
        
        /*
        // Override to support conditional editing of the table view.
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
        }
        */
        
        /*
        // Override to support editing the table view.
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        }
        */
        
        /*
        // Override to support rearranging the table view.
        override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        }
        */
        
        /*
        // Override to support conditional rearranging of the table view.
        override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
        }
        */
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        }
        */

}
