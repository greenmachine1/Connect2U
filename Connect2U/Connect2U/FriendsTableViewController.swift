//
//  FriendsTableViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

protocol FriendsTableViewControllerDelegate{
    func friendsBarControlDidSelectRow(indexPath:NSIndexPath)
}

class FriendsTableViewController: UITableViewController {

    var delegate:FriendsTableViewControllerDelegate?
    var friendsData:Array<String> = ["Cory", "Gary", "Katy", "Matt", "Judy"]

    
    // number of sections currently in place //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    
    // number of friends! //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendsData.count
    }

    
    
    
    
    // creation of the cells themselves //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell

        if(cell == nil){
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel.textColor = UIColor.blackColor()
            
            cell!.textLabel.text = friendsData[indexPath.row]
            
            
            // making the selected frame //
            let selected:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: cell!.frame.size.height, height: cell!.frame.size.width))
            
            
            // setting the transparity of the selected frame //
            selected.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            // adding it to the backgroundview of cell //
            cell!.selectedBackgroundView = selected
        }
        
        // filling in the text //
        cell!.textLabel.text = friendsData[indexPath.row]

        return cell!
    }
    
    
    
    
    // the height of the cell //
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    
    // used to pass back data to the calling class //
    // which will be the LoggedIn class //
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // calling the delegate to pass back the index path //
        delegate?.friendsBarControlDidSelectRow(indexPath)
    }
    

   }












