//
//  TableViewCell.swift
//  snatch
//
//  Created by Jake Seaton on 3/14/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class MainTableViewCell: PFTableViewCell{


    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var postText: UILabel!
    // outlet post text
    // outlet time
    // outlet for whether or not it's been seen
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // do the segue here
        // Configure the view for the selected state
    }

}

//Notes from Hegarty
//
//Connecting code to the Table view
//Tables have a delegate and a datasource. 
//Automatically wire up the table and the delegate as the datasource
//This is what you want 99% of the time
//
//Can edit the attributes of the tableview
//ctrl shift click allows you select what is under the mouse
//
//delegate controls how it looks
//datasource controls the data that is displayed inside the cells
//
//datasource protocols
//    1. How many sections
//    2. How many rows in a section
//    3. Give me a view to draw each cell at a given row in a given section
//3. is with the method cellForRowAtIndexPath
//
//be careful with multithreadedness
//
//cell for row at index path
//let data = internalDataStructure[indexPath.section][indexPath.row]
//
//numberofSectionsinTable is default 1
