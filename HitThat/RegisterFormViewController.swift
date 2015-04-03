//
//  RegisterFormViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/2/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterFormViewController: FXFormViewController {
    override func awakeFromNib() {
        super.awakeFromNib()
        formController.form = RegisterForm()
    }
    
    func submitRegistrationForm(cell: FXFormFieldCellProtocol){
        let form = cell.field.form as RegisterForm
        if let newAlias = form.alias{
            if let profilePhoto = form.profilePhoto{
                let photoFile = PFFile(data: UIImagePNGRepresentation(profilePhoto))
                PFUser.currentUser()["profilePhoto"] = photoFile
                PFUser.currentUser().saveInBackground()

            }
            else{
                PFUser.currentUser()["profilePhoto"] = PFUser.currentUser()["profilePicture"]
                PFUser.currentUser().saveInBackground()
            }
            
            if let userHeight = form.height{
                if let userWeight = form.weight{
                    if let bestMove = form.bestMove{
                        if let hitsWith = form.hitsWith{
                            if let fightingSince = form.fightingSince{
                                if let interests = form.interests{
                                    if let bio = form.bio{
                                        PFUser.currentUser()["bio"] = bio
                                        PFUser.currentUser()["interests"] = interests
                                        PFUser.currentUser()["wins"] = form.wins
                                        PFUser.currentUser()["jailtime"] = form.wins
                                        PFUser.currentUser()["fightingSince"] = fightingSince
                                        PFUser.currentUser()["hitsWith"] = hitsWith
                                        PFUser.currentUser()["alias"] = newAlias
                                        PFUser.currentUser()["height"] = userHeight
                                        PFUser.currentUser()["weight"] = userWeight
                                        PFUser.currentUser()["bestMove"] = bestMove
                                        switch form.bodyType{
                                        case 0:
                                            PFUser.currentUser()["bodyType"] = "Normal"
                                        case 1:
                                            PFUser.currentUser()["bodyType"] = "Butch"
                                        case 2:
                                            PFUser.currentUser()["bodyType"] = "Swole"
                                        default:
                                            PFUser.currentUser()["bodyType"] = "Slim"
                                        }
                                        PFUser.currentUser().saveInBackground()
                                        self.performSegueWithIdentifier("goHome", sender: self)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        formIncomplete("Please fill out all fields")
    }
    func formIncomplete(message:String){
        UIAlertView(title: "Incomplete Profile", message: message, delegate: nil, cancelButtonTitle: "ok").show()
    }
}
