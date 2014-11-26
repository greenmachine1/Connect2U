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
    func returnAllUsers(users:Array<AnyObject>)
    
}

class GatherInfo: NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    // variable used to temporarily store the users location //
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    
    // getting the current user //
    var currentUser = PFUser.currentUser()
    var delegate:ReturnInfo?
    
    
    // all the users //
    //var allUsers:Array<AnyObject>?
    
    
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
        // need to adjust the precision of the double value //
        // after testing is done //
        var longTempString = NSString(format: "%.02f", longTempDouble)
        var latTempString = NSString(format: "%.02f", latTempDouble)
        
        var doubleTempLongValue = longTempString.doubleValue
        var doubleTempLatValue = latTempString.doubleValue
        
        
        // checking to see if the numbers are the same //
        if((doubleTempLongValue != longitude) || (doubleTempLatValue != latitude)){
            
            longitude = doubleTempLongValue
            latitude = doubleTempLatValue
            
            if(currentUser != nil){
                
                // need to override the current users location //
                currentUser["long"] = "\(longitude)"
                currentUser["lat"] = "\(latitude)"
                currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    
                    // this will update the server of location for the user and upon saving //
                    // will return all the users within the location //
                    if(success == true){

                        // see if there are anyone else around you //
                        //self.queryTheServer()
                        
                        var query = PFUser.query()
                        query.whereKey("long", containsString: "\(self.longitude)")
                        query.whereKey("lat", containsString: "\(self.latitude)")
                        query.findObjectsInBackgroundWithBlock({ (object:[AnyObject]!, error:NSError!) -> Void in
                            
                        
                            var objectArrayTemp:Array<AnyObject> = object
                            
                            // returns all the users to the delegate method //
                            self.delegate?.returnAllUsers(objectArrayTemp)
                            
                        })

                    }
                })
            }
        }
    }
    
    
    
    
    // this must be done on a seperate thread //
    func queryTheServer(){
        
        var returnedObjects:Array<AnyObject> = []
        var backgroundTask:dispatch_queue_t? = dispatch_queue_create(
            "Server Que", nil)
        
        // initiating the background task //
        dispatch_async(backgroundTask!, { () -> Void in
            
            // this will be a query call to the server to check whos in the area //
            var query = PFUser.query()
            query.whereKey("long", containsString: "\(self.longitude)")
            query.whereKey("lat", containsString: "\(self.latitude)")
            var returnedObjects = query.findObjects()
            
            
            // returns all the users to the delegate method //
            self.delegate?.returnAllUsers(returnedObjects!)
            
            println("this got called")
        })
        
        
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
