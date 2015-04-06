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
    var reach:String?
    func fields() -> [AnyObject]! {
        // get user profile picture
        // get user gender
        
        return [
            [FXFormFieldKey: "alias", FXFormFieldHeader: "Fighter Alias",
                "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            "profilePhoto",
            [FXFormFieldKey: "bio", FXFormFieldType: FXFormFieldTypeLongText],
            [FXFormFieldKey: "height", "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            [FXFormFieldKey: "weight", "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            [FXFormFieldKey: "reach", "textField.autocapitalizationType":UITextAutocapitalizationType.Words.rawValue],
            
            //            [FXFormFieldKey: "bestMove", FXFormFieldHeader:"Fighter Details", FXFormFieldType: FXFormFieldTypeLongText],
            [FXFormFieldKey: "bestMove",
                FXFormFieldOptions: ["Punch", "Jab", "Upper Cut", "Roundhouse", "Chop", "Body Slam", "Play Dead","Use the Force"],
                FXFormFieldHeader:"Fighter Details",
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            //this is a multiple choice field, so we'll need to provide some options
            //because this is an enum property, the indexes of the options should match enum values
            
            //another regular field
            
            // "fightingSince",
            
            //we want to use a stepper control for this value, so let's specify that
            
            [FXFormFieldKey: "jailTime", FXFormFieldCell: FXFormStepperCell.self],
            
            
            //this is an options field that uses a FXFormOptionPickerCell to display the available
            //options in a UIPickerView
            
            [FXFormFieldKey: "hitsWith",
                FXFormFieldOptions: ["Right Hand", "Left Hand", "Head", "Foot", "Bat", "Purse","Hatchet","Car", "Motorcycle", "Taxes", "Cat", "Mid Life Crisis", "Good Touch", "Bad Touch", "Anchor", "Hard Rock", "Soft Jazz"],
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            
            //this is a multi-select options field - FXForms knows this because the
            //class of the field property is a collection (in this case, NSArray)
            
            [FXFormFieldHeader: "Body Type",
                FXFormFieldKey: "bodyType",
                FXFormFieldTitle: "",
                FXFormFieldPlaceholder: "Slim",
                FXFormFieldOptions: ["Normal", "Butch", "Swole"],
                FXFormFieldCell: FXFormOptionSegmentsCell.self],
            
            [FXFormFieldTitle:"Cancel", FXFormFieldHeader:"", FXFormFieldAction:"cancelSubmission"],
            [FXFormFieldTitle: "Update Profile", FXFormFieldAction: "submitRegistrationForm:"],
            
        ]
    }
   
}
