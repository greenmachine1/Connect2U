




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
        locationManager.distanceFilter = 10
    }
    
    
    /*
    - (void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
    {
        @try
        {
        if(newLocation.horizontalAccuracy > 100)
        {
            NSLog(@”Ignoring GPS location more than 100 meters inaccurate :%f”, newLocation.horizontalAccuracy);
            return;
        }
    
        NSDate* eventDate = newLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (abs(howRecent) < 15.0)
        {
            NSLog(@”Ignoring GPS location more than 15 seconds old(cached) :%d”, abs(howRecent));
            return;
        }
    
        [myLM stopUpdatingLocation];
    }
    @catch (NSException* ex)
        {
        [self debugMessage:ex.reason withTitle:@”Uncaught Error in didUpdateToLocation()”];
        }
    }

    */
    
    
    

    
    
    
    /*
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
                    
                println("user location has changed \(self.latitude) : \(self.longitude)")

                if(success == true){

                    // Cloud method that passes in the longitude and latitude and then //
                    // decides who is clos to that position and returns the users //
                    // returning all the users with corresponding longitude and latitude //
                    PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.latitude, "longi": self.longitude, "user" :self.currentUser.objectForKey("username")]) { (object:AnyObject!, error:NSError!) -> Void in
                            
                        if(error == nil){
                    
                            println("sent info to server")
                            
                            // returns all the users to the delegate method //
                            // also returns the users location to the main screen //
                            self.delegate?.returnAllUsers(object as Array)
                            
                            
                        }
                            
                    }
                }
                })
            }
        }
    }

    */
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        // filtering out cache locations //
        var eventDate:NSDate = newLocation.timestamp
        var timeInterval = eventDate.timeIntervalSinceNow
        
        if(abs(timeInterval) < 10){
            
            var longTemp = newLocation.coordinate.longitude
            var latTemp = newLocation.coordinate.latitude
            
            var longTempDouble = Double(longTemp)
            var latTempDouble = Double(latTemp)
            
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
                        
                        println("user location has changed \(self.latitude) : \(self.longitude)")
                        
                        if(success == true){
                            
                            // Cloud method that passes in the longitude and latitude and then //
                            // decides who is clos to that position and returns the users //
                            // returning all the users with corresponding longitude and latitude //
                            PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.latitude, "longi": self.longitude, "user" :self.currentUser.objectForKey("username")]) { (object:AnyObject!, error:NSError!) -> Void in
                                
                                if(error == nil){
                                    
                                    println("sent info to server")
                                    
                                    // returns all the users to the delegate method //
                                    // also returns the users location to the main screen //
                                    self.delegate?.returnAllUsers(object as Array)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    

    func updateLocations(arrayIsEmpty:Bool){
        
        println("location : \(self.longitude) : \(self.latitude)")
                
        PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.latitude, "longi": self.longitude, "user" :self.currentUser.objectForKey("username")]) { (object:AnyObject!, error:NSError!) -> Void in
            if(error == nil){
                
                if(arrayIsEmpty == false){
                    self.delegate?.returnAllUsers(object as Array)
                }else{
                    self.delegate?.returnAllUsers(Array<AnyObject>())
                }
            }
        }
    }
    
    
    
    
    
    
    func forcedUpdate(){
        
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    
    func forcedTurnOff(){
        
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
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
