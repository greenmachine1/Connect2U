//
//  SideBar.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

// creating a new sidebar delegate //
// one required function and 2 optional //
@objc protocol SideBarDelegate{
    
    func sideBarDidSelectAtIndex(index:Int)
    
    optional func sideBarWillClose()
    optional func sideBarWillOpen()
    
}

class SideBar: NSObject, FriendsTableViewControllerDelegate {
    
    // creating info for the sidebar
    let widthOfBar:CGFloat = 150.0
    let sideBarTopInset:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideBarTableViewController:FriendsTableViewController = FriendsTableViewController()
    let origin:UIView!
    var delegate:SideBarDelegate?
    var sideBarOpen:Bool = false
    
    
    override init(){
        super.init()
    }
    
    init(callingView:UIView, items:Array<String>) {
        super.init()
        
        // setting the calling view //
        origin = callingView
        
        // sending the data from the origin to the FriendsTableViewController //
        sideBarTableViewController.friendsData = items
        
        
        // making the actual sidebar //
        sideBarSetup()
        
        // setting up the gestures associated with this bar //
        // to close //
        let gestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        gestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        origin.addGestureRecognizer(gestureRecognizer)
        
        
        // to expose //
        let hideGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGesture.direction = UISwipeGestureRecognizerDirection.Left
        origin.addGestureRecognizer(hideGesture)
        
        
    }
    
    func sideBarSetup(){
        
        // creation of the dimensions of the sidebar //
        sideBarContainerView.frame = CGRectMake(-widthOfBar - 1, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
        
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        
        // adding the sidebarcontainerview to the view //
        origin.addSubview(sideBarContainerView)
        
        
        
        // creating a blurred background //
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        sideBarTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTopInset, 0.0, 0.0, 0.0)
        
        
        // reloading the data within //
        sideBarTableViewController.tableView.reloadData()
        
        
        // adding the table view //
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
        
    }
    
    
    // swipe gestures //

    
    // this is a required delegate method that goes along with //
    // FriendsTableViewControllerDelegate //
    func friendsBarControlDidSelectRow(indexPath: NSIndexPath) {
        
    }
}

