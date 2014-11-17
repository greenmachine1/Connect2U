//
//  LoggedIn.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class LoggedIn: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var updateCount:Int = 0
    
    // allocating the location manager //
    var locationManager:CLLocationManager!
    
    // variable used to temporarily store the users location //
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        countLabel.text = "Count :\(updateCount)"
        
        
        
        
        
        
        // initially creating a parse object under the location class //
        /*
        var newParseObject = PFObject(className: "location")
        newParseObject["long"] = 0.0
        newParseObject["lat"] = 0.0
        newParseObject.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            
            if(success){
                println("success on saving!")
            }else{
                println("error occured")
            }
            
        }
        */
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            longLabel.text = "\(longitude)"
            latLabel.text = "\(latitude)"
            
            
            
            
            
            
            
            // grabbing an object and then overridding its data
            var query = PFQuery(className: "location")
            query.getObjectInBackgroundWithId("leIs9GWS3W", block: { (object:PFObject!, error:NSError!) -> Void in
                
                if(error != nil){
                    println("error")
                }else{
                    object["long"] = self.longitude
                    object["lat"] = self.latitude
                    object.saveEventually()
                }
                
            })
            
            
            
            
            
            
            
            
            
            
            
            
            
            updateCount++
            
            countLabel.text = "Count :\(updateCount)"
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        longLabel.text = "error"
    }
}
