//
//  Constants.swift
//  snatch
//
//  Created by Jake Seaton on 3/20/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct Constants{
    // Unused
    static let BlockSize = CGSize(width: 40, height: 40)

    // Segues
    static let LogInSegue = "Log In Segue"
    static let ShowProfileSegue = "Show Profile Segue"
    static let RegistrationCompleteSegue = "Registration Complete"
    static let ReturnFromFightToVersus = "Return To Versus"
    static let FightStartedSegue = "Fight Started Segue"
    static let ViewProfileSegue = "View Profile Segue"
    
    // Identifiers
    
    // Images
   
    //static let CreatedAt = "createdAt"
    static let SelectedCell = "Selected Cell"
    static let FullPostSegue = "Full Post Segue"
    static let HomeSelectedImage = "homeFilled"
    static let UserSelectedImage = "userMaleFilled"
    static let FightsSelectedImage = "clenchedFistFilled"
    static let SnatchesSelectedImage = "heartsFilled"
    static let MatchSegue = "Match Segue"
    static let SnatchedSegue = "Snatch Segue"
    static let FightSegue = "Fight Segue"
    static let ShowSnatchDetailsSegue = "Show Snatch Details"
    static let CellReuseIdentifier = "Cell Reuse Identifier"
    static let LocateSegueIndentifier = "Locate Segue"
    static let AnnotationViewReuseIdentifier = "Annotation View Reuse Identifier"
    static let ShowFightDetailsSegue = "Show Fight Details"
    static let ReigsterUserSegue = "Register New User"
    static let GenericProfileSegue = "Generic Profile Segue"
    static let KeepPlayingSegue = "Keep Playing Segue"
    static let NoUserSegue = "No User"
    static let NewUserSegue = "New User"
    static let RegisterFormSegue = "Register Form Segue"
    static let CenterViewControllerIdentifier = "Versus View Controller"
    static let RightViewControllerIdentifier = "Fights View Controller"
    static let LeftViewControllerIdentifier = "Menu View Controller"
    static let MenuCellRestorationIdentifier = "MenuCell"
    static let OpenFightSegue = "Open Fight"
    static let PunchSoundFilenName = "punch"
    static let StartFightSegue = "Start Fight Segue"
    static let UnwindFromNewFight = "Unwind From New Fight"
    
    // Versus Screen
    // removed fights
    // removed alias
    static let categories = ["gender", "bodyType", "height", "weight", "reach", "wins", "jailTime", "gpa", "tatoos"]
    static let comparables = ["height", "weight", "reach", "wins", "jailTime", "gpa", "tatoos"]
    
    // Menu
    static let menuItems = ["Home", "My Profile", "My Fights", "Settings", "About", "Log In", "Reset"]
    static let menuIcons = ["homeFilled", "userMaleFilled", "myFightsIcon", "settingsIcon", "aboutIcon", "fist", "fist"]
    
    func refreshFightsTable(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.refreshTable()
    }
    func updateMenu(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.updateMenu()
    }
    
    // Form Options
    static let hitsWithOptions = ["Right Hand", "Left Hand", "Head", "Foot", "Bat", "Purse","Hatchet","Car", "Motorcycle", "Taxes", "Cat", "Mid Life Crisis", "Good Touch", "Bad Touch", "Anchor", "Hard Rock", "Soft Jazz"]
    static let lookingForOptions = ["Love", "Fights", "Love and Fights"]
    static let bestMoveOptions = ["Punch", "Jab", "Upper Cut", "Roundhouse", "Chop", "Body Slam", "Play Dead","Use the Force"]
    static let bodyTypeOptions = ["Slim", "Normal","Athletic", "Butch", "Toned", "Swole", "Stringy", "Stocky", "Skinny", "Fat"]
    var GPAOptions:[String]{
        var results:[String] = []
        for i in 0...3{
            for j in 0...9{
                let str = "\(i).\(j)"
                results.append(str)
            }
        }
        results.append("4.0")
        return results
    }
    var heightOptions:[String] {
        var results:[String] = []
        for i in 4...6{
            for j in 0...11{
               results.append("\(i)' \(j)")
            }
        }
        return results
    }
    var weightOptions:[String]{
        var results:[String] = []
        for i in 100...300{
            results.append("\(i)")
        }
        return results
    }
    var reachOptions:[String]{
        var results:[String] = []
        for i in 0...4{
            for j in 0...11{
                results.append("\(i)' \(j)")
            }
        }
        return results
    }
    var ageOptions:[String] {
        var results:[String] = []
        for i in 18...110{
            results.append("\(i)")
        }
        return results
    }
    

    func formFields(registering:Bool) -> [AnyObject]!{
        
        var results:[AnyObject]! =  [
            [FXFormFieldKey: "alias", FXFormFieldHeader: "Fighter Alias",
                "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            "profilePhoto",
            
            [FXFormFieldKey: "bio", FXFormFieldType: FXFormFieldTypeLongText],
            [FXFormFieldKey: "age",
                FXFormFieldOptions: ageOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            [FXFormFieldKey: "height",
                FXFormFieldOptions: heightOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            //[FXFormFieldKey: "height", "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            [FXFormFieldKey: "weight",
                FXFormFieldOptions: weightOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            //[FXFormFieldKey: "weight", "textField.autocapitalizationType": UITextAutocapitalizationType.Words.rawValue],
            [FXFormFieldKey: "reach",
                FXFormFieldOptions: reachOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            //[FXFormFieldKey: "reach", "textField.autocapitalizationType":UITextAutocapitalizationType.Words.rawValue],
            
            //            [FXFormFieldKey: "bestMove", FXFormFieldHeader:"Fighter Details", FXFormFieldType: FXFormFieldTypeLongText],
            [FXFormFieldKey: "bestMove",
                FXFormFieldOptions: Constants.bestMoveOptions,
                FXFormFieldHeader:"Fighter Details",
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            //this is a multiple choice field, so we'll need to provide some options
            //because this is an enum property, the indexes of the options should match enum values
            
            //another regular field
            
            // "fightingSince",
            
            //we want to use a stepper control for this value, so let's specify that
            
            [FXFormFieldKey: "jailTime", FXFormFieldCell: FXFormStepperCell.self],
            [FXFormFieldKey: "tatoos", FXFormFieldCell: FXFormStepperCell.self],

            [FXFormFieldKey: "gpa",
                FXFormFieldOptions: GPAOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            
            
            //this is an options field that uses a FXFormOptionPickerCell to display the available
            //options in a UIPickerView
            
            [FXFormFieldKey: "hitsWith",
                FXFormFieldOptions: Constants.hitsWithOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            [FXFormFieldKey: "lookingFor",
                FXFormFieldOptions: Constants.lookingForOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            [FXFormFieldKey: "bodyType",
                FXFormFieldOptions: Constants.bodyTypeOptions,
                FXFormFieldPlaceholder: "N/A",
                FXFormFieldCell: FXFormOptionPickerCell.self],
            
            [FXFormFieldTitle: "Update Profile", FXFormFieldAction: "submitRegistrationForm:"],
            
        ]
        if (!registering) {
            results.append([FXFormFieldTitle:"Cancel", FXFormFieldHeader:"", FXFormFieldAction:"cancelSubmission"])
        }
        return results

    }
}
