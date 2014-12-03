//
//  GatherInfo.swift
//  Connect2U
//
//  Created by Cory Green on 11/25/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//






// I need to also be notified when someone else starts moving.... So I need to get updates //
// from the other devices as well //

// so when someone starts moving, I need that user to tell the server it has moved and to //
// send out a signal to those that are in range that they need to poll the server as well //

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

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
        var longTempString = NSString(format: "%.04f", longTempDouble)
        var latTempString = NSString(format: "%.04f", latTempDouble)
        
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

                        // see if there are anyone else around you //
                        var query = PFUser.query()
                        

                        // long = -120.2635, lat = 38.0285
                        query.whereKey("long", lessThanOrEqualTo: self.longitude + 0.0005)
                        query.whereKey("long", greaterThanOrEqualTo: self.longitude - 0.0005)
                        
                        query.whereKey("lat", greaterThanOrEqualTo: self.latitude - 0.0005)
                        query.whereKey("lat", lessThanOrEqualTo: self.latitude + 0.0005)
                        query.whereKey("signedIn", equalTo:true)
                        
                        
                        
                        query.findObjectsInBackgroundWithBlock({ (object:[AnyObject]!, error:NSError!) -> Void in
                            
                            var objectArrayTemp:Array<AnyObject> = object
                            
                                
                            // returns all the users to the delegate method //
                            self.delegate?.returnAllUsers(objectArrayTemp)
                            
                            
                            // send notification to those devices that they need to poll the server //
                            self.updateOtherPeoplesDevices(objectArrayTemp)
                            
                            
                        })
                    }
                })
            }
        }
    }
    
    
    
    
    // sends out updates to the devices prompting them to pole the server //
    func updateOtherPeoplesDevices(otherDevicesObject:Array<AnyObject>){
        
        var currentUser = PFUser.currentUser()
        var tempArray:Array<AnyObject> = otherDevicesObject
    
        
        // removing the main user from the main array //
        for(var i = 0; i < otherDevicesObject.count; i++){
            
            if((otherDevicesObject[i].objectId == currentUser.objectId)){
                
                // remove it from the temp array //
                tempArray.removeAtIndex(i)
            }
        }
        
        
        
        for(var i = 0; i < tempArray.count; i++){
    
            var userObject:PFObject = tempArray[i] as PFObject
            
            var userQuery = PFUser.query()
            userQuery.whereKey("objectId", equalTo: userObject.objectId)
            userQuery.getObjectInBackgroundWithId(userObject.objectId, block: { (object:PFObject!, error:NSError!) -> Void in
                
                if(error == nil){
                
                    println("In here and stuff \(object.description)")
                    
                    
                    
                    // so the 'user' needs to be the object ID //
                    var pushQuery:PFQuery = PFInstallation.query()
                    pushQuery.whereKey("user", equalTo: object)
                    pushQuery.whereKey("signedIn", equalTo:true)
                
                    var push = PFPush()
                    push.setQuery(pushQuery)
                    push.setMessage("word!")
                    push.sendPushInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                        
                        if(success){
                            
                            println("success in sending push!")
                            
                        }else{
                            
                            println("error!")
                            
                        }
                    })
                }
            })
        }
    }
    

    
    // starts updates //
    func turnOnUpdates(){
        
        println("locationData started")
        locationManager.startUpdatingLocation()
        
        // resetting the values so the first time the location data gets sent back to the //
        // server and compared each time the user presses the main button //
        longitude = 0.0
        latitude = 0.0
    }

    
    
    
    // stops the location services //
    func stopLocationServices(){
        
        println("locationData stopped")
        locationManager.stopUpdatingLocation()
    }
    

 }
