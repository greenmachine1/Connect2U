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
    
    @IBOutlet weak var broadCast: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the colors for the view //
        self.setColors()
        
        self.roundImageConvert()
        
    
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func friendsOnClick(sender: AnyObject) {
        

        
        
        
    }
    
    
    func doSomething(sender:UIButton){
        
        if(sender.tag == 0){
            
            println("tapped")
        }else if(sender.tag == 1){
            
            println("other")
        }
        
    }
    
    
    
    
    
    // static creation of people
    func roundImageConvert(){
        
        var meButton:UIButton = UIButton(frame: CGRectMake(50.0, 200.0, 100.0, 100.0))
        meButton.setImage(UIImage(named: "face_100x100.png"), forState: UIControlState.Normal)
        meButton.layer.cornerRadius = 50
        meButton.clipsToBounds = true
        meButton.tag = 0
        meButton.addTarget(self, action: Selector("doSomething:"), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(meButton)
        
        var otherPersonButton:UIButton = UIButton(frame: CGRectMake(250.0, 200.0, 100.0, 100.0))
        otherPersonButton.setImage(UIImage(named: "Kevin.png"), forState: UIControlState.Normal)
        otherPersonButton.layer.cornerRadius = 50
        otherPersonButton.clipsToBounds = true
        otherPersonButton.tag = 1
        otherPersonButton.addTarget(self, action: Selector("doSomething:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(otherPersonButton)
    }
    
    
    // setting colors for the view //
    func setColors(){
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
        
        // colors for the buttons //
        broadCast.backgroundColor = greenColor
        broadCast.tintColor = whiteColor
        
    }
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    /*

    var updateCount:Int = 0

    // allocating the location manager //
    var locationManager:CLLocationManager!

    // variable used to temporarily store the users location //
    var longitude:Double = 0.0
    var latitude:Double = 0.0


    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()

    locationManager.startUpdatingLocation()

    countLabel.text = "Count :\(updateCount)"

    */









    
    /*
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

    */
    /*
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        longLabel.text = "error"
    }
    */

