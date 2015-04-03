//
//  RegisterForm.swift
//  HitThat
//
//  Created by Jake Seaton on 4/2/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterForm: NSObject, FXForm {
    var alias: String?
    var height:String?
    var weight:String?
    var name: String?
    var age: UInt = 0
    var profilePhoto: UIImage?
    var interests: NSArray? //NOTE: [String] or [AnyObject] won't work
    var bio: String?
    var fightingSince:NSDate?
    var bestMove:String?
    var wins:UInt = 0
    var hitsWith:String?
    var bodyType = 0
    var jailTime = 0
    
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
            [FXFormFieldKey: "bestMove", FXFormFieldHeader:"Fighter Details", FXFormFieldType: FXFormFieldTypeLongText],
            
            //this is a multiple choice field, so we'll need to provide some options
            //because this is an enum property, the indexes of the options should match enum values
            
            //another regular field
            
            "fightingSince",
            
            //we want to use a stepper control for this value, so let's specify that
            
            [FXFormFieldKey: "wins", FXFormFieldCell: FXFormStepperCell.self],
            [FXFormFieldKey: "jailTime", FXFormFieldCell: FXFormStepperCell.self],
            
        
            //this is an options field that uses a FXFormOptionPickerCell to display the available
            //options in a UIPickerView
            
            [FXFormFieldKey: "hitsWith",
                FXFormFieldOptions: ["Right", "Left", "Head", "Foot", "Bat", "Car", "Taxes"],
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            
            //this is a multi-select options field - FXForms knows this because the
            //class of the field property is a collection (in this case, NSArray)
            
            [FXFormFieldKey: "interests", FXFormFieldPlaceholder: "None",
                FXFormFieldOptions: ["Videogames", "Animals", "Cooking"]],
            
            
            [FXFormFieldHeader: "Body Type",
                FXFormFieldKey: "bodyType",
                FXFormFieldTitle: "",
                FXFormFieldPlaceholder: "Slim",
                FXFormFieldOptions: ["Normal", "Butch", "Swole"],
                FXFormFieldCell: FXFormOptionSegmentsCell.self],
         
            
            [FXFormFieldTitle: "Start Hitting People", FXFormFieldHeader: "", FXFormFieldAction: "submitRegistrationForm:"],
        ]
    }


}
