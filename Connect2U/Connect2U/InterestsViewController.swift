//
//  InterestsViewController.swift
//  Connect2U
//
//  Created by Cory Green on 1/29/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit

@objc protocol SendDataBackToMain{
    
    func sendBackTheArray(interestArray:Array<String>)
    
}

class InterestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SendDataBack {

    @IBOutlet weak var interestMainTableView: UITableView!
    
    var listOfInterestsPassedBackFromNextLevel:Array<String> = []
    
    var delegate:SendDataBackToMain?
    
    var listOfInterests:Array<String> = ["Sports","Automotive","Art","Outdoors"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        if(self.isMovingFromParentViewController() || self.isBeingDismissed()){
            
            println("is in here")
            
            // sending the data back to the about view controller //
            delegate?.sendBackTheArray(listOfInterestsPassedBackFromNextLevel)
        }
    }
    
    
    
    
    
    func sendBackTheArray(interestArray: Array<String>) {
        
        println("array passed backwards --> \(interestArray)")
        
        listOfInterestsPassedBackFromNextLevel = interestArray
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = listOfInterests[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("selected \(listOfInterests[indexPath.row])")
        
        let secondInterestsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondInterest") as InterestLevelTwoViewController
        
        secondInterestsViewController.indexPassedIn = indexPath.row
        secondInterestsViewController.interestCategoryPassedIn = listOfInterests[indexPath.row]
        secondInterestsViewController.delegate = self
        secondInterestsViewController.setArrayComingForward(listOfInterestsPassedBackFromNextLevel)
        
        self.navigationController?.pushViewController(secondInterestsViewController, animated: true)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfInterests.count
    }
}
