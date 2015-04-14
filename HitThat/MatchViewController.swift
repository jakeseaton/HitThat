//
//  MatchViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/21/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit
import MapKit

class MatchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var userToDisplay:PFUser?
    var fightToDisplay:PFObject?
    var targetLockedSound:AVAudioPlayer?
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var lockedOnLabel: UILabel!
    @IBOutlet weak var bioLabel:UILabel!
    @IBOutlet weak var bestMoveLabel:UILabel!
    @IBOutlet weak var lookingForLabel:UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    //@IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    //@IBOutlet weak var userFullName: UILabel!
    // need outlets for the table of posts, the picture, etc
    @IBAction func keepPlayingPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(Constants.KeepPlayingSegue, sender: self)
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.setUserTrackingMode(.FollowWithHeading, animated: true)
            mapView.showsUserLocation = true
            // mapView.pitchEnabled = true
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
        self.lockedOnLabel?.hidden = true
        Colors().favoriteBackGroundColor(self)
        Shapes().circularImage(self.profilePicture)
        targetLockedSound = SoundAPI().getTargetLockedSound()
        //Shapes().circularImage(self.userProfilePicture)
        if let userObject = userToDisplay{
            fullName.text = ParseAPI().stringOfUnwrappedUserProperty("fullName", user: userObject)
            ParseAPI().installAUsersProfilePicture(userObject, target: self.profilePicture)
            self.bioLabel.text = "Bio: " + ParseAPI().stringOfUnwrappedUserProperty("bio", user: userObject)
            self.distanceLabel.text = "Distance: " + ParseAPI().distanceToUser(userToDisplay!).description + "mi"
            self.bestMoveLabel.text = "Best Move: " + ParseAPI().stringOfUnwrappedUserProperty("bestMove", user: userObject)
            self.navigationItem.title = ParseAPI().stringOfUnwrappedUserProperty("alias" , user:userObject)
            self.lookingForLabel.text = "Looking For: " + ParseAPI().stringOfUnwrappedUserProperty("lookingFor", user: userObject)
        }
//        if let currentUser = PFUser.currentUser(){
//           ParseAPI().installAUsersProfilePicture(currentUser, target: self.userProfilePicture)
//            userFullName.text = ParseAPI().stringOfCurrentUserProperty("fullName")
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func locatePressed(sender: AnyObject) {
        println(userToDisplay)
        handleAnnotations([userToDisplay!])
        ParseAPI().notifyTrackedUser(userToDisplay!)
        self.targetLockedSound?.play()
        self.lockedOnLabel?.hidden = false
        //performSegueWithIdentifier(Constants.LocateSegueIndentifier, sender: userToDisplay)
    }
    @IBAction func startFightPressed(sender: AnyObject) {
        if let newFight = fightToDisplay{
            self.performSegueWithIdentifier(Constants.StartFightSegue, sender: fightToDisplay!)
        }
        else{
            if let newFight = ParseAPI().storeAFightFromVersusScreen(userToDisplay!){
                self.performSegueWithIdentifier(Constants.StartFightSegue, sender: newFight)
            }
                    // construct a fight object
            //self.performSegueWithIdentifier(Constants.StartFightSegue, sender: newFight)
        }

        //self.dismissViewControllerAnimated(true, completion: nil)
        //let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //appDelegate.displayFight(fightToDisplay!)
        //println("start fight pressed")
    }
//    @IBAction func gangBangPressed(sender: AnyObject) {
//        println("gangbanging: \(userToDisplay)")
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.LocateSegueIndentifier{
            if let locateViewController = segue.destinationViewController as? MapViewController{
                locateViewController.userToLocate = userToDisplay
            }
        }
        if segue.identifier == Constants.StartFightSegue{
            if let startFightViewController = segue.destinationViewController as? StartFightViewController{
                startFightViewController.fightToDisplay = sender as? PFObject
            }
        }
    }

    /*
    // MARK: -MAP View Delegation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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

}




