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

    // friends and requests data //
    var friendsData:Array<String> = []
    var requestsData:Array<String> = []

    
    // number of sections currently in place //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 2
    }

    
    // number of friends! //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(section == 0){
            
            return self.friendsData.count
        }
            
        else if(section == 1){
            
            return self.requestsData.count
        }
        
        return 0
    }

    
    
    
    
    // creation of the cells themselves //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if(cell == nil){
        
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell!.backgroundColor = UIColor.clearColor()
            
            cell!.textLabel.textColor = UIColor.blackColor()
        
            // making the selected frame //
            let selected:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: cell!.frame.size.height, height: cell!.frame.size.width))
            
            
            // setting the transparity of the selected frame //
            selected.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            // adding it to the backgroundview of cell //
            cell!.selectedBackgroundView = selected
        }
        
        // filling in the text with either friends or request data //
        if(indexPath.section == 0){
            
            cell!.textLabel.text = friendsData[indexPath.row]
        }
        if(indexPath.section == 1){
            
            cell!.textLabel.text = requestsData[indexPath.row]
        }
        
        return cell!

    }
    
    
    // setting the headers to the table view //
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0){
            
            return "Friends"
            
        }else if(section == 1){
            
            return "Requests"
        }
        
        return ""
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












