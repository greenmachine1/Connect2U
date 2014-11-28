//
//  LoggedIn.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse


class LoggedIn: UIViewController,SideBarDelegate, CircleDelegate, ReturnInfo {
    
    @IBOutlet weak var broadCast: UIButton!
    
    var currentUserName:String?
    var currentUserAge:Int?
    var currentUserGender:String?
    var currentUserPic:String?
    var currentUserInterests:Array<String>?
    
    var meButton:UIButton?
    var meButtonLocation:CGPoint?
    var personSelected:Int?
    
    var tempBoolToggle:Bool = true
    var tempBoolToggleForBroadCast:Bool = false
    
    var loggedInView:LoggedInView = LoggedInView()
    var locationData:GatherInfo = GatherInfo()
    var colorPalette = ColorPalettes()
    var currentUser = PFUser.currentUser()
    var sideBar:SideBar  = SideBar()
    
    
    // temporary data //
    var listOfNamesArray:[String] = ["Sue", "Kevin", "James", "George"]
    var listOfFriends:[String] = ["Grant", "Mark", "Joe", "Brittany"]
    var listOfRequests:[String] = ["Joe", "David", "Steve", "Berry"]
    
    
    
    
    var peopleArray:Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the main profile image //
        var screenCenter:CGPoint = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
        self.setColors()
        
        // setting up the current user info //
        self.settingUpTheUserInfo()
        
        locationData.delegate = self



        // making the image of me in the very center of the screen //
        meButton = UIButton(frame: CGRectMake(screenCenter.x - 50 , screenCenter.y - 50, 100.0, 100.0))
        meButton!.setImage(UIImage(named: currentUserPic!), forState: UIControlState.Normal)
        meButton!.layer.cornerRadius = 50
        meButton!.layer.borderWidth = 3.0
        meButton!.layer.borderColor = UIColor.blackColor().CGColor
        meButton!.clipsToBounds = true
        
        
        
        
        // this is going to have to change //
        meButton!.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        // the current location of meButton //
        meButtonLocation = CGPoint(x: meButton!.frame.origin.x, y: meButton!.frame.origin.y)
        
        // start of the label //
        var nameLabelForMe:UILabel = UILabel(frame: CGRectMake(meButtonLocation!.x, meButtonLocation!.y + 100, meButton!.frame.size.width, 30.0))
        nameLabelForMe.text = currentUserName
        nameLabelForMe.textColor = UIColor.whiteColor()
        nameLabelForMe.textAlignment = .Center
        

        
        
        
        // creation of the larger circle with names around it //
        loggedInView = LoggedInView(callingView: self.view, circleSize: 100, location: CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y), otherPeople: peopleArray)
        
        
        

        loggedInView.delegate = self
        
        
        
        // adding this to the subview //
        self.view.addSubview(nameLabelForMe)
        self.view.addSubview(meButton!)
    }
    
    
    
    
    func settingUpTheUserInfo(){
        
        if(currentUser != nil){
            
            currentUserName = currentUser.username
            currentUserAge = currentUser["age"] as? Int
            currentUserGender = currentUser["gender"] as? String
            currentUserPic = currentUser["picture"] as? String
            currentUserInterests = currentUser["interests"] as? Array
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // part of the LoggedInView, this brings back the index and all the names array //
    func didClickOnUser(index: Int, nameOfPerson: Array<AnyObject>) {
        
        println("name of person array \(nameOfPerson[index])")
        
        // setting which user got selected //
        personSelected = index
        
        self.showAlert()
    }
    
    
    
    
    
    
    
    // making sure the view has loaded before setting the side bar... //
    // before it was showing up as you transitioned from the sign in screen to this one //
    override func viewDidAppear(animated: Bool) {
        
        sideBar = SideBar(callingView: self.view, friends: listOfFriends, requests:listOfRequests)
        sideBar.delegate = self
        
    }
    
    
    
    

    
    // dismisses the sidebar //
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
    

    
    
    
    
    
    // this gets called everytime there is an update from the GPS //
    // this brings back all the users in the area //
    func returnAllUsers(users: Array<AnyObject>) {
        
        println("In here : \(users.count)")
        
        println("people within the array :\(users)")
        
        // passes the users to the circle creator! //
        loggedInView.updatePeople(users)
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
    
    
    
    
    // about the person needs to change //
    
    func showAlert(){
        
        
        if(self.personSelected == 0){
            
            // takes you the user to your personal settings //
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
            // setting the index number in the next view //
            //aboutViewController.personIndex = self.personSelected
            //aboutViewController.listOfPeoplesNames = self.listOfNamesArray
            
            aboutViewController.personsPic = "face_100x100.png"
            
            self.navigationController?.pushViewController(aboutViewController, animated: true)
            
        }else{
        
            var alert:UIAlertController = UIAlertController(title: "What do you want to do?", message: "Do you wish to chat or view profile?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
            // the profile alert button //
            alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
                // takes you the user to your personal settings //
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
                // setting the index number in the next view //
                //aboutViewController.personIndex = self.personSelected
                //aboutViewController.listOfPeoplesNames = self.listOfNamesArray
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
        
        if(tempBoolToggleForBroadCast == false){
        
            broadCast.setTitle("Cancel Broadcast", forState: UIControlState.Normal)
        
            // turns on the location updates //
            locationData.turnOnUpdates()
            
            
            tempBoolToggleForBroadCast = true
            
            
            
        }else if(tempBoolToggleForBroadCast == true){
            
            broadCast.setTitle("See Whos Around You", forState: UIControlState.Normal)
            
            locationData.stopLocationServices()
            
            tempBoolToggleForBroadCast = false
            
            
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
// going to be using all of this for this project.... //
var personClass:PersonClass = PersonClass(name: "Cory", picture: "no picture", gender: "Male", interests: listOfFriends)

var newPersonClass:PersonClass = PersonClass(name: "Steven", picture: "not a single one", gender: "Female", interests: listOfFriends)

peopleArray = ["Joe": personClass, "Steven" : newPersonClass]
peopleArray!["Gary"] = newPersonClass


println("\(peopleArray!.count)")



// this is how you get to methods and properties within a class inside of an array //
var classThingy: PersonClass? = peopleArray!["Joe"] as? PersonClass
var newClassThingy: PersonClass? = peopleArray!["Steven"] as? PersonClass
var newClassThingyGary: PersonClass? = peopleArray!["Gary"] as? PersonClass


println("\(classThingy!.pictureString!)")
println("\(newClassThingy!.pictureString!)")
println("\(newClassThingyGary!.pictureString!)")

println("\(classThingy!.interestsArray!)")
    */








