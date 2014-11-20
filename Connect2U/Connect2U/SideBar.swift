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

    
    // this is a required delegate method that goes along with //
    // FriendsTableViewControllerDelegate //
    func friendsBarControlDidSelectRow(indexPath: NSIndexPath) {
        
    }
}

