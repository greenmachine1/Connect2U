//
//  LoggedIn.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit


class LoggedIn: UIViewController,SideBarDelegate {
    
    @IBOutlet weak var broadCast: UIButton!
    
    var meButton:UIButton?
    var meButtonLocation:CGPoint?
    var personSelected:Int?
    var colorPalette = ColorPalettes()
    
    
    var tempBoolToggle:Bool = true
    
    // the outter circle //
    //var circle:CAShapeLayer = CAShapeLayer()
    var loggedInView:LoggedInView = LoggedInView()
    

    // the sidebar //
    var sideBar:SideBar  = SideBar()
    
    var listOfNamesArray:[String] = ["Cory","Sue", "Kevin", "James", "George"]
    var listOfFriends:[String] = ["Grant", "Mark", "Joe", "Brittany"]
    var listOfRequests:[String] = ["Joe", "David", "Steve", "Berry"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the main profile image //
        var screenCenter:CGPoint = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
    
        // setting the colors for the view //
        self.setColors()

        
        // making the image of me in the very center of the screen //
        meButton = UIButton(frame: CGRectMake(screenCenter.x - 50 , screenCenter.y - 50, 100.0, 100.0))
        meButton!.setImage(UIImage(named: "face_100x100.png"), forState: UIControlState.Normal)
        meButton!.layer.cornerRadius = 50
        meButton!.layer.borderWidth = 3.0
        meButton!.layer.borderColor = UIColor.blackColor().CGColor
        meButton!.clipsToBounds = true
        
        meButton!.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        // the current location of meButton //
        meButtonLocation = CGPoint(x: meButton!.frame.origin.x, y: meButton!.frame.origin.y)
        
        // start of the label //
        var nameLabelForMe:UILabel = UILabel(frame: CGRectMake(meButtonLocation!.x, meButtonLocation!.y + 100, meButton!.frame.size.width, 30.0))
        nameLabelForMe.text = listOfNamesArray[0]
        nameLabelForMe.textColor = UIColor.whiteColor()
        nameLabelForMe.textAlignment = .Center
        



        
        
        
        
        
        // creation of the larger circle with names around it //
        loggedInView = LoggedInView(callingView: self.view, circleSize: 100, location: CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y), otherPeople: listOfNamesArray)

        
        
        
        
        
        
        
        
        // adding this to the subview //
        self.view.addSubview(nameLabelForMe)
        self.view.addSubview(meButton!)
 
    }
    
    
    // making sure the view has loaded before setting the side bar... //
    // before it was showing up as you transitioned from the sign in screen to this one //
    override func viewDidAppear(animated: Bool) {
        
        sideBar = SideBar(callingView: self.view, friends: listOfFriends, requests:listOfRequests)
        sideBar.delegate = self
        
    }
    
    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        sideBar.fromFriendsButton(false)
        
        tempBoolToggle = true
    }
    
    
    
    
    
    
    
    
    // this is from the side bar delegate //
    func sideBarDidSelectAtIndex(index: Int) {
        
        // takes you the user to your personal settings //
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
        
        
        // sending over the list of names along with the index
        aboutViewController.personIndex = index
        aboutViewController.listOfPeoplesNames = self.listOfFriends
        
        aboutViewController.personsPic = "face_100x100.png"
        
        self.navigationController?.pushViewController(aboutViewController, animated: true)
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    // good place to disable elements when the friends list is out //
    func sideBarWillOpen() {
        
        
        // lets the system know the frame list is out //
        tempBoolToggle = false
    }
    
    
    // good place to enable elements when the friends list is out //
    func sideBarWillClose() {
        
        
        // lets the system know the frame list is in //
        tempBoolToggle = true
    }
    
    
    
    
    
    
    // the friends list view exapand //
    @IBAction func friendsOnClick(sender: AnyObject) {
        
        if(tempBoolToggle == false){
        
            sideBar.fromFriendsButton(false)
            
            self.tempBoolToggle = true
            
        }else if(tempBoolToggle == true){
            
            sideBar.fromFriendsButton(true)
            
            self.tempBoolToggle = false
        }

    }
    
    
    
    
    
    // for when the person clicks on a picture
    func personClicked(sender:UIButton){
        
        // setting which user got selected //
        personSelected = sender.tag
        
        self.showAlert()
    }
    
    
    
    
    
    
    
    // this shows the alert giving the person the option to cancel, chat, or view profile //
    func showAlert(){
        
        
        if(self.personSelected == 0){
            
            // takes you the user to your personal settings //
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
            // setting the index number in the next view //
            aboutViewController.personIndex = self.personSelected
            aboutViewController.listOfPeoplesNames = self.listOfNamesArray
            
            aboutViewController.personsPic = "face_100x100.png"
            
            self.navigationController?.pushViewController(aboutViewController, animated: true)
            
        }else{
        
            var alert:UIAlertController = UIAlertController(title: "What do you want to do?", message: "Do you wish to chat or view profile?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
            // the profile alert button //
            alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
                // takes you the user to your personal settings //
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
                // setting the index number in the next view //
                aboutViewController.personIndex = self.personSelected
                aboutViewController.listOfPeoplesNames = self.listOfNamesArray
                aboutViewController.personsPic = "face\(self.personSelected! - 1).png"
                
                self.navigationController?.pushViewController(aboutViewController, animated: true)

            
            }))
        
        
            // the chat body //
            alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default, handler: {action in
            
                let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
                
                self.navigationController?.pushViewController(chatViewController, animated: true)
            
            
            }))
            
            // cancel button simply exits out and does nothing //
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            
            // inserting the view just under the side bar //
            self.view.insertSubview(otherPersonButton, atIndex: 2)
            
            
            // the current location of meButton //
            var otherPersonButtonLocation:CGPoint = CGPoint(x: otherPersonButton.frame.origin.x, y: otherPersonButton.frame.origin.y)
            
            // label for other person //
            var labelForOtherPerson:UILabel = UILabel(frame: CGRectMake(otherPersonButtonLocation.x, otherPersonButtonLocation.y + 60, 100.0, 100.0))
            labelForOtherPerson.text = listOfNamesArray[i + 1]
            labelForOtherPerson.textColor = UIColor.whiteColor()
            labelForOtherPerson.textAlignment = .Center
        
            
            // inserting the view just under the side bar //
            self.view.insertSubview(labelForOtherPerson, atIndex: 2)
            
            
            
            
        }
        
        
        
    }
    
    

    
    
    
    
    
    // setting colors for the view //
    func setColors(){
        
        
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        
        // colors for the buttons //
        broadCast.backgroundColor = colorPalette.greenColor
        broadCast.tintColor = colorPalette.whiteColor
        
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

