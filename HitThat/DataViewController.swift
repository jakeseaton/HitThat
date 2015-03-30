//
//  DataViewController.swift
//  derp
//
//  Created by Jake Seaton on 3/24/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: AnyObject?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let obj: AnyObject = dataObject {
//            self.dataLabel!.text = obj.description
//            self.dataLabel!.text = "herp derp"
        } else {
            self.dataLabel!.text = ""
        }
    }


}

