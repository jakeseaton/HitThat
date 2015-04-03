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
        println("yay")
        UIAlertView(title: "Form Submitted", message: "Yay", delegate: nil, cancelButtonTitle: "ok").show()
        println(form.alias)
        println(form.fightingSince)
    }
}
