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
    
    var meButton:UIButton?
    var meButtonLocation:CGPoint?
    
    var personSelected:Int?
    
    var listOfNamesArray:[String] = ["Cory","Sue", "Kevin", "James", "George"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the colors for the view //
        self.setColors()
        


        
        
        
        
        var screenCenter:CGPoint = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
        // making the image of me in the very center of the screen //
        meButton = UIButton(frame: CGRectMake(screenCenter.x - 50 , screenCenter.y - 50, 100.0, 100.0))
        meButton!.setImage(UIImage(named: "face_100x100.png"), forState: UIControlState.Normal)
        meButton!.layer.cornerRadius = 50
        meButton!.layer.borderWidth = 3.0
        meButton!.layer.borderColor = UIColor.blackColor().CGColor
        meButton!.clipsToBounds = true
        
        meButton!.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(meButton!)
        
        
        // the current location of meButton //
        meButtonLocation = CGPoint(x: meButton!.frame.origin.x, y: meButton!.frame.origin.y)
        
        // start of the label //
        var nameLabelForMe:UILabel = UILabel(frame: CGRectMake(meButtonLocation!.x, meButtonLocation!.y + 100, meButton!.frame.size.width, 30.0))
        nameLabelForMe.text = listOfNamesArray[0]
        nameLabelForMe.textColor = UIColor.whiteColor()
        nameLabelForMe.textAlignment = .Center
        
        self.view.addSubview(nameLabelForMe)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // the friends list view exapand //
    @IBAction func friendsOnClick(sender: AnyObject) {
        


    }
    
    
    
    
    
    // for when the person clicks on a picture
    func personClicked(sender:UIButton){
        
        // setting which user got selected //
        personSelected = sender.tag
        
        
        // You are number 0 , this should take you to your //
        // personal settings //
        if(sender.tag == 0){
            
            self.showAlert()
        
        }
            
        else{
            
            self.showAlert()
        
            
        }
    }
    
    
    
    
    
    
    
    // this shows the alert giving the person the option to cancel, chat, or view profile //
    func showAlert(){
        
        var alert:UIAlertController = UIAlertController(title: "What do you wnat to do?", message: "Do you wish to chat or view profile?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // the profile alert button //
        alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
            // takes you the user to your personal settings //
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
            // setting the index number in the next view //
            aboutViewController.personIndex = self.personSelected
            aboutViewController.listOfPeoplesNames = self.listOfNamesArray
            
            if(self.personSelected == 0){
                aboutViewController.personsPic = "face_100x100.png"
            }else{
                
                println("\(self.personSelected!)")
                aboutViewController.personsPic = "face\(self.personSelected! - 1).png"
            }
            
            self.navigationController?.pushViewController(aboutViewController, animated: true)

            
        }))
        alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    // the broadcast button //
    @IBAction func broadCastOnClick(sender: UIButton) {
        
        
        // the other person button //
        // this simulates finding people around you //
        // in its final iteration, there will be an array of objects that hold //
        // the persons data and will iterate through it all //
        for(var i = 0; i < 4; i++){
            
            var tempIncrement:Double = Double(i) * 105.0
            var numberFloat:CGFloat = CGFloat(tempIncrement)
            
            // creation and positioning of the other persons button //
            var otherPersonButton:UIButton = UIButton(frame: CGRectMake(numberFloat, meButtonLocation!.y - 140, 100.0, 100.0))
            otherPersonButton.setImage(UIImage(named: "face\(i).png"), forState: UIControlState.Normal)
            otherPersonButton.layer.cornerRadius = 50
            otherPersonButton.layer.borderWidth = 3.0
            otherPersonButton.layer.borderColor = UIColor.blackColor().CGColor
            otherPersonButton.clipsToBounds = true
            otherPersonButton.tag = i + 1
            otherPersonButton.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(otherPersonButton)
            
            
            
            // the current location of meButton //
            var otherPersonButtonLocation:CGPoint = CGPoint(x: otherPersonButton.frame.origin.x, y: otherPersonButton.frame.origin.y)
            
            // label for other person //
            var labelForOtherPerson:UILabel = UILabel(frame: CGRectMake(otherPersonButtonLocation.x, otherPersonButtonLocation.y + 60, 100.0, 100.0))
            labelForOtherPerson.text = listOfNamesArray[i + 1]
            labelForOtherPerson.textColor = UIColor.whiteColor()
            labelForOtherPerson.textAlignment = .Center
            
            self.view.addSubview(labelForOtherPerson)
        }
        
        
        
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

