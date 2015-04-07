//
//  FightsViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sectionTitles = ["Origin", "Recpient"]
    @IBOutlet weak var tv: UITableView!
    var originFights:[PFObject] = []{
        didSet{
            tv.reloadData()
        }
    }
    var recipientFights:[PFObject] = []{
        didSet{
            tv.reloadData()
        }
    }
    
    func refresh(){
        if (PFUser.currentUser() != nil){
            let queryOrigin = PFQuery(className: "Fights")
            queryOrigin.whereKey("origin", equalTo: PFUser.currentUser())
            queryOrigin.orderByDescending("updatedAt")
            queryOrigin.findObjectsInBackgroundWithBlock(){
                (objects, error) in
                self.originFights = objects as [PFObject]
            }
            let queryRecipient = PFQuery(className: "Fights")
            queryRecipient.whereKey("recipient", equalTo: PFUser.currentUser())
            queryRecipient.orderByDescending("updatedAt")
            queryRecipient.findObjectsInBackgroundWithBlock(){
                (objects, error) in
                self.recipientFights = objects as [PFObject]
            }
        }
    }
    
    func updateUI(){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("FightCellOrigin", forIndexPath: indexPath) as FightCellOrigin
            let fightObject = self.originFights[indexPath.row]
            cell.nameLabel.text = fightObject.objectId
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("FightCellRecipient", forIndexPath: indexPath) as FightCellRecipient
            let fightObject = self.recipientFights[indexPath.row]
            cell.nameLabel.text = fightObject.objectId
            return cell
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let answer = (section == 0) ? self.originFights.count : self.recipientFights.count
        return answer
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath \(indexPath.row) \(indexPath.section)")
        let arr = (indexPath.section == 0) ? self.originFights : self.recipientFights
        println(arr)
        if (indexPath.section == 0){
            let fightObject = self.originFights[indexPath.row]
            self.performSegueWithIdentifier(Constants.OpenFightSegue, sender: fightObject)
        }
        else{
            let fightObject = self.recipientFights[indexPath.row]
            self.performSegueWithIdentifier(Constants.OpenFightSegue, sender: fightObject)
            
        }
//        let fightObject = arr[indexPath.row]
//        self.performSegueWithIdentifier(Constants.OpenFightSegue, sender: fightObject)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Prepared for segue with arguments \(sender)")
        if segue.identifier == Constants.OpenFightSegue{
            if let fovc = segue.destinationViewController as? FightOpenViewController{
                if let fight = sender as? PFObject{
                    println("fight: \(fight)")
                    fovc.fightToDisplay = fight
                }
            }
        }
    }
}
