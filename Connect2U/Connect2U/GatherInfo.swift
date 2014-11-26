//
//  GatherInfo.swift
//  Connect2U
//
//  Created by Cory Green on 11/25/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse


@objc protocol ReturnInfo{
    
    
    // returns an array of all the users //
    func returnAllUsers(users:Array<PFUser>)
    
}

class GatherInfo: NSObject, CLLocationManagerDelegate {
    
    // delegate variable //
    var returnAllUsers:ReturnInfo?
    
    var updateCount:Int = 0
    
    // allocating the location manager //
    var locationManager:CLLocationManager!
    
    // variable used to temporarily store the users location //
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    
    // getting the current user //
    var currentUser = PFUser.currentUser()
    
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    
    

    
    
    
    
    // update that gets fired when the location data gets updated //
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        var longTemp = locations.last?.coordinate.longitude
        var latTemp = locations.last?.coordinate.latitude
        
        var longTempDouble = Double(longTemp!)
        var latTempDouble = Double(latTemp!)
        
        
        // setting the precision of the floating values //
        var longTempString = NSString(format: "%.05f", longTempDouble)
        var latTempString = NSString(format: "%.05f", latTempDouble)
        
        var doubleTempLongValue = longTempString.doubleValue
        var doubleTempLatValue = latTempString.doubleValue
        
        
        // checking to see if the numbers are the same //
        if((doubleTempLongValue != longitude) || (doubleTempLatValue != latitude)){
            
            longitude = doubleTempLongValue
            latitude = doubleTempLatValue
            
            
            if(currentUser != nil){
                
                // need to override the current users location //
                currentUser["long"] = longitude
                currentUser["lat"] = latitude
                currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    
                    
                    // this will update the server of location for the user and upon saving //
                    // will return all the users within the location //
                    if(success == true){
                        
                        println("yup!")
                        
                        
                        // this will be a query call to the server to check whos in the area //
                        var query = PFUser.query()
                        
                        
                        
                        
                    }
                })
            }
        }
    }
    
    // starts updates //
    func turnOnUpdates(){
        
        locationManager.startUpdatingLocation()
        
    }

    
    
    
    // stops the location services //
    func stopLocationServices(){
        
        locationManager.stopUpdatingLocation()
    }
    

 }
