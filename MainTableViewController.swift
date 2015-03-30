//
//  TableViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/14/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit
import Parse

class MainTableViewController: PFQueryTableViewController, CLLocationManagerDelegate {
    
    // start location manager
//    let sla = SnatchLocationAPI()
    
    let locationManager = CLLocationManager()
    var currLocation: CLLocationCoordinate2D?
    
//    var allPosts:[PFObject] = []{
//        didSet{
//            updateUI()
//        }
//    }
//    func updateUI(){
//        println("update UI was called")
//    }
    
    override init(style:UITableViewStyle, className aClassName:String!){
        super.init(style: style, className: aClassName)
        self.parseClassName = "Posts"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//
//    override init!(style:UITableViewStyle, className: String!){
//        super.init(style:style, className:className)
//    }
//    
//    required init(coder aDecoder: NSCoder){
//        super.init(coder: aDecoder)
//        self.parseClassName = "Posts"
//        self.textKey = "text"
//        self.pullToRefreshEnabled = true
//        self.objectsPerPage = 200
//    }
    
    private func alert(message:String){
        let alert = UIAlertController(title: "Oops, something went wrong", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        // the handler is the last argument, and we want to use a closure so we're going to put it outside the parenthesis
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default){(action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        let query = PFQuery(className: "Posts")
//        query.findObjectsInBackgroundWithBlock(){
//            (objects,error) in
//            if let results = objects as? [PFObject]{
//                self.allPosts = results
//            }
//        }
//        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        locationManager.desiredAccuracy = 1000
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // this is apparently causing the cells to lose all of their formatting...why?
        self.loadObjects()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("\(error.description)")
        alert("Cannot fetch your location")
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count>0){
            let location = locations[0] as CLLocation
            println(location.coordinate)
            currLocation = location.coordinate
            // update the user's location
        }else{
            alert("Cannot fetch your location")
        }
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> MainTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier) as MainTableViewCell
        cell.postText.text = object["text"] as? String
        return cell
    }
    override func queryForTable() -> PFQuery!{
        let query = PFQuery(className:"Posts")
        // uncomment this to disable the ability to see the current user's stuff
//        query.whereKey("origin", notEqualTo: PFUser.currentUser().username)
        query.orderByDescending("createdAt")
//        if self.objects.count == 0 {
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork
//        }
//        query.findObjectsInBackgroundWithBlock(){
//            object,error in
//            println("\(object)")
//        }
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
// uncomment to enforce location restrictions
//        if let queryLoc = currLocation{
//            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: queryLoc.latitude, longitude: queryLoc.longitude), withinMiles: 10)
//            query.limit = 200;
//        }
//        else{
//            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: 37.411822, longitude: -121.941125), withinMiles: 10)
//            query.limit = 200;
//            query.orderByDescending("createdAt")
//        }
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
//    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> MainTableViewCell! {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as MainTableViewCell
//        // sets the public property of that cell, which calls the didset. This means that we do not have to go in and set all of the values for it.
//        println("\(indexPath)")
//        //        if let curr = allSnatches[indexPath.row]{
//        //
//        //        }
//        cell.postText.text = allPosts[indexPath.row].objectForKey("text") as AnyObject as? String
//        return cell
//    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
//        postText = (tableView.cellForRowAtIndexPath(indexPath) as? PFTableViewCell)?.textLabel?.text!
//        println("Post Text:\(postText)")
        if let object:PFObject =  self.objectAtIndexPath(indexPath){
            if let sender:AnyObject? = object as AnyObject?{
                performSegueWithIdentifier(Constants.FullPostSegue, sender: sender)
            }
//            let postText:AnyObject = object["text"] as AnyObject{
//                println("that code was called")
//            }
//            //            var spvc:SinglePostViewController = SinglePostViewController(postToDisplay:object)
//            //            self.presentViewController(spvc, animated: true, completion: nil)
//        }
//        else {
//            println("goddamnit")
//        }
        
        //THIS ISN'T WORKING
       
        }
    }
    // IS THERE A BETTER FUCKING WAY OF DOING THIS
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.FullPostSegue {
            if let fullPostView = segue.destinationViewController as? SinglePostViewController{
                println("\(sender!)")
                if let objectToDisplay = sender as? PFObject{
                    fullPostView.objectToDisplay = objectToDisplay
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

}
