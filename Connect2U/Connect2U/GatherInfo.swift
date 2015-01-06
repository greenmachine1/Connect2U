
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
    
    // ** used to format the string ** //
    func formatLocation(doublePassedIn:Double) ->Double{
        
        var tempString = NSString(format: "%.04f", doublePassedIn)
        var DoubleStringTemp = tempString.doubleValue
        
        return DoubleStringTemp
    }

    

    
    // gps updates //
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        println(newLocation)
        
        var locationString:String = ""
        
        var locationAge = -newLocation.timestamp.timeIntervalSinceNow
        if(locationAge > 5.0){
            return
        }
        if(newLocation.horizontalAccuracy < 0){
            return
        }
    
        if(oldLocation != nil){
            
            if(oldLocation.horizontalAccuracy > newLocation.horizontalAccuracy){
            
                if(newLocation.horizontalAccuracy <= locationManager.desiredAccuracy){
                    
                    println("we have a bead on your location !")
                    
                    self.getLocation(newLocation)
                    
                }
                
            // checking to see if the person is walking //
            }else if((newLocation.speed > 0.2) && (newLocation.speed < 4.0)){
                
                println("speeeeeeeeding up!")
             
                self.getLocation(newLocation)
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
    
    
    
    func getLocationData(fromPushNotification:Bool, arrayIsEmpty:Bool){
        
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
                                    withParameters: ["lat" : lat, "longi": long, "user" :self.currentUser.objectForKey("username"), "push": fromPushNotification, "literalLocation": self.locationString!]) { (object:AnyObject!, error:NSError!) -> Void in
                                        
                                        
                                        if(error == nil && object != nil){
                                            
                                            // checking the button status //
                                            if(arrayIsEmpty == false){
                                                
                                                // returning the full object back to LoggedIn //
                                                self.delegate?.returnAllUsers(object as Array)
                                                
                                                self.locationManager.startUpdatingLocation()
                                                
                                                
                                            }else{
                                                
                                                // returning an empty array to LoggedIn //
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
    
    
    
    
    

    

    
    
    
    // called when the user clicks on ' see whos around you '
    func updateLocations(arrayIsEmpty:Bool){
        
        self.getLocationData(true, arrayIsEmpty: arrayIsEmpty)
        
    }
    
    
    
    // called when the push comes through that tells us to get an update from the server //
    func updateLocationsFromPush(arrayIsEmpty:Bool){
        
        self.getLocationData(false, arrayIsEmpty: arrayIsEmpty)
        
     }

    
    
    
    
    
    
    
    
    
    
    func stopLocationServices(){
        
        self.locationManager.stopUpdatingLocation()
    }

    
    
    
    // ** push notification comes in ** //
    func pushNotification(){
        
        self.updateLocationsFromPush(false)
        
    }
 }
