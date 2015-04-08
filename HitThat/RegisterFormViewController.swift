//
//  RegisterFormViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/2/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class RegisterFormViewController: FXFormViewController {
    var formComplete = false
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
                                if let interests = form.interests{
                                    if let reach = form.reach{
                                        if let bio = form.bio{
                                            if let lookingFor = form.lookingFor{
                                                formComplete = true
                                                PFUser.currentUser()["reach"] = reach
                                                PFUser.currentUser()["bio"] = bio
                                                PFUser.currentUser()["lookingFor"] = lookingFor
                                                PFUser.currentUser()["interests"] = interests
                                                PFUser.currentUser()["tatoos"] = form.tatoos
                                                PFUser.currentUser()["gpa"] = form.gpa
                                                PFUser.currentUser()["jailTime"] = form.jailTime
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
        }
        if (formComplete == false) {
            formIncomplete("Please fill out all fields")
        }
    }
    func formIncomplete(message:String){
        UIAlertView(title: "Incomplete Profile", message: message, delegate: nil, cancelButtonTitle: "ok").show()
    }
}
