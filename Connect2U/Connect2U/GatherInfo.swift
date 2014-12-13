
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
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0

    var currentTime:NSDate?
    let date = NSDate()
    
    // getting the current user //
    var currentUser = PFUser.currentUser()
    var delegate:ReturnInfo?

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 5
        
        
        // when a push notification comes in this gets called //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushNotification:", name: "pushNotification", object: nil)
        
    }

    
    // updates with location //
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let difference = 0.0002
        
        if(oldLocation? != nil){
            
            // getting the difference between the update time and the time since 1970 //
            var timeDifference = newLocation!.timestamp.timeIntervalSince1970 - oldLocation!.timestamp.timeIntervalSince1970
            
            // making it so that this code cant update more than 3 seconds appart //
            //if(timeDifference > 1.0){
        
                // filtering out cache locations //
                var eventDate:NSDate = newLocation.timestamp
                var timeInterval = eventDate.timeIntervalSinceNow
            
                if(abs(timeInterval) < 1){
                
                    // formatting and returning the long and lat //
                    var oldLat = self.formatLocation(oldLocation.coordinate.latitude)
                    var oldLong = self.formatLocation(oldLocation.coordinate.longitude)
                    var newLat = self.formatLocation(newLocation.coordinate.latitude)
                    var newLong = self.formatLocation(newLocation.coordinate.longitude)

                    if((oldLong != newLong) || (oldLat != newLat)){

                        // basically saying that if either long, or lat is within 0.0002 +- of the old //
                        // location, to not report it //
                        if( (newLat >= (oldLat + difference)) || (newLong >= (oldLong + difference)) ||
                            (newLat <= (oldLat - difference)) || (newLong <= (oldLong - difference))){
                                
                                /*((longitude == 0.0) || (latitude == 0.0)) */
                                
                                if(currentUser != nil){
                            
                                    // setting the global variable //
                                    longitude = newLong
                                    latitude = newLat
                                    
                                    // need to override the current users location //
                                    currentUser["long"] = longitude
                                    currentUser["lat"] = latitude
                                    currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                                        
                                        println("old location : \(oldLat) \(oldLong) and new location : \(newLat) \(newLong)")
                                        println("")
                                        
                                        if(success == true){
                                            
                                            // Cloud method that passes in the longitude and latitude and then //
                                            // decides who is clos to that position and returns the users //
                                            // returning all the users with corresponding longitude and latitude //
                                            PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.latitude, "longi": self.longitude, "user" :self.currentUser.objectForKey("username"),"push": true]) { (object:AnyObject!, error:NSError!) -> Void in
                                                
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
                //}
            }
    }
    
    
    

    
    
    
    
    // used to format the string //
    func formatLocation(doublePassedIn:Double) ->Double{
        
        var tempString = NSString(format: "%.04f", doublePassedIn)
        var DoubleStringTemp = tempString.doubleValue
        
        return DoubleStringTemp
    }
    
    
    
    
    
    
    // seeing whos around and also notifying others that they need to update //
    func updateLocations(arrayIsEmpty:Bool){
    
        var currentUserLong = currentUser["long"].doubleValue
        var currentUserLat = currentUser["lat"].doubleValue
        
        println("this is here \(currentUserLong) \(currentUserLat)")
        println("the boolean logic value is : \(arrayIsEmpty)")
        
        PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : currentUserLat, "longi": currentUserLong, "user" :self.currentUser.objectForKey("username"),"push": true]) { (object:AnyObject!, error:NSError!) -> Void in
            
            if(error == nil){
                
                println("sent info to server")
                
                if(arrayIsEmpty == false){
                    // if the array isnt empty, then send it back //
                    self.delegate?.returnAllUsers(object as Array)
                    
                }else{
                    
                    // if the array is empty, then send over an empty array //
                    self.delegate?.returnAllUsers(Array<AnyObject>())
                }
            }
        }
    }
    
    
    

    
    
    
    
    
    
    // called from a push notification //
    func updateLocationsButNoPush(arrayIsEmpty:Bool){
        
        var currentUserLong = currentUser["long"].doubleValue
        var currentUserLat = currentUser["lat"].doubleValue
        
        println("this is here \(currentUserLong) \(currentUserLat)")
        println("the boolean logic value is push notification : \(arrayIsEmpty)")
        
        PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : currentUserLat, "longi": currentUserLong, "user" :self.currentUser.objectForKey("username"),"push": false]) { (object:AnyObject!, error:NSError!) -> Void in
            
            if(error == nil){
                
                println("sent info to server")
                
                if(arrayIsEmpty == false){
                    // if the array isnt empty, then send it back //
                    self.delegate?.returnAllUsers(object as Array)
                    
                }else{
                    
                    // if the array is empty, then send over an empty array //
                    self.delegate?.returnAllUsers(Array<AnyObject>())
                }
            }
        }
    }
    

    // push notification comes in //
    func pushNotification(sender:AnyObject){
        
        self.updateLocationsButNoPush(false)
        
    }
    
    
    
    // starts updates //
    func turnOnUpdates(){
        
        println("locationData started")
        locationManager.startUpdatingLocation()
        
    }

    
    
    
    // stops the location services //
    func stopLocationServices(){
        
        println("locationData stopped")
        locationManager.stopUpdatingLocation()
    }
 }
