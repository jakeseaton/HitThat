//
//  MapViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit
import MapKit

//struct

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // can find out user location with
    // showsUserLocation
    // isUserLocationVisible
    //userLocation: MKUserLocation (MKAnnotation)
    // lots of ways to convert between points
    // MKRoute gets directions
    // MKPolyline draws directions
    // That's all asyncrhonous
    // func addOverlay
    // mapview renderforOverlay
    // MKShape, MKPolyline, then user their renderers
    
    // public API--set a user, and will show you where they are
    var userToLocate: PFUser?{
        didSet{
//            clearAnnotations()
            if let curr = userToLocate{
//                handleAnnotations([curr])
                let API = SnatchParseAPI()
                API.notifyTrackedUser(curr)
            }
        }
    }
    //    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.setUserTrackingMode(.FollowWithHeading, animated: true)
            mapView.showsUserLocation = true
            mapView.pitchEnabled = true
            mapView.scrollEnabled = true
            mapView.zoomEnabled = true
            mapView.rotateEnabled = false
            mapView.mapType = .Standard
            // or .Hybrid, etc
            mapView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let curr = userToLocate{
            handleAnnotations([curr])
        }
//        let currentUserWantsToFight = SnatchParseAPI.currentUserWantsToFight
//        let currentUserWantsToSnatch = SnatchParseAPI.currentUserWantsToSnatch
//        println("\(SnatchLocationAPI.currLocation)")
    }
    
    // Set all of them as waypoints
//    private func clearAnnotations(){
//        if mapView?.annotations != nil{
//            mapView.removeAnnotation(mapView.annotations as [MKAnnotation])
//        }
//    }
    private func handleAnnotations(usersToAnnontate:[PFUser]){
//        if let location =
//        println("in handle annotations, the argument was \(userToAnnontate)")
        let annotations = usersToAnnontate as [MKAnnotation]
//        println("annotation coordinate: \(annotation.coordinate)")
        mapView?.addAnnotations(annotations)
        mapView?.showAnnotations(annotations, animated: true)
        drawRouteToAnnotation(annotations[0])
//        mapView.showAnnotations([userToAnnontate], animated: true)
    }
    private func drawRouteToAnnotation(annotation: MKAnnotation){
//        let c1 = annotation.coordinate
//        let c2 = mapView.userLocation.coordinate
//        let coordinates = [c1, c2]
        
        let destinationPlacemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destinationMapItem)
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler(){
            (response,error) in
            
            if error != nil {
                println(error)
            } else {
                self.showRoute(response)
            }
        }
    }
    private func showRoute(response: MKDirectionsResponse){
        for route in response.routes as [MKRoute] {
            println(route)
//            self.mapView.region = route.polyline.boundingMapRect

            self.mapView.addOverlay(route.polyline,
                level: .AboveRoads)
        }
    }
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = Colors.color1
            renderer.lineWidth = 5.0
            return renderer
    }
    private func clearAnnotations(){
        if mapView?.annotations != nil{
            mapView.removeAnnotations(mapView.annotations as [MKAnnotation])
        }
    }
    
    // this simple, as long as the array here is an array of MKAnnotations. Need to use an extension to
//    private func handleWaypoints(waypoints: [GPX.Waypoint]){
//        mapView.addAnnotation(waypoints)
//        mapView.showAnnotations(waypoints, animated: true)
////    }
////    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        // capital letters for constants
//        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
//        if view == nil {
//            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
//            // change this to AnnotationView?
//            view.canShowCallout = true
//        }else{
//            view.annotation = annotation
//        }
//        view.rightCalloutAccessoryView = nil
//        view.leftCalloutAccessoryView = nil
//        // this is where we do the UI for the pins
//        if let waypoint = annotation as? GPX.Waypoint{
//            if waypoint.thumbnailURL != nil {
//                view.leftCalloutAccessoryView = UIImageView(frame:Constants.LeftCalloutFrame)
//            }else{
//                
//            }
//            if waypoint.imageUrl != nil{
//                // UIButton button with type returns anyobject lol
//                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButton.DetailDisclosure) as UIButton
//                
//            }
//        }
//    }
//    // THIS CODE IS SUPER IMPORTANT
//    // callout Accessory control is the little i in a circle
//    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//        
//        // need to segue
//        // this is how you will have to do the tweets thing. Have a strict that has the name of the segue, and then pass the image through it to the new view
//        performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == Constants.ShowImageSegue{
//            if let waypoint = (sender as? MKAnnotationView)?.annotation as? GPX.Waypoint {
//                if let ivc = segue.destinationViewController as? ImageViewController{
//                    // pass the info to the next view controller
//                    ivc.imageURL = waypoint.imageURL
//                }
//            }
//        }
//    }
//     THIS IS HOW YOU TELL WHEN WE HAVE SELECTED AN ANNOTATION
//    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
//        // this is where you set the image
//        if let waypoint = view.annotation as? GPX.Waypoint{
//            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView{
//                if let imageData = NSData(contentsOfURL: waypoint.thumbnailURL!){
//                    if let image = UIImage(data:imageData){
//                        thumbnailImageView.image = image
//                    }
//                }
//            }
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let center = NSNotificationCenter.defaultCenter()
//        let queue = NSOperationQueue.mainQueue()
//        // gets the delegate
//        let appDelegate = UIApplication.sharedApplication().delegate
//        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue){ notification in
//            if let url = notification?.userInfo?[GPXURL.Key] as? NSURL{
//                self.gpxURL = url
//                //                self.textView.text = "Received \(url)"
//                // parse and put waypoints on the map
//                
//            }
//            
//        }
//        
//    }
    
}

