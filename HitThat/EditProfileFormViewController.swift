//
//  EditProfileFormViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class EditProfileFormViewController: FXFormViewController {
    var formComplete = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formController.form = EditProfileForm()
    }
    func cancelSubmission(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func submitRegistrationForm(cell: FXFormFieldCellProtocol){
        let form = cell.field.form as EditProfileForm
        if let profilePhoto = form.profilePhoto{
            println("this worked")
            let photoFile = PFFile(data: UIImagePNGRepresentation(profilePhoto))
            PFUser.currentUser().setObject(photoFile, forKey:"profilePhoto")
            PFUser.currentUser().saveInBackground()
        }
//        else{
//            PFUser.currentUser().setObject(PFUser.currentUser()["profilePicture"], forKey:"profilePhoto")
//        }
        if let formData = FormValidator().validateEditForm(form){
            PFUser.currentUser().setValuesForKeysWithDictionary(formData)
            PFUser.currentUser().saveInBackground()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            formIncomplete("Please fill out all fields")
        }

    }
    func formIncomplete(message:String){
        UIAlertView(title: "Incomplete Profile", message: message, delegate: nil, cancelButtonTitle: "ok").show()
    }


}
