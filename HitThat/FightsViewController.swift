//
//  FightsViewController.swift
//  HitThat
//
//  Created by Jake Seaton on 4/6/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import UIKit

class FightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sectionTitles = ["Fights", "Wins", "Losses"]
    @IBOutlet weak var tv: UITableView!
    
    var allFights:[PFObject] = []{
        didSet{
            tv.reloadData()
        }
    }
    var victories:[PFObject] = []{
        didSet{
            tv.reloadData()
        }
    }
    var losses:[PFObject] = []{
        didSet{
            tv.reloadData()
        }
    }
    func openFight(fightObject:PFObject){
        fightObject.fetchIfNeeded()
        self.performSegueWithIdentifier(Constants.OpenFightSegue, sender: fightObject)
    }
    func refresh(){
        if (PFUser.currentUser() != nil){
                let queryOrigin = ParseAPI().fightsQuery()
                let queryRecipient = ParseAPI().fightsQuery()
            
                queryOrigin.whereKey("origin", equalTo: PFUser.currentUser())
                queryOrigin.whereKey("originStamina", greaterThan: 0)
                queryOrigin.whereKey("recipientStamina", greaterThan: 0)
            
                queryRecipient.whereKey("recipient", equalTo: PFUser.currentUser())
                queryRecipient.whereKey("originStamina", greaterThan: 0)
                queryRecipient.whereKey("recipientStamina", greaterThan: 0)
                let queryFights = PFQuery.orQueryWithSubqueries([queryOrigin, queryRecipient])
                queryFights.orderByDescending("updatedAt")
                queryFights.findObjectsInBackgroundWithBlock(){
                    (objects, error) in
                    self.allFights = objects as [PFObject]
                }
                let queryWins = ParseAPI().winsQuery(PFUser.currentUser())
            queryWins.findObjectsInBackgroundWithBlock(){
                (objects, error) in
                self.victories = objects as [PFObject]
            }
            let queryLosses = ParseAPI().lossQuery(PFUser.currentUser())
            queryLosses.findObjectsInBackgroundWithBlock(){
              (objects,error) in
                self.losses = objects as [PFObject]
            }
        }
        }

    
    func updateUI(){}

    override func viewDidLoad() {
        super.viewDidLoad()
        Colors().gradient(self)
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
        switch indexPath.section{
            
        // wins
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("FightCellWin", forIndexPath: indexPath) as FightCellWin
            let winObject = self.victories[indexPath.row]
            cell.nameLabel.text = winObject["loserAlias"] as AnyObject as? String
            cell.selectionStyle = .None
            cell.nameLabel.textColor = Colors.userColor1
            return cell
            
        // losses
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("FightCellLoss", forIndexPath:indexPath) as FightCellLoss
            let lossObject = self.losses[indexPath.row]
            cell.selectionStyle = .None
            cell.nameLabel.text = lossObject["winnerAlias"] as AnyObject as? String
            cell.nameLabel.textColor = Colors.opponentColor1
            return cell
        // default--regular fight
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("FightCell", forIndexPath: indexPath) as FightCell
            let fightObject:PFObject = self.allFights[indexPath.row]
            // fix this
            if let lastTurn = fightObject["lastTurn"] as? PFUser{
                if lastTurn.objectId != PFUser.currentUser().objectId{
                    cell.nameLabel.textColor = UIColor.whiteColor()
                    cell.backgroundColor = Colors.favoriteBackgroundColor
                }
                else{
                    cell.nameLabel.textColor = Colors.favoriteBackgroundColor
                    cell.backgroundColor = UIColor.whiteColor()
                }
            }
            if (fightObject["origin"].objectId == PFUser.currentUser().objectId){
                cell.nameLabel.text = fightObject["recipientAlias"] as? String
                // this will create that bug
                
            }
            else{
                cell.nameLabel.text = fightObject["originAlias"] as? String
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.allFights.count
        case 1:
            return self.victories.count
        default:
            return self.losses.count
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section){
        case 0:
            let fightObject = self.allFights[indexPath.row]
            self.openFight(fightObject)
        case 1:
            if let opponent = self.victories[indexPath.row].objectForKey("loser") as? PFUser{
                println(opponent)
                opponent.fetchIfNeeded()
                println(opponent)
                self.performSegueWithIdentifier(Constants.ViewProfileSegue, sender: opponent)
            }
        case 2:
            if let opponent = self.losses[indexPath.row].objectForKey("winner") as? PFUser{
                println(opponent)
                opponent.fetchIfNeeded()
                println(opponent)
                self.performSegueWithIdentifier(Constants.ViewProfileSegue, sender: opponent)
            }
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        Constants().restoreVersusScreen()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.OpenFightSegue{
            if let fovc = segue.destinationViewController as? FightOpenViewController{
                if let fight = sender as? PFObject{
                    fovc.fightToDisplay = fight
                }
            }
        }
        if segue.identifier == Constants.ViewProfileSegue{
            
            if let mvc = segue.destinationViewController.childViewControllers[0] as? MatchViewController{
                if let opponent = sender as? PFUser{
                   mvc.userToDisplay = opponent
                }
            }
        }
    }
}
