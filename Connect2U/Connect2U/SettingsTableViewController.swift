//
//  SettingsTableViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UIViewController {


    var gatherInfo:GatherInfo = GatherInfo()
    
    var logoutVariable:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    
    // log out button //
    @IBAction func onLogOut(sender: AnyObject) {
        
        println("in here")

        let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("main") as ViewController
        
        mainViewController.loggedInVariable = true
    
        self.navigationController?.pushViewController(mainViewController, animated: true)
        
    }
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var currentUser = PFUser.currentUser()
        
        // setting the user signed in to false and logging the person out //
        currentUser["signedIn"] = false
        currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
            if(success){
                
                self.gatherInfo.stopLocationServices()
                
            }

        })
        
        
    }

    
    
    
    
    
    
    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
     

        
        
    }

}
