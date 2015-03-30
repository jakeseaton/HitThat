//
//  PostViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/15/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {
    // outlet for the text
    @IBOutlet weak var postView: UITextView!
//    let currentUser = PFUser.currentUser()

//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//    if (!error) {
//    NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
//    
//    [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
//    [[PFUser currentUser] saveInBackground];
//    }
//    }];

//        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//            if (!error) {
//            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
//            
//            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
//            [[PFUser currentUser] saveInBackground];
//            }
//            }];
    var reset:Bool = false
    
    private func alert(){
        let alert = UIAlertController(title: "Cannot fetch your location", message: "Please enable location in the settings menu", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // cancel
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // post
    @IBAction func postPressed(sender: AnyObject) {
        // if we can get the current location
        
        // get rid of the keyboard
        
        self.postView.resignFirstResponder()
        println("this was pressed")

        PFGeoPoint.geoPointForCurrentLocationInBackground(){
            (geoPoint, error) in
                if error != nil{
                    println("ERROR FETCHING USER LOCATION WITH PFGEOPOINT")
                    self.alert()
                }
                else{
                    println("this was called")
                    let object = PFObject(className:"Posts")
                    PFUser.currentUser().setObject(geoPoint, forKey: "location")
                    PFUser.currentUser().saveInBackground()
                    object["origin"] = SnatchParseAPI.currentUserName
                    object["text"] = self.postView.text
                    object["beatUps"] = 0
                    object["snatchUps"] = 0
                    object["location"] = geoPoint
                    object.saveInBackground()
                    // memory cycle?
                    self.dismissViewControllerAnimated(true, completion: nil)

                }
        }

        
//        if let location = currLocation {
//            let object = PFObject(className: "Posts")
//            // somehow get the user, so as to associate them with the posts!
//            object["text"] = self.postView.text
//            object["beatUps"] = 0
//            object["snatchUps"] = 0
//            object["location"] = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
//            object.saveInBackground()
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//        }
//        else{
//            println("Could not get a location")
//            alert()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.selectedRange = NSMakeRange(0, 0);
        self.postView.delegate = self
        self.postView.becomeFirstResponder()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        locationManager.stopUpdatingLocation()
//        if(locations.count>0){
//            let location = locations[0] as CLLocation
//            
////            spa.updateUserLocation(location)
//            // update the location in the parse database
//            currLocation = location.coordinate
////            if let currentUserName = SnatchParseAPI.currentUserName{
////                var object = PFObject(className: "Locations")
////                object["username"] = currentUserName
////                object["location"] = PFGeoPoint(latitude: currLocation!.latitude, longitude: currLocation!.longitude)
////                object.saveInBackground()
////                println("stored location")
////            }
//        } else{
//            alert()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
//        println(error)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        if (reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }
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
