//
//  EditProfileForm.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class EditProfileForm: NSObject, FXForm {
    
    var alias: String?
    var height:String?
    var weight:String?
    var name: String?
    var age: UInt = 0
    var profilePhoto: UIImage?
    var interests: NSArray?
    var bio: String?
    var bestMove:String?
    var hitsWith:String?
    var bodyType = 0
    var jailTime = 0
    var tatoos = 0
    var gpa = 0
    var reach:String?
    var lookingFor:String?
    func fields() -> [AnyObject]! {
        // get user profile picture
        // get user gender
        return Constants().formFields(false)
    }
   
}
