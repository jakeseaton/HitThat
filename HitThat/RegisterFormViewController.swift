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
        if let form = cell.field.form as? RegisterForm{
            if let formData = FormValidator().validateRegisterForm(form){
                if let profilePhoto = form.profilePhoto{
                    let photoFile = PFFile(data: UIImagePNGRepresentation(profilePhoto))
                    PFUser.currentUser().setObject(photoFile, forKey: "profilePhoto")
                }
                else{
                    PFUser.currentUser()["profilePhoto"] = PFUser.currentUser()["profilePicture"]
                }
                PFUser.currentUser().setValuesForKeysWithDictionary(formData)
                PFUser.currentUser().saveInBackground()
                self.performSegueWithIdentifier(Constants.RegistrationCompleteSegue, sender: nil)
            }
            else{
                UIAlertView(title: "Incomplete Profile", message: "Please fill out all fields", delegate: nil, cancelButtonTitle: "ok").show()
            }
        }
            
    }
}
