//
//  SnatchLocationAPI.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//struct SnatchLocationAPI{
//    static var currLocation:PFGeoPoint?{
//        var answer:PFGeoPoint? = nil
//        PFGeoPoint.geoPointForCurrentLocationInBackground(){
//            (geoPoint, error) in
//            println("User is currently at \(geoPoint.latitude) and \(geoPoint.longitude)")
//            answer = geoPoint
//        }
//        return answer
//    }
//}
//}
//class SnatchLocationAPI:NSObject, CLLocationManagerDelegate {
////    let locationManager = CLLocationManager()
//    let locationManager:CLLocationManager = CLLocationManager()
//    var currLocation:CLLocationCoordinate2D?
//
//
//    override init(){
//        super.init()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println("didFailWithError: \(error)")
//    }
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        locationManager.stopUpdatingLocation()
//        println("this was called")
//        if (locations.count>0){
//            let location = locations[0] as CLLocation
//            currLocation = location.coordinate
//        }
//        
//    }
//    private func alert(){
//        let alert = UIAlertController(title: "Cannot fetch your location", message: "Please enable location in the settings menu", preferredStyle: UIAlertControllerStyle.Alert)
//        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) -> Void in
//            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//            return
//        }
//        alert.addAction(settings)
//        alert.addAction(action)
////        self.presentViewController(alert, animated: true, completion: nil)
//    }
//}
