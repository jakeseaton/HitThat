//
//  ProfileViewController.swift
//  snatch
//
//  Created by Jake Seaton on 3/19/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    //Most of the things for this will have to be done using code, to pass the clicked thing in to here so that we can render that user's profile
    // from the user that we are viewing
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        fullName.text = SnatchParseAPI.currentUserFullName
        if let curr = PFUser.currentUser(){
            println("got the current user")
            ratioLabel.text = "Ratio:0:0"
            if let img = curr["profilePicture"] as AnyObject as? PFFile {
                println("got their profile picture from the object")
                img.getDataInBackgroundWithBlock {
                    (imageData, error) -> Void in
                    println("fired the block in the background")
                        if error != nil {
                            println("ERROR RETRIEVING IMAGE")
                        }
                        else{
                            print("set profile picture image")
                            self.profilePicture.image = UIImage(data:imageData)
                    }
                }
            }
            else{
                println("this didn't work")
            }
        }
//        FBRequestConnection.startWithGraphPath("/me"){
//            (connection, result, error) in
//            if error != nil{
//                println("THERE WAS AN ERROR")
//            }else{
//                self.fullName.text = result.name
//                if let derp:String = SnatchParseAPI.currentUserFullName{
//                      println("\(derp)")
//                }
//            }
//        }
        
        
//        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:facebookId]]];
//        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
//        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
    }
    
//    let userSnatches = SnatchParseAPI.currentUserSnatches
//    let userFights = SnatchParseAPI.currentUserFights
    
// CODE FOR PARALLAX IMAGE THING at http://www.thoughtfaqtory.com/scale-background-image-while-scrolling-uiscrollview/
    
    
}

//class ProfileView:UIView {
//    
//}