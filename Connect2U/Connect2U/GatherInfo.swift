
// ** so when someone starts moving, I need that user to tell the server it has moved and to ** //
// ** send out a signal to those that are in range that they need to poll the server as well ** //

import UIKit
import Parse


@objc protocol ReturnInfo{
    
    // ** returns an array of all the users ** //
    func returnAllUsers(users:Array<AnyObject>)
    
    func returnLocationData(locationString:String)
    
}

class GatherInfo: NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    let difference = 0.0002
    
    var finalPoint:PFGeoPoint?
    var geoLocation:CLGeocoder?
    
    var lastLocation:CLLocation?
    
    var locationString:String?
    
    // ** getting the current user ** //
    var currentUser = PFUser.currentUser()
    var delegate:ReturnInfo?

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        //locationManager.distanceFilter = 1
        
        finalPoint = PFGeoPoint()
        geoLocation = CLGeocoder()
        locationString = ""
        
        lastLocation = CLLocation()
    }

    
    /*
    // ** updates with location ** //
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        if(oldLocation? != nil){
            
            // ** getting the difference between the update time and the time since 1970 ** //
            var timeDifference = newLocation!.timestamp.timeIntervalSince1970 - oldLocation!.timestamp.timeIntervalSince1970
        
            println("difference in time is! : \(timeDifference)")
        
            if(newLocation.horizontalAccuracy > 2){
    
                // ** making it so that this code cant update more than 1 second appart ** //
                if((timeDifference < 10.0) && (timeDifference > 1.0)){
                    
                    //if(abs(timeInterval) < 1){
                
                        // ** formatting and returning the long and lat ** //
                        var oldLat = self.formatLocation(oldLocation.coordinate.latitude)
                        var oldLong = self.formatLocation(oldLocation.coordinate.longitude)
                        var newLat = self.formatLocation(newLocation.coordinate.latitude)
                        var newLong = self.formatLocation(newLocation.coordinate.longitude)

                        //if((oldLong != newLong) || (oldLat != newLat)){

                            // ** basically saying that if either long, or lat is within 0.0001 +- of the old ** //
                            // ** location, to not report it ** //
                            if( (newLat >= (oldLat + difference)) || (newLong >= (oldLong + difference)) ||
                                (newLat <= (oldLat - difference)) || (newLong <= (oldLong - difference))){
                                
                                    /*((longitude == 0.0) || (latitude == 0.0)) */
                                    
                                    if(currentUser != nil){
                            
                                        // ** setting the global variable ** //
                                        longitude = newLong
                                        latitude = newLat
                                    
                                        // ** need to override the current users location ** //
                                        currentUser["long"] = longitude
                                        currentUser["lat"] = latitude
                                        currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                                        
                                            if(success == true){
                                            
                                                // ** Cloud method that passes in the longitude and latitude and then ** //
                                                // ** decides who is clos to that position and returns the users ** //
                                                // ** returning all the users with corresponding longitude and latitude ** //
                                                PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.latitude, "longi": self.longitude, "user" :self.currentUser.objectForKey("username"),"push": true]) { (object:AnyObject!, error:NSError!) -> Void in
                                                
                                                    if(error == nil){
                                                
                                                    
                                                        // ** returns all the users to the delegate method ** //
                                                        // ** also returns the users location to the main screen ** //
                                                        self.delegate?.returnAllUsers(object as Array)

                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            //}
                        }
                    }
               // }
            }
    }
    
    */
    
    
    /*
    // location updates //
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        var passedInLongitude = self.formatLocation(finalPoint!.longitude)
        var passedInLatitude = self.formatLocation(finalPoint!.latitude)
        
        var newLongitude = self.formatLocation(newLocation.coordinate.longitude)
        var newLatitude = self.formatLocation(newLocation.coordinate.latitude)
        
        println("\(passedInLongitude),\(passedInLatitude) and \(newLongitude), \(newLatitude)")
        
        
        
        if( (passedInLatitude <= (newLatitude + difference)) && (passedInLatitude >= (newLatitude - difference)) &&
            (passedInLongitude <= (newLongitude + difference)) && (passedInLongitude >= (newLongitude - difference)) ){
            
                println("it is! : \(passedInLatitude) and \(newLatitude)\n")
                println("it is! : \(passedInLongitude) and \(newLongitude)\n")
            
                finalPoint = PFGeoPoint(location: newLocation)
                
                if(currentUser != nil){
                    
                    // ** need to override the current users location ** //
                    currentUser["long"] = finalPoint!.longitude
                    currentUser["lat"] = finalPoint!.latitude
                    currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                        
                        if(success == true){
                            
                            // ** Cloud method that passes in the longitude and latitude and then ** //
                            // ** decides who is clos to that position and returns the users ** //
                            // ** returning all the users with corresponding longitude and latitude ** //
                            PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : self.finalPoint!.latitude, "longi": self.finalPoint!.longitude, "user" :self.currentUser.objectForKey("username"),"push": true]) { (object:AnyObject!, error:NSError!) -> Void in
                                
                                if(error == nil){
                                    
                                    
                                    // ** returns all the users to the delegate method ** //
                                    // ** also returns the users location to the main screen ** //
                                    self.delegate?.returnAllUsers(object as Array)
                                    
                                }
                            }
                        }
                    })
                }
        }
        
        
    }

// 39FA3A4E799DCEA 
    */
    
    /*
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        println("previous location : \(self.finalPoint)) \n \nand updated Location : \(newLocation) \n")
        
        
        // basically saying that it needs to be within a certain range of the initial point to start reporting //
        
        if((self.formatLocation(newLocation.coordinate.longitude) <= (self.formatLocation(self.finalPoint!.longitude + difference))) &&
            (self.formatLocation(newLocation.coordinate.longitude) >= (self.formatLocation(self.finalPoint!.longitude - difference))) &&
            (self.formatLocation(newLocation.coordinate.latitude) <= (self.formatLocation(self.finalPoint!.latitude + difference))) &&
            (self.formatLocation(newLocation.coordinate.latitude) >= (self.formatLocation(self.finalPoint!.latitude - difference)))){

            // setting the final point to be the new location //
            self.finalPoint = PFGeoPoint(location: newLocation)
            
            println("new location stuff!\(self.finalPoint!)")
                
            self.getLocation(newLocation)
                
        }else{
            
            return
        }
    }
    */
    
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        var locationString:String = ""

        println(newLocation)
        println(newLocation.horizontalAccuracy)
        
        var locationAge = -newLocation.timestamp.timeIntervalSinceNow
        if(locationAge > 5.0){
            return
        }
        if(newLocation.horizontalAccuracy < 0){
            return
        }
    
        if(oldLocation != nil){
            
            if(oldLocation.horizontalAccuracy > newLocation.horizontalAccuracy){
                
                println("old location accuracy : \(oldLocation.horizontalAccuracy) \n")
                println("new location accuracy : \(newLocation.horizontalAccuracy) \n")
                
                println("stuff and thigns! : \(newLocation)")
                
                if(newLocation.horizontalAccuracy <= locationManager.desiredAccuracy){
                    
                    println("we have a bead on your location !")
                    
                    self.getLocation(newLocation)
                    
                }
            }
        }
    }
    
    
    
    
    
    
    // getting the geolocation data //
    func getLocation(coordinates:CLLocation){
        
        // getting a geo location //
        geoLocation?.reverseGeocodeLocation(coordinates, completionHandler: { (returnObject:[AnyObject]!, error:NSError!) -> Void in
            
            var locationArray: AnyObject = returnObject.last!
            self.locationString = "\(locationArray.locality) \(locationArray.subThoroughfare) \(locationArray.thoroughfare) \(locationArray.postalCode)"
            
            var longitudeNew = self.formatLocation(coordinates.coordinate.longitude)
            var latitudeNew = self.formatLocation(coordinates.coordinate.latitude)
            
            
            println(self.locationString!)

            // debugging return function //
            //self.delegate?.returnLocationData(self.locationString!)

            if(self.currentUser != nil){
                
                // ** need to override the current users location ** //
                self.currentUser["long"] = longitudeNew
                self.currentUser["lat"] = latitudeNew
                self.currentUser["literalLocation"] = self.locationString
                self.currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    
                    if(success == true){
                        
                        println("im in here now ")
                        
                        // ** Cloud method that passes in the longitude and latitude and then ** //
                        // ** decides who is clos to that position and returns the users ** //
                        // ** returning all the users with corresponding longitude and latitude ** //
                        PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : latitudeNew, "longi": longitudeNew, "user" :self.currentUser.objectForKey("username"),"push": true, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                            
                            if(error == nil){
                                
                                // ** returns all the users to the delegate method ** //
                                // ** also returns the users location to the main screen ** //
                                self.delegate?.returnAllUsers(object as Array)
                                
                            }
                        }
                    }
                })
            }
        })
    }

    
    
    
    
    
    

    
    
    
    
    // ** used to format the string ** //
    func formatLocation(doublePassedIn:Double) ->Double{
        
        var tempString = NSString(format: "%.04f", doublePassedIn)
        var DoubleStringTemp = tempString.doubleValue
        
        return DoubleStringTemp
    }
    
    
    
    
    // **** should start up location updates from inside here!! **** //
    // **** after the first update happens, location services **** //
    // **** should start up and quit when the user hits cancel **** //
    
    // ** seeing whos around and also notifying others that they need to update ** //
    /*
    func updateLocations(arrayIsEmpty:Bool){
        
        var lat:Double = 0.0
        var long:Double = 0.0
        
        // false for being on, true for being off //
        println(arrayIsEmpty)
        
        // getting an updated longitude and latitude //
        PFGeoPoint.geoPointForCurrentLocationInBackground { (point:PFGeoPoint!, error:NSError!) -> Void in
            
            if(error == nil){
                
                println("point : \(point)")
                lat = self.formatLocation(point.latitude)
                long = self.formatLocation(point.longitude)
                
                self.finalPoint = point
                
                println(self.finalPoint)
                
                var geoPointToCLLocationPoint:CLLocation = CLLocation(latitude: lat, longitude: long)
                
                self.geoLocation?.reverseGeocodeLocation(geoPointToCLLocationPoint, completionHandler: { (returnObject:[AnyObject]!, error:NSError!) -> Void in
                    
                    var locationArray: AnyObject = returnObject.last!
                    self.locationString = "\(locationArray.locality) \(locationArray.subThoroughfare) \(locationArray.thoroughfare) \(locationArray.postalCode)"
                    
                    println(self.locationString!)

                    if(self.currentUser != nil){
                    
                        // ** need to override the current users location ** //
                        self.currentUser["long"] = long
                        self.currentUser["lat"] = lat
                        self.currentUser["literalLocation"] = self.locationString!
                        self.currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                        
                            if(success == true){

                                PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : lat, "longi": long, "user" :self.currentUser.objectForKey("username"),"push": true, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                                        
                                    if(error == nil){
                                            
                                        println("sent info to server")
                                            
                                        if(arrayIsEmpty == false){
                                            // ** if the array isnt empty, then send it back ** //
                                            self.delegate?.returnAllUsers(object as Array)
                                                
                                            self.locationManager.startUpdatingLocation()
                                                
                                        }else{
                                                
                                            // ** if the array is empty, then send over an empty array ** //
                                            self.delegate?.returnAllUsers(Array<AnyObject>())
                                                
                                            self.locationManager.stopUpdatingLocation()
                                        }
                                    }
                                }
                            }
                        })
                    }
                })
            }
        }
    }
*/
    
    
    
    // called when the user clicks on ' see whos around you '
    func updateLocations(arrayIsEmpty:Bool){
        
        // false is when the user clicks 'see whos around you' //
        // true is when the user clicks 'cancel'
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint!, error:NSError!) -> Void in
            
            if(error == nil){
                
                // converting back into a CLLocation object //
                var locationForReverseGeo:CLLocation = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                // reverse geoCoding to get the address of the user //
                self.geoLocation?.reverseGeocodeLocation(locationForReverseGeo, completionHandler: { (returnedObject:[AnyObject]!, error:NSError!) -> Void in
                    
                    
                    // making the location string //
                    var locationArray: AnyObject = returnedObject.last!
                    self.locationString = "\(locationArray.locality) \(locationArray.subThoroughfare) \(locationArray.thoroughfare) \(locationArray.postalCode)"
                    
                    
                    if(self.currentUser != nil){
                        
                        var lat = self.formatLocation(locationForReverseGeo.coordinate.latitude)
                        var long = self.formatLocation(locationForReverseGeo.coordinate.longitude)
                    
                        // sending info to the server //
                        if(arrayIsEmpty == true){
                            
                            // dont want the server to retain the users literal location //
                            self.currentUser["literalLocation"] = ""
                            self.currentUser["long"] = 0.0
                            self.currentUser["lat"] = 0.0
                        }else{
                        
                            self.currentUser["literalLocation"] = self.locationString
                            self.currentUser["long"] = long
                            self.currentUser["lat"] = lat
                        }
                        
                        // saving the user info //
                        self.currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                            
                            if(success == true){
                                
                                // calling the cloud function to see whos around you ... //
                                PFCloud.callFunctionInBackground("retrieveUsersNearBy",
                                    withParameters: ["lat" : lat, "longi": long, "user" :self.currentUser.objectForKey("username"), "push": true, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                                        
                                        
                                        if(error == nil && object != nil){
                                            
                                            // checking the button status //
                                            if(arrayIsEmpty == false){
                                                
                                                // returning the full object back to LoggedIn //
                                                self.delegate?.returnAllUsers(object as Array)
                                                
                                                //self.locationManager.startUpdatingLocation()
                                                
                                                
                                            }else{
                                                
                                                // returning an empty array to LoggedIn //
                                                self.delegate?.returnAllUsers(Array<AnyObject>())
                                                
                                                //self.locationManager.stopUpdatingLocation()
                                                
                                            }
                                        }
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    

    
    
    

    
    
    
    
    
    /*
    // ** called from a push notification ** //
    func updateLocationsFromPush(arrayIsEmpty:Bool){
        
        var lat:Double = 0.0
        var long:Double = 0.0
        
        // getting an updated longitude and latitude //
        PFGeoPoint.geoPointForCurrentLocationInBackground { (point:PFGeoPoint!, error:NSError!) -> Void in
            
            if(error == nil){
            
                println("point : \(point)")
                lat = self.formatLocation(point.latitude)
                long = self.formatLocation(point.longitude)
                
                self.finalPoint = point
                
                println(self.finalPoint)
                
                var geoPointToCLLocationPoint:CLLocation = CLLocation(latitude: lat, longitude: long)
                self.getLocation(geoPointToCLLocationPoint)
                
                PFCloud.callFunctionInBackground("retrieveUsersNearBy", withParameters: ["lat" : lat, "longi": long, "user" :self.currentUser.objectForKey("username"), "push": false, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                    
                    if(error == nil){
                        
                        println("sent info to server")
                        
                        if(arrayIsEmpty == false){
                            
                            // ** if the array isnt empty, then send it back ** //
                            self.delegate?.returnAllUsers(object as Array)
                            
                        }else{
                            
                            // ** if the array is empty, then send over an empty array ** //
                            self.delegate?.returnAllUsers(Array<AnyObject>())
                        }
                    }
                }
            }
        }
    }
    
    */
    
    
    
    // called when the push comes through that tells us to get an update from the server //
    func updateLocationsFromPush(arrayIsEmpty:Bool){
        
        println("got a push notification!")
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint!, error:NSError!) -> Void in
            
            if(error == nil){
                
                // converting back into a CLLocation object //
                var locationForReverseGeo:CLLocation = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                // reverse geoCoding to get the address of the user //
                self.geoLocation?.reverseGeocodeLocation(locationForReverseGeo, completionHandler: { (returnedObject:[AnyObject]!, error:NSError!) -> Void in
                    
                    
                    // making the location string //
                    var locationArray: AnyObject = returnedObject.last!
                    self.locationString = "\(locationArray.locality) \(locationArray.subThoroughfare) \(locationArray.thoroughfare) \(locationArray.postalCode)"
                    
                    
                    if(self.currentUser != nil){
                        
                        var lat = self.formatLocation(locationForReverseGeo.coordinate.latitude)
                        var long = self.formatLocation(locationForReverseGeo.coordinate.longitude)
                        
                        // sending info to the server //
                        if(arrayIsEmpty == true){
                            
                            // dont want the server to retain the users literal location //
                            self.currentUser["literalLocation"] = ""
                            self.currentUser["long"] = 0.0
                            self.currentUser["lat"] = 0.0
                        }else{
                            
                            self.currentUser["literalLocation"] = self.locationString
                            self.currentUser["long"] = long
                            self.currentUser["lat"] = lat
                        }
                        
                        // saving the user info //
                        self.currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                            
                            if(success == true){
                                
                                // calling the cloud function to see whos around you ... //
                                PFCloud.callFunctionInBackground("retrieveUsersNearBy",
                                    withParameters: ["lat" : lat, "longi": long, "user" :self.currentUser.objectForKey("username"), "push": false, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                                        
                                        
                                        if(error == nil && object != nil){
                                            
                                            // checking the button status //
                                            if(arrayIsEmpty == false){
                                                
                                                // returning the full object back to LoggedIn //
                                                self.delegate?.returnAllUsers(object as Array)
                                                
                                                
                                            }else{
                                                
                                                // returning an empty array to LoggedIn //
                                                self.delegate?.returnAllUsers(Array<AnyObject>())
                                                
                                            }
                                        }
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    func stopLocationServices(){
        
        self.locationManager.stopUpdatingLocation()
    }

    
    
    
    // ** push notification comes in ** //
    func pushNotification(){
        
        self.updateLocationsFromPush(false)
        
    }
 }
