//
//  InterestLevelTwoViewController.swift
//  Connect2U
//
//  Created by Cory Green on 1/29/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit

@objc protocol SendDataBack{
    
    func sendBackTheArray(interestArray:Array<String>)
    
}

class InterestLevelTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var interestsViewController: UITableView!
    
    var indexPassedIn:Int = 0
    var interestCategoryPassedIn = ""
    
    var delegate:SendDataBack?
    
    var arrayOfInterestsSports = ["Foot Ball", "Base Ball","Soccer", "Golf","Tennis","Bowling"]
    var arrayOfInterestsAutomotive = ["Muscle Cars", "Sports Cars","SUV's", "Classics","Car Maintainance"]
    var arrayOfInterestsArt = ["Photography", "Painting","Sculpture", "Monuments","Drawing"]
    var arrayOfInterestsOutdoors = ["Camping", "Hunting","Fishing", "Hiking","Star Gazing","Biking"]
    
    var arrayComingForward:Array<String> = []
    
    var finalArrayOfInterestsToBeSentBack:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    
    func setArrayComingForward(arrayPassedIn:Array<String>){
        
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        if(self.isMovingFromParentViewController() || self.isBeingDismissed()){
            
            println("is in here")
            
            delegate?.sendBackTheArray(finalArrayOfInterestsToBeSentBack)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        
        switch indexPassedIn{
        case 0:
            cell.textLabel?.text = arrayOfInterestsSports[indexPath.row]
        case 1:
            cell.textLabel?.text = arrayOfInterestsAutomotive[indexPath.row]
        case 2:
            cell.textLabel?.text = arrayOfInterestsArt[indexPath.row]
        case 3:
            cell.textLabel?.text = arrayOfInterestsOutdoors[indexPath.row]
        default:
            cell.textLabel?.text = ""
            
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch indexPassedIn{
        case 0:
            return arrayOfInterestsSports.count
        case 1:
            return arrayOfInterestsAutomotive.count
        case 2:
            return arrayOfInterestsArt.count
        case 3:
            return arrayOfInterestsOutdoors.count
        default:
            return 0

        }
    }

    
    // adding items //
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected \(indexPath.row)")
        
        
        switch indexPassedIn{
        case 0:
            finalArrayOfInterestsToBeSentBack.append(arrayOfInterestsSports[indexPath.row])
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
        case 1:
            finalArrayOfInterestsToBeSentBack.append(arrayOfInterestsAutomotive[indexPath.row])
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
        case 2:
            finalArrayOfInterestsToBeSentBack.append(arrayOfInterestsArt[indexPath.row])
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
        case 3:
            finalArrayOfInterestsToBeSentBack.append(arrayOfInterestsOutdoors[indexPath.row])
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
        default:
            println("nothing")
            
        }
        
    }
    
    
    
    // removing items //
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPassedIn{
        case 0:
            
            var sportsObjectToLookUpAndDelete:String = arrayOfInterestsSports[indexPath.row]
            
            for(index, element) in enumerate(finalArrayOfInterestsToBeSentBack){
                
                if(element == sportsObjectToLookUpAndDelete){
                    
                    println("found you!")
                    finalArrayOfInterestsToBeSentBack.removeAtIndex(index)
                }
            }
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
            
        case 1:
            
            var autoObjectToLookUpAndDelete:String = arrayOfInterestsAutomotive[indexPath.row]
            
            for(index, element) in enumerate(finalArrayOfInterestsToBeSentBack){
                
                if(element == autoObjectToLookUpAndDelete){
                    
                    println("found you!")
                    finalArrayOfInterestsToBeSentBack.removeAtIndex(index)
                }
            }
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
            
            
        case 2:
            
            var artObjectToLookUpAndDelete:String = arrayOfInterestsSports[indexPath.row]
            
            for(index, element) in enumerate(finalArrayOfInterestsToBeSentBack){
                
                if(element == artObjectToLookUpAndDelete){
                    
                    println("found you!")
                    finalArrayOfInterestsToBeSentBack.removeAtIndex(index)
                }
            }
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
            
        case 3:
            
            var outdoorsObjectToLookUpAndDelete:String = arrayOfInterestsOutdoors[indexPath.row]
            
            for(index, element) in enumerate(finalArrayOfInterestsToBeSentBack){
                
                if(element == outdoorsObjectToLookUpAndDelete){
                    
                    println("found you!")
                    finalArrayOfInterestsToBeSentBack.removeAtIndex(index)
                }
            }
            
            println("in here --> \(finalArrayOfInterestsToBeSentBack)")
            
        default:
            println("nothing")
            
        }
    }
}
