//
//  LoggedIn.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse



class LoggedIn: UIViewController, SideBarDelegate, ReturnInfo, ReturnWithPersonClicked, RequestChatDelegate{
    
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
    
    var helperClass:HelperClassOfProfilePics = HelperClassOfProfilePics()
    //var locationData:GatherInfo = GatherInfo()
    var colorPalette = ColorPalettes()
    var currentUser = PFUser.currentUser()
    var sideBar:SideBar  = SideBar()
    var userClickedOn:PFUser = PFUser()
    var chatRequest = ChatRequest()
    
    var beaconGatherData = IBeaconGatherData()
    var beaconTransmitData = IBeaconTransmitData()
    
    
    var mainBigCircle:MainBigCircle = MainBigCircle()
    
    var tempArrayPassedIn:Array<AnyObject>?
    

    // temporary data //
    //var listOfNamesArray:[String] = ["Sue", "Kevin", "James", "George"]
    var listOfFriends:[String] = ["Grant", "Mark", "Joe", "Brittany"]
    var listOfRequests:[String] = ["Joe", "David", "Steve", "Berry"]
    
    var emptyInitialArray:Array<AnyObject> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setting up the main profile image //
        var screenCenter:CGPoint = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
        self.setColors()
        
        println("currentUser --> \(PFUser.currentUser())")
        

        if(currentUser != nil){
            currentUser["signedIn"] = false
            currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if(success){
                
                    println("success in saving")
                }
            })
        }
        
        
        
        
        // setting up the current user info //
        self.settingUpTheUserInfo()
        
        //locationData.delegate = self
        chatRequest.delegate = self
    
        
        
        
        // ** when a push notification comes in this gets called ** //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushNotification:", name: "pushNotification", object: nil)
        
        
        
        
        

        // making the image of me in the very center of the screen //
        meButton = UIButton(frame: CGRectMake(screenCenter.x - 50 , screenCenter.y - 50, 100.0, 100.0))
        meButton!.setImage(UIImage(named: currentUserPic!), forState: UIControlState.Normal)
        meButton!.layer.cornerRadius = 50
        meButton!.layer.borderWidth = 3.0
        meButton!.layer.borderColor = UIColor.blackColor().CGColor
        meButton!.clipsToBounds = true
        meButton!.tag = 1001
        meButton!.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        

        // the current location of meButton //
        meButtonLocation = CGPoint(x: meButton!.frame.origin.x, y: meButton!.frame.origin.y)
        
        // start of the label //
        var nameLabelForMe:UILabel = UILabel(frame: CGRectMake(meButtonLocation!.x, meButtonLocation!.y + 100, meButton!.frame.size.width, 30.0))
        nameLabelForMe.tag = 1001
        nameLabelForMe.text = currentUserName
        nameLabelForMe.textColor = UIColor.whiteColor()
        nameLabelForMe.textAlignment = .Center
        
        
        // creating the big circle in the center //
        mainBigCircle = MainBigCircle(mainView: self.view, radiusOfCircle: 100.0, location: CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y))
        
        
        // adding this to the subview //
        self.view.addSubview(nameLabelForMe)
        self.view.addSubview(meButton!)
        
        
        // creating the helper class for creating the profile pics //
        helperClass = HelperClassOfProfilePics(callingView: self.view,location:CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y), arrayPassedIn: emptyInitialArray, circleOfRadius:100.0)
        
        helperClass.delegate = self

    }
    
    
    
    
    // just a debugging string //
    func returnLocationData(locationString: String) {
        
        var alert:UIAlertController = UIAlertController(title: "update location", message: locationString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    // the push notification sector of gather info //
    func pushNotification(sender:NSNotification){
        
        //locationData.pushNotification()
        
    }
    
    
    
    
    
    // the user response to this users request to chat //
    func returnedUserResponseToChat(wantsToChatYesOrNo: Bool, user:AnyObject) {
        
        println("\n \n any user : \(user) \n \n ")
        
        // need to send the user to the chat page if the response is yes //
        // will need to come up with a pop up saying the other user doesnt //
        // want to chat at this time if the other chooses cancel //
        if(wantsToChatYesOrNo == false){
            
            // make a popup that tells the user that they didnt want to chat
            
        }else if(wantsToChatYesOrNo == true){
            
            let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
            
            
            
            // sending over the userClickedOn originally //
            chatViewController.personPassedIn = userClickedOn
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
            
        }
        
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
    
    
    
    // gets called when you click on a persons profile //
    func returnPersonClicked(person: AnyObject) {
        
        println("\n \n \n \n person clicked on \(person)\n \n \n \n \n ")

        self.showAlert()
        
        userClickedOn = person as PFUser
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
    
    
    
    // removing the view from NSNotification center called on by a push update //
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    
    
    
    
    // this is from the side bar delegate //
    func sideBarDidSelectAtIndex(index: Int) {
        
        // takes you the user to your personal settings //
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController

        aboutViewController.personsPic = "face_100x100.png"
        
        self.navigationController?.pushViewController(aboutViewController, animated: true)
        
    }
    

    
    
    
    
    
    // this gets called everytime there is an update from the GPS //
    // this brings back all the users in the area //
    func returnAllUsers(users:Array<AnyObject>){

        tempArrayPassedIn?.removeAll(keepCapacity: false)
        
        tempArrayPassedIn = users
        
        println("update in here \(tempArrayPassedIn)")
        
        // passes the users to the circle creator! //
        helperClass.updateProfilePics(tempArrayPassedIn!)
    
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
    
        println("clicked!")
        println("clicked button : \(personSelected)")
    }
    
    
    
    
    
    
    
    // this shows the alert giving the person the option to cancel, chat, or view profile //
    // about the person needs to change //
    func showAlert(){
        
        
            var modifiedAlertString:String?
        
        
            
            modifiedAlertString = "Do you wish to chat or view profile?"
            
        
        
            var alert:UIAlertController = UIAlertController(title: "What do you want to do?", message: modifiedAlertString , preferredStyle: UIAlertControllerStyle.Alert)
        
        
            // the profile alert button //
            alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
                // takes you the user to your personal settings //
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
                // setting the index number in the next view //
                aboutViewController.personsPic = self.userClickedOn.objectForKey("picture") as? String
                aboutViewController.personName = self.userClickedOn.objectForKey("username") as? String
                aboutViewController.personInterests = self.userClickedOn.objectForKey("interests") as? Array<String>
                aboutViewController.personAge = self.userClickedOn.objectForKey("age") as? Int
                aboutViewController.personGender = self.userClickedOn.objectForKey("gender") as? String
                
                // passing in the user PFUser //
                aboutViewController.userPassedIn = self.userClickedOn
                
                self.navigationController?.pushViewController(aboutViewController, animated: true)

            
            }))
        
    
        
        
        
        
        
            // should send out a notification to the other person asking if they want to chat or not //
            // the chat body //
            alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default, handler: {action in
            
                
                
                
                // basically needs to send over an alert saying that 'You' want to chat with them and //
                // the can either click ok or view profile //
                self.chatRequest.sendRequestToChat(self.userClickedOn, fromUser: PFUser.currentUser())
                
            
            
            }))
        
        
            // cancel button simply exits out and does nothing //
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    // ----- chat stuff ----- //
    
    // this is the return function from ChatRequest //
    // call back from when the user recieves a request to chat //
    func userClickedOnChatRequestAlert(userClickedOnChatRequest:Int, personalInfo:AnyObject) {
        
        println("anyobject : \(personalInfo.description)")
        
        // cancel //
        if(userClickedOnChatRequest == 0){
            
            println("logged in cancel")
            
            
            // tells the sender that its not ok to chat with this person //
            chatRequest.sendOutTheOkToChat(false, toUser:personalInfo)
            
            
            
            
        // view profile //
        }else if(userClickedOnChatRequest == 1){
            
            println("logged in view profile")
            
        // chat //
        }else{
            
            println("logged in chat")
            
            let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
            chatViewController.personPassedIn = personalInfo
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
            
            
            // need to send out a notification to the other user that they have accepted the request and //
            // should transition to the chat session //
            chatRequest.sendOutTheOkToChat(true, toUser: personalInfo)
            
            
        }
        
        
        
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    // the broadcast button //
    @IBAction func broadCastOnClick(sender: UIButton) {
        

        
        var currentUser = PFUser.currentUser()
        // this is the broadcast your location button //
        if(tempBoolToggleForBroadCast == false){
            
            self.navigationItem.rightBarButtonItem?.enabled = false
            
            broadCast.setTitle("Cancel Broadcast", forState: UIControlState.Normal)
            
        
            currentUser["signedIn"] = true
            currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if(success){
                    
                    var tempMajor = PFUser.currentUser().objectForKey("major") as Int
                    var tempMinor = PFUser.currentUser().objectForKey("minor") as Int
                    
                    
                    
                    
                    // calls on the updateLocations method which then updates //
                    // the return all users method //
                    //self.locationData.updateLocations(false)
                    self.beaconTransmitData.transmitBeacon(tempMajor, minorNumber: tempMinor)
                    self.beaconGatherData.initRegion()
                    
                    

                println("turn on broadcast")
                    
                }
            })

            tempBoolToggleForBroadCast = true
            
            
         // this is the cancel button //
        }else if(tempBoolToggleForBroadCast == true){
            
            self.navigationItem.rightBarButtonItem?.enabled = true
            
            broadCast.setTitle("See Whos Around You", forState: UIControlState.Normal)
            
            currentUser["signedIn"] = false
            currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if(success){

                    
                    
                    
                    
                    // calls on the updateLocations method //
                    //self.locationData.updateLocations(true)
                
                    
                    self.beaconTransmitData.stopTransmitting()
                    self.beaconGatherData.stopRecieving()
                    
                    
                    println("turn off broadcast")
  
                    
                    
                    
                    
                    
                }
            })

            //locationData.stopLocationServices()
            tempBoolToggleForBroadCast = false
        }
    }
    
    
    
    

    
    
    // setting colors for the view //
    func setColors(){
        
        self.navigationController?.navigationBar.hidden = false
    
        self.view.backgroundColor = colorPalette.lightBlueColor
        
        // colors for the buttons //
        broadCast.backgroundColor = colorPalette.greenColor
        broadCast.tintColor = colorPalette.whiteColor
        
    }
    
    
}
