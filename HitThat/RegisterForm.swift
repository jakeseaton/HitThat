//
//  RegisterForm.swift
//  HitThat
//
//  Created by Jake Seaton on 4/2/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterForm: NSObject, FXForm {
    // get rid of interests
    // add age
    // add more to
    var alias: String?
    var height:String?
    var weight:String?
    var age: String?
    var reach:String?
    var profilePhoto: UIImage?
    var bio: String?
    var bestMove:String?
    var hitsWith:String?
    var bodyType:String?
    var jailTime = 0
    var tatoos = 0
    var gpa:String?
    var lookingFor:String?
    
    func fields() -> [AnyObject]! {
        return Constants().formFields(true)
    }


}
