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
    let widthOfBar:CGFloat = 200.0
    let sideBarTopInset:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideBarTableViewController:FriendsTableViewController = FriendsTableViewController()
    let origin:UIView!
    var delegate:SideBarDelegate?
    var sideBarOpen:Bool = false
    
    var calledFromLoggedInView:Bool = true
    
    var sideBarToggleFriend:Bool = false
    
    var finalFriendsArray:Array<String> = []
    var finalRequestsArray:Array<String> = []
    
    
    override init(){
        super.init()
    }
    
    
    // custom init method that takes in the view, friends array, requests array //
    init(callingView:UIView, friends:Array<AnyObject>, requests:Array<AnyObject>, fromLoggedInView:Bool) {
        super.init()
        
    
        // requests and friends come in as anyObject which includes all the data about that person.  This is //
        // so that when the user clicks on that person in the side menu, they can have access to that persons //
        // data at any time.  
        
        println("friends \(friends) and requests \(requests)")
        
        
        
        
        // tellin which view called this to change from left side of view to right side of view //
        if(fromLoggedInView == false){
            
            calledFromLoggedInView = false
            sideBarTableViewController.fromLoggedInView = false
            
        }
        
        
        // setting the calling view //
        origin = callingView
        
        
        
        
        
        
    
        // sending the data from the origin to the FriendsTableViewController //
        //sideBarTableViewController.friendsData = finalFriendsArray
        //sideBarTableViewController.requestsData = finalRequestsArray
        sideBarTableViewController.friendsData = Array<String>()
        sideBarTableViewController.requestsData = Array<String>()
        
        
        
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // called from LogginView to update the listview //
    func updateTableView(newDataFriends:Array<AnyObject>, newDataRequests:Array<AnyObject>){
        
        println("new data requests! --------> \(newDataRequests)")
        
        finalRequestsArray.removeAll(keepCapacity: false)
        finalFriendsArray.removeAll(keepCapacity: false)
        
        // goes through the request info and parses it out //
        for(var i = 0; i < newDataRequests.count; i++){
            
            var tempFirstLevel:AnyObject? = newDataRequests[i].objectForKey("userInfo")
            if(tempFirstLevel != nil){
                
                println(tempFirstLevel)
                var userName:AnyObject? = tempFirstLevel?.objectForKey("username")
                if(userName != nil){
                    
                    println(userName!)
                    finalRequestsArray.append(userName! as String)
                    
                    // finalFriendsArray is a string value //
                    sideBarTableViewController.requestsData = finalRequestsArray
                    sideBarTableViewController.reloadTableView()
                }
            }
        }
        
        
        // goes through the friends info and parses it out //
        for(var i = 0; i < newDataFriends.count; i++){
            
            var tempFirstLevel:AnyObject? = newDataFriends[i].objectForKey("userInfo")
            if(tempFirstLevel != nil){
                
                println(tempFirstLevel)
                var userName:AnyObject? = tempFirstLevel?.objectForKey("username")
                if(userName != nil){
                    
                    println(userName!)
                    finalFriendsArray.append(userName! as String)
                    
                    // finalFriendsArray is a string value //
                    sideBarTableViewController.friendsData = finalFriendsArray
                    sideBarTableViewController.reloadTableView()
                }
            }
        }
    }
    

    
    func sideBarSetup(){
        
        // creation of the dimensions of the sidebar //
        
        if(calledFromLoggedInView == true){
            
            sideBarContainerView.frame = CGRectMake(-widthOfBar - 1, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
        }else{
            
            sideBarContainerView.frame = CGRectMake(origin.frame.width, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
            
        }
        
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
    func handleSwipe(gesture:UISwipeGestureRecognizer){
        
        // checking for left direction //
        if(gesture.direction == UISwipeGestureRecognizerDirection.Left){
            
            showSideBar(false)
            delegate?.sideBarWillClose!()
            
            // for right gesture //
        }else{
            
            showSideBar(true)
            delegate?.sideBarWillOpen!()
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    // used to pull out or push in the view //
    func fromFriendsButton(pushed:Bool){
        
        showSideBar(pushed)
        
    }
    
    
    func showSideBar(shouldOpen:Bool){
    
        sideBarOpen = shouldOpen
        
        // coming from logged in view and thus will be on the left hand side //
        if(calledFromLoggedInView == true){
            
            // sliding the side bar open //
            if(sideBarOpen){
            
                sideBarContainerView.frame = CGRectMake(0.0, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
            
                // sliding it closed //
            }else{
            
                sideBarContainerView.frame = CGRectMake(-widthOfBar - 1, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
            }
            
        }else{
            
            if(sideBarOpen){
                
                sideBarContainerView.frame = CGRectMake(origin.frame.width - widthOfBar, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
                
                // sliding it closed //
            }else{
                
                sideBarContainerView.frame = CGRectMake(origin.frame.width, origin.frame.origin.y, widthOfBar, origin.frame.size.height)
            }
            
            
            
        }
 
    }
    

    
    // this is a required delegate method that goes along with //
    // FriendsTableViewControllerDelegate //
    func friendsBarControlDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideBarDidSelectAtIndex(indexPath.row)
    }
}

