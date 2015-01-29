//
//  LoggedIn.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse



class LoggedIn: UIViewController, SideBarDelegate,  ReturnWithPersonClicked, RequestChatDelegate, IBeaconInfo, UpdateObjectDelegate, UpdateTextDelegate, SetCurrentUserInfo{
    
    @IBOutlet weak var broadCast: UIButton!

    
    var currentUserName:String?
    var currentUserAge:Int?
    var currentUserGender:String?
    var currentUserPic:String?
    var currentUserInterests:Array<String>?
    

    
    var meButton:UIButton?
    var nameLabelForMe:UILabel?
    var meButtonLocation:CGPoint?
    var personSelected:Int?
    
    var tempBoolToggle:Bool = true
    var tempBoolToggleForBroadCast:Bool = false
    
    var helperClass:HelperClassOfProfilePics = HelperClassOfProfilePics()

    var colorPalette = ColorPalettes()
    var currentUser = PFUser.currentUser()
    var sideBar:SideBar  = SideBar()
    var userClickedOn:PFUser = PFUser()
    var chatRequest = ChatRequest()
    
    var beaconGatherData = IBeaconGatherData()
    var beaconTransmitData = IBeaconTransmitData()
    
    
    var mainBigCircle:MainBigCircle = MainBigCircle()
    
    var tempArrayPassedIn:Array<AnyObject>?
    

    var listOfFriends:[AnyObject] = []
    var listOfRequests:[AnyObject] = []
    var listOfChats:[NewChat] = []
    
    var inComingChatHelperClass:InComingText = InComingText()
    
    var tempArrayForHoldingJustUserData:Array<AnyObject> = []
    
    var emptyInitialArray:Array<AnyObject> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up the main profile image //
        var screenCenter:CGPoint = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        
        self.setColors()
        

        if(currentUser != nil){
            currentUser["signedIn"] = false
            currentUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                if(success){
                
                    println("\n \n user info --> \(PFUser.currentUser()) \n \n")
                    
                    println(PFUser.currentUser().objectForKey("picture"))
                    
                    
                    
                    println("success in saving")
                }
            })
        }
        
        
        
        
        // setting up the current user info //
        self.settingUpTheUserInfo()
        
        beaconGatherData.delegate = self
        
        //locationData.delegate = self
        chatRequest.delegate = self
    
        inComingChatHelperClass.delegate = self
        
        
        // ** when a push notification comes in this gets called ** //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushNotification:", name: "pushNotification", object: nil)
        
        
        
        // coming back into the forground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startBackUpServicesFromAppDelegate:", name: "startiBeacon", object: nil)
        
        
        
        var imageData:PFFile? = PFUser.currentUser().objectForKey("picture") as? PFFile
        if(imageData != nil){
            
            meButton = UIButton(frame: CGRectMake(screenCenter.x - 50 , screenCenter.y - 50, 100.0, 100.0))
            
            var fileName = imageData?.name
            if((fileName?.rangeOfString("face.png", options: nil, range: nil, locale: nil)) != nil){
                
                self.meButton!.setTitle("Start Here!", forState: UIControlState.Normal)
                self.meButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                self.meButton!.backgroundColor = UIColor.whiteColor()
                
                
            }else if(!((fileName?.rangeOfString("face.png", options: nil, range: nil, locale: nil)) != nil)){
                
                
                imageData!.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                    
                    if(data != nil){
                        
                        println("in here debug ")
                        var imageOfMe:UIImage = UIImage(data: data)!
                        
                        var flippedImage = UIImage(CGImage: imageOfMe.CGImage, scale: 1.5, orientation:.LeftMirrored)
                        
                        self.meButton!.setImage(flippedImage, forState: UIControlState.Normal)
                        self.meButton!.setImage(flippedImage, forState: UIControlState.Highlighted)
                    }
                })
            }
            
        // if the picture contains no data what so ever //
        }else{
            
            self.meButton!.setTitle("Start Here!", forState: UIControlState.Normal)
            self.meButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.meButton!.backgroundColor = UIColor.whiteColor()
            
        }

        
            meButton!.layer.cornerRadius = 50
            meButton!.layer.borderWidth = 3.0
            meButton!.layer.borderColor = UIColor.blackColor().CGColor
            meButton!.clipsToBounds = true
            meButton!.tag = 1001
            meButton!.addTarget(self, action: Selector("meClickedOn:"), forControlEvents: UIControlEvents.TouchUpInside)
        

            // the current location of meButton //
            meButtonLocation = CGPoint(x: meButton!.frame.origin.x, y: meButton!.frame.origin.y)
        
            // start of the label //
            nameLabelForMe = UILabel(frame: CGRectMake(meButtonLocation!.x, meButtonLocation!.y + 100, meButton!.frame.size.width, 30.0))
            nameLabelForMe!.tag = 1001
            nameLabelForMe!.textColor = UIColor.whiteColor()
            nameLabelForMe!.textAlignment = .Center
            nameLabelForMe!.text = PFUser.currentUser().username
        
            // creating the big circle in the center //
            mainBigCircle = MainBigCircle(mainView: self.view, radiusOfCircle: 100.0, location: CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y))
        
            
            // adding this to the subview //
            self.view.addSubview(nameLabelForMe!)
            self.view.addSubview(meButton!)
        
        
        // creating the helper class for creating the profile pics //
        helperClass = HelperClassOfProfilePics(callingView: self.view,location:CGPoint(x: meButtonLocation!.x, y: meButtonLocation!.y), arrayPassedIn: emptyInitialArray, circleOfRadius:100.0)
        
        helperClass.delegate = self
        

    }
    
    
    func meClickedOn(sender:UIButton){
        
        // takes you the user to your personal settings //
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
        
        //aboutViewController.personsPic = "face_100x100.png"
        aboutViewController.userPassedIn = PFUser.currentUser()
        aboutViewController.cameFromMainUser = true
        
        
        // this is the main user view for the about view controller //
        // I need to be passing in the entire list of people available so I can send notifications to those //
        // to update their list of people after this person is done updating their profile //
        
        aboutViewController.passedInArrayOfUsers = tempArrayPassedIn
        
        aboutViewController.delegate = self
                
        self.navigationController?.pushViewController(aboutViewController, animated: true)
        
    }
    
    
    
    
    func updateCurrentUserInfo(userName: String, userPicture: UIImage) {
        
        println("called in here")
        
        //meButton!.setImage(UIImage(named: userPicture), forState: UIControlState.Normal)
        meButton!.setImage(userPicture, forState: UIControlState.Normal)
        meButton!.setImage(userPicture, forState: UIControlState.Highlighted)
        
        
    }
    
    
    
    
    

    
    
    
    
    func startBackUpServicesFromAppDelegate(notification:NSNotification){
        
        println("called each time the view comes back ")
        
        //self.loadDefaults()
        
        println("start up services again")
        
        if(tempBoolToggleForBroadCast == true){
            
            println("you are still on")
            
            beaconGatherData.initRegion()
            
        }else{
            
            println("you are off")
            
        }
    }
    
    
    
    
    // just a debugging string //
    func returnLocationData(locationString: String) {
        
        var alert:UIAlertController = UIAlertController(title: "update location", message: locationString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    

    
    
    
    
    // the user response to this users request to chat //
    func returnedUserResponseToChat(wantsToChatYesOrNo: Bool, user:AnyObject) {
        
        println("\n \n any user : \(user) \n \n ")
        
        
        // need to send the user to the chat page if the response is yes //
        // will need to come up with a pop up saying the other user doesnt //
        // want to chat at this time if the other chooses cancel //
        if(wantsToChatYesOrNo == false){
            
            // make a popup that tells the user that they didnt want to chat
            
            var alert:UIAlertController = UIAlertController(title: "User does not want to chat right now", message: "Denied Chat!" , preferredStyle: UIAlertControllerStyle.Alert)
            
            // cancel button simply exits out and does nothing //
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }else if(wantsToChatYesOrNo == true){
            
            println("in here! ith!!!!!!")

            let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
            chatViewController.delegate = self
            
            
            
            
            
            
            // for the list view //
            var userInfo = ["userInfo":tempArrayPassedIn!]
            
            chatViewController.updateFromRestOfApp(userInfo)
            
            
            println("user returned! \(user.description)")
            
            var userInfoObject:AnyObject? = user.valueForKey("userInfo")
            if(userInfoObject != nil){
                
                
                
                
                // I can now make a new chat object and add it to the list of chats //
                var newChat:NewChat = NewChat(personPassedIn: userInfoObject!)
                
                self.listOfChats.append(newChat)
                
                // need to load up the inComingChatHelperClass with all the chat objects //
                inComingChatHelperClass.updateListOfChats(listOfChats)

                self.convertChatListToStringForListView()
                

            }
            
        }
        
    }
    
    
    
    
    // this converts the list of chats object to a string for the list view //
    func convertChatListToStringForListView(){
        
        for(var i = 0; i < self.listOfChats.count; i++){
            
            if(!(self.tempArrayForHoldingJustUserData as NSArray).containsObject(self.listOfChats[i].returnLabelForListOfChats())){
                
                
                // getting the chat info back to make the label for the list view //
                self.tempArrayForHoldingJustUserData.append(self.listOfChats[i].returnLabelForListOfChats())
                
            }
        }
        
        if(self.tempArrayForHoldingJustUserData.count != 0){
            
            self.sideBar.updateChatData(self.tempArrayForHoldingJustUserData)
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
        
        println("im now in here!")
        
        println("\n \n \n \n person clicked on \(person)\n \n \n \n \n ")

        self.showAlert()
        
        userClickedOn = person.firstObject as PFUser
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // making sure the view has loaded before setting the side bar... //
    // before it was showing up as you transitioned from the sign in screen to this one //
    override func viewDidAppear(animated: Bool) {
        
        println("this is getting called")
        
        // loads the default settings for friends, requests and chat items //
        //self.loadDefaults()
        
        sideBar = SideBar(callingView: self.view, friends: listOfFriends, requests:listOfRequests, fromLoggedInView:true)
        
        sideBar.updateRequests(listOfRequests)
        sideBar.updateFriends(listOfFriends)
        sideBar.updateChatData(self.tempArrayForHoldingJustUserData)
        sideBar.delegate = self
        
    }
    
    
    
    

    
    // dismisses the sidebar //
    override func viewDidDisappear(animated: Bool) {
        sideBar.fromFriendsButton(false)
        
        tempBoolToggle = true
        
        
    }
    
    
    func saveListItems(){
        
        NSUserDefaults.standardUserDefaults().setObject(listOfFriends, forKey: "friendsList")
        
        NSUserDefaults.standardUserDefaults().setObject(listOfRequests, forKey: "requestsList")
        
        //NSUserDefaults.standardUserDefaults().setObject(listOfChats as Array<NewChat>, forKey: "chatList")
    }
    
    // used for loading the friends, requests, and chat items in the friends tab //
    func loadDefaults(){
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("friendsList") != nil){
            
            println("friendsList exists")
            println(NSUserDefaults.standardUserDefaults().objectForKey("friendsList"))
            
            listOfFriends = NSUserDefaults.standardUserDefaults().objectForKey("friendsList") as Array<AnyObject>
            sideBar.updateFriends(listOfFriends)
            
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("requestsList") != nil){
            
            println("requests lists exists")
            println(NSUserDefaults.standardUserDefaults().objectForKey("requestsList"))
            
            listOfRequests = NSUserDefaults.standardUserDefaults().objectForKey("requestsList") as Array<AnyObject>
            sideBar.updateRequests(listOfRequests)
            
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("chatList") != nil){
            
            println("chat list exists")
            println(NSUserDefaults.standardUserDefaults().objectForKey("chatList"))
            
            self.tempArrayForHoldingJustUserData = NSUserDefaults.standardUserDefaults().objectForKey("chatList") as Array
            
            sideBar.updateChatData(self.tempArrayForHoldingJustUserData)
        }
    }
    
    
    
    // removing the view from NSNotification center called on by a push update //
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        println("in here.  Reloading")
        

    }
    
    
    
    
    
    
    
    // ------------ work on once the add friends request is all set up --------------- //
    // request to delete the user at a specific index //
    func sideBarFriendsDidDelete(indexPath: Int) {
        
        listOfFriends.removeAtIndex(indexPath)
        sideBar.updateFriends(listOfFriends)
    }
    
    
    
    
    
    
    
    
    
    // request to delete the user at a specific index //
    func sideBarRequestDidDelete(indexPath: Int) {
    
        println("need to ask the user if they really want to delete from the list")
        println("if so, then delete it")
        
        var alert:UIAlertController = UIAlertController(title: "Do you really want to Delete?", message: "" , preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // the profile alert button //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
            // delete the user in here //
            // need to send back to the original user that a request to chat was denied //
            self.approvalOrDenialOfChat(self.listOfRequests[indexPath], approval: false, group:false)
            
            self.listOfRequests.removeAtIndex(indexPath)
            self.sideBar.updateRequests(self.listOfRequests)
            
            
        }))
        // cancel button simply exits out and does nothing //
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    func sideBarDidDeleteChat(indexPath: Int) {
        
        self.listOfChats[indexPath].removeEntireConversation()
        
        self.listOfChats.removeAtIndex(indexPath)
        
        inComingChatHelperClass.updateListOfChats(listOfChats)
        
        self.tempArrayForHoldingJustUserData.removeAtIndex(indexPath)
        self.sideBar.updateChatData(self.tempArrayForHoldingJustUserData)
        
    }
    
    
    
    
    // this is from the side bar delegate //
    // the person that is clicked on information //
    func sideBarDidSelectAtIndex(index: Int, sectionOfSelection:Int) {
        
        println("in here \(index) , and \(sectionOfSelection)")
        
        // pulling from the friends array
        if(sectionOfSelection == 0){
            
            println("friends \(listOfFriends[index])")
            self.alertForSideBarSelect(listOfFriends[index], index:index, section:sectionOfSelection)
            
        // pulling from the requests array //
        }else if(sectionOfSelection == 1){
            
            println("request \(listOfRequests[index])")
            self.alertForSideBarSelect(listOfRequests[index], index:index, section:sectionOfSelection)
            
        }else if(sectionOfSelection == 2){
            
            // should send the person straight into chat with this person //
            let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
            // starting up the chat view controller with new info //
            chatViewController.delegate = self
            
            chatViewController.indexNumber = index
            
            // sending over the stored conversation //
            chatViewController.mainChatObject = listOfChats[index]
            
            
            
            
            
            
            
            // for the list view o
            var userInfo = ["userInfo":tempArrayPassedIn!]
            
            chatViewController.updateFromRestOfApp(userInfo)
            
            
            
            
            
            //chatViewController.listOfOtherPeopleToGroupWith
            
            // the helper class for delegating in coming chats //
            inComingChatHelperClass.updateListOfChats(listOfChats)
            
            chatViewController.passedInMessages = listOfChats[index].totalMessages
            
            self.navigationController?.pushViewController(chatViewController, animated: true)

        }
        
        println("index returned \(index)")
        println("selected section \(sectionOfSelection)")
        
        
    }
    
    
    
    // updating the chat object //
    func updateChatObject(object: AnyObject, atIndex: Int) ->Array<AnyObject>{
        

        // appending the incoming dictionary to the original object
        listOfChats[atIndex].totalMessages.append(object)
        
        println("list of chats --> \(listOfChats[atIndex].totalMessages)")
        
        return listOfChats[atIndex].totalMessages
        
        
    
    }
    
    
    
    
    
    
    
    // from the InComingText class //
    func updateChatObjectFromNewChatHelperClass(object:AnyObject, index:Int){
        
        // appending the incoming dictionary to the original object
        //listOfChats[index].totalMessages.append(object)
        
        listOfChats[index].totalMessages.append(object)
        
        println("list of chats .... --> \(listOfChats[index].totalMessages)")
        
        var tempUserInfoDictionary = ["userInfo":listOfChats[index].totalMessages, "userPassedIn":listOfChats[index].personsPassedIn]
        
        // need to send out a message to the list view that it should update //
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("updateTableView", object:self, userInfo:tempUserInfoDictionary)
        

    }
    
    
    
    
    
    
    
    
    func alertForSideBarSelect(passedInPerson:AnyObject, index:Int, section:Int){
        
        println("person passed into this thing --> \(passedInPerson.description)")
        
        
        println("this gets called ")
        
        var alert:UIAlertController = UIAlertController(title: "What do you want to do?", message: "" , preferredStyle: UIAlertControllerStyle.Alert)
    
        // the profile alert button //
        alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default, handler: { action in
            
        
            // start chatting and send over the ok to chat //
            self.approvalOrDenialOfChat(passedInPerson, approval: true, group:false)

            if(section == 1){
            
                // creating a new chat object //
                var newChat:NewChat = NewChat(personPassedIn: passedInPerson)
            
                println("Person passed in !!!!\(passedInPerson)")
            
            
                // adding the newly created object to the list //
                self.listOfChats.append(newChat)
                
                // the helper class for delegating in coming chats //
                self.inComingChatHelperClass.updateListOfChats(self.listOfChats)
                
                // removing it from the updateRequest array //
                self.listOfRequests.removeAtIndex(index)
                self.sideBar.updateRequests(self.listOfRequests)
                
                self.convertChatListToStringForListView()

            }

            

            
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
            println("under the profile info =--> \(passedInPerson.description)")
            
            // look at their profile //
            
            // takes you the user to your personal settings //
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController

            aboutViewController.personsPic = "face_100x100.png"

            aboutViewController.personPassedInNotPFUser = passedInPerson
            aboutViewController.cameFromMainUser = false
            
            self.navigationController?.pushViewController(aboutViewController, animated: true)
            
            
            
            
        }))
        // cancel button simply exits out and does nothing //
        alert.addAction(UIAlertAction(title: "Keep in Requests", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    

    
    
    
    
    
    // this gets called everytime there is an update from the GPS //
    // this brings back all the users in the area //
    func returnAllUsers(users:Array<AnyObject>){

        tempArrayPassedIn?.removeAll(keepCapacity: false)
        
        tempArrayPassedIn = users
        
        //println("\n \n update in here \(tempArrayPassedIn?)\n \n")
        //println("\n \n super temp array \(superTempArray?)")
        

        // passes the users to the circle creator! //
        helperClass.updateProfilePics(tempArrayPassedIn!)
        
        var userInfo = ["userInfo":tempArrayPassedIn!]
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("updateOfPeople", object:self, userInfo:userInfo)

        
        // making sure that if the side bar is out, that it will alway be on top //
        sideBar.keepingTheTabBarOutFront()
        
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
    func showAlert(){
        
        
            var modifiedAlertString:String?
    
            modifiedAlertString = "Do you wish to chat or view profile?"
            
        
            var alert:UIAlertController = UIAlertController(title: "What do you want to do?", message: modifiedAlertString , preferredStyle: UIAlertControllerStyle.Alert)
        
        
            // the profile alert button //
            alert.addAction(UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default, handler: { action in
            
            
                // takes you the user to your personal settings //
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
                
                // passing in the user PFUser //
                aboutViewController.userPassedIn = self.userClickedOn
                aboutViewController.cameFromMainUser = false
                
                self.navigationController?.pushViewController(aboutViewController, animated: true)

            
            }))
            
        
        
        
    
        
        
        
        
        
            // should send out a notification to the other person asking if they want to chat or not //
            // the chat body //
            alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.Default, handler: {action in

            
            
                // setting up a dictionary of all the info to send over //
                var currentUserDictionary = ["objectId":PFUser.currentUser().objectId,
                    "age":PFUser.currentUser().objectForKey("age")!,
                    "gender":PFUser.currentUser().objectForKey("gender")!,
                    "interests":PFUser.currentUser().objectForKey("interests")!,
                    "picture":PFUser.currentUser().objectForKey("picture")!,
                    "username":PFUser.currentUser().objectForKey("username")!]
                

                // basically needs to send over an alert saying that 'You' want to chat with them and //
                // the can either click ok or view profile //
                //self.chatRequest.sendRequestToChat(self.userClickedOn, fromUser: PFUser.currentUser())
                //var dataSend = ["request":true, "person": self.userClickedOn.username]
                var dataSend = ["userInfo": currentUserDictionary, "request":true]
                
                var query:PFQuery = PFInstallation.query()
                query.whereKey("user", equalTo: self.userClickedOn)
                
                var push:PFPush = PFPush()
                push.setQuery(query)
                push.setData(dataSend)
                //push.setMessage("RequestToChat")
                push.sendPushInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    
                    if(success == true){
                        
                        println("success!")
                        
                    }else{
                        
                        println("error")
                    }
                })
                
            }))
        
        
            // cancel button simply exits out and does nothing //
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    // ----- chat stuff ----- //
    
    // this is the return function from ChatRequest //
    // call back from when the user recieves a request to chat //
    func userClickedOnChatRequestAlert(userClickedOnChatRequest:Int, personalInfo:AnyObject,fromGroup:Bool) {
        
        var objectId:AnyObject?
        var firstObject:AnyObject?
        
        if(personalInfo.objectForKey("userInfo") != nil){
            
            firstObject = personalInfo.objectForKey("userInfo")
            
            if(firstObject?.objectForKey("objectId") != nil){
                
                objectId = firstObject?.objectForKey("objectId")!
                
                println("object id -- > \(objectId!)")
                
            }
        }
        
        
        // regular chat //
        if(fromGroup == false){
            // cancel //
            if(userClickedOnChatRequest == 0){
            
                println("logged in cancel")

                // sending out the denial of chat //
                self.approvalOrDenialOfChat(personalInfo, approval: false, group:false)
            
            
                // view profile //
            }else if(userClickedOnChatRequest == 1){
            
                println("logged in view profile")
                println("in here and stuff!!!!!!!!!!!!! --> \(personalInfo.description)")
            
            
                // should send the user to the profile view //
                // takes you the user to your personal settings //
                let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutPerson") as AboutThePersonViewController
            
                aboutViewController.personPassedInNotPFUser = personalInfo
                aboutViewController.cameFromMainUser = false
            
                println("description of person passed in \(personalInfo.description)")
            
                self.navigationController?.pushViewController(aboutViewController, animated: true)
            
            
            
            
            

                // save for later //
            }else if(userClickedOnChatRequest == 3){
            
                // seeing if the incoming object has already been added //
                // and if not, then add it //
                if(!(listOfRequests as NSArray).containsObject(personalInfo)){
                
                    println("does not contain the object")
                    listOfRequests.append(personalInfo)
                }

                // refreshing the list view //
                sideBar.updateRequests(listOfRequests)

                // chat //
            }else{
            
                // sending out the approval to chat //
                self.approvalOrDenialOfChat(personalInfo, approval: true, group: false)
            
                println("in here finally....")
            
                println("personal info --> \(personalInfo.description)")
            
            
                // creating a new chat object //
                var newChat:NewChat = NewChat(personPassedIn: personalInfo)
            
        
                // adding the newly created object to the list //
                self.listOfChats.append(newChat)
            
                // the helper class for delegating in coming chats //
                inComingChatHelperClass.updateListOfChats(listOfChats)
            
                self.convertChatListToStringForListView()
            

            
            
                // should send the person straight into chat with this person //
                let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
                // starting up the chat view controller with new info //
                chatViewController.delegate = self
            
                var tempIndex:Int?
            
                // getting the newly added chat object index within the listOfChats //
                for(var i = 0; i < listOfChats.count; i++){
                
                    if(listOfChats[i].isEqual(newChat)){
                    
                        println("index \(i)")
                        tempIndex = i
                    }
                
                }
            
            
            
            
                // for the list view o
                var userInfo = ["userInfo":tempArrayPassedIn!]
            
                chatViewController.updateFromRestOfApp(userInfo)

                chatViewController.indexNumber = tempIndex!
            
                // sending over the stored conversation //
                chatViewController.mainChatObject = listOfChats[tempIndex!]
            
                chatViewController.passedInMessages = listOfChats[tempIndex!].totalMessages
            
                self.navigationController?.pushViewController(chatViewController, animated: true)
   
            }
            
        // for group chat //
        }else{
            
            
            
            
            println("\n\n--------- group info -----> \(personalInfo)")
            
            // cancel //
            if(userClickedOnChatRequest == 0){
                
                println("logged in cancel")
                
                // sending out the denial of chat //
                self.approvalOrDenialOfChat(personalInfo, approval: false, group: true)
                
                
                
            // chat button //
            }else if(userClickedOnChatRequest == 1){
                
                
                
                // this is going to be slightly different than normal chat in //
                // that the person sending out the request will stay in their //
                // current view and add the person to their chat //
                // sending out the approval to chat //
                self.approvalOrDenialOfChat(personalInfo, approval: true, group: true)
                
                
                
                // creating a new chat object //
                // personal Info contains everything //
                // you info plus the object id's and names overyone //
                // involved //
                var newChat:NewChat = NewChat(personPassedIn: personalInfo)
                
                
                // adding the newly created object to the list //
                self.listOfChats.append(newChat)
                
                
                
                // the helper class for delegating in coming chats //
                inComingChatHelperClass.updateListOfChats(listOfChats)
                
                self.convertChatListToStringForListView()
                
                
                // should send the person straight into chat with this person //
                let chatViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
                
                // starting up the chat view controller with new info //
                chatViewController.delegate = self
                
                var tempIndex:Int?
                
                // getting the newly added chat object index within the listOfChats //
                for(var i = 0; i < listOfChats.count; i++){
                    
                    if(listOfChats[i].isEqual(newChat)){
                        
                        println("index \(i)")
                        tempIndex = i
                    }
                    
                }
                
                
                
                
                // for the list view o
                var userInfo = ["userInfo":tempArrayPassedIn!]
                
                chatViewController.updateFromRestOfApp(userInfo)
                
                
                
                
                chatViewController.indexNumber = tempIndex!
                
                
                
                
                
                
                // sending over the stored conversation //
                chatViewController.mainChatObject = listOfChats[tempIndex!]
                
                chatViewController.passedInMessages = listOfChats[tempIndex!].totalMessages
                
                self.navigationController?.pushViewController(chatViewController, animated: true)
                
                
                
                
            // respond later //
            }else{
                
                
                // seeing if the incoming object has already been added //
                // and if not, then add it //
                if(!(listOfRequests as NSArray).containsObject(personalInfo)){
                    
                    println("does not contain the object")
                    listOfRequests.append(personalInfo)
                }
                
                // refreshing the list view //
                sideBar.updateRequests(listOfRequests)
                
                
            }
        }
    }
    
    
    

    
    
    
    
    







    // handles the sending out of the actual push notification //
    func approvalOrDenialOfChat(toUser:AnyObject, approval:Bool, group:Bool){
        
        var objectId:AnyObject?
        var firstObject:AnyObject?
        
        if(toUser.objectForKey("userInfo") != nil){
            
            firstObject = toUser.objectForKey("userInfo")
            
            if(firstObject?.objectForKey("objectId") != nil){
                
                objectId = firstObject?.objectForKey("objectId")!
                
                println("object id -- > \(objectId!)")
                
            }
        }else{
            
            println("different data set coming in ")
        }
        
        
        
        // only if its approved do you move to the chat view //
        if(approval == true){
            
            println("logged in chat")
            
            

        }
        
            // sending out the approval or denial of chat request //
            
            // setting up a dictionary of all the info to send over //
            var currentUserDictionary = ["objectId":PFUser.currentUser().objectId,
                "age":PFUser.currentUser().objectForKey("age")!,
                "gender":PFUser.currentUser().objectForKey("gender")!,
                "interests":PFUser.currentUser().objectForKey("interests")!,
                "picture":PFUser.currentUser().objectForKey("picture")!,
                "username":PFUser.currentUser().objectForKey("username")!]
            

            var dataSend = ["userInfo": currentUserDictionary, "responseToRequest":approval, "group":group]
            
            var query:PFQuery = PFUser.query()
            query.whereKey("objectId", equalTo: objectId!)
            query.whereKey("signedIn", equalTo: true)
            
            
            var pushQuery:PFQuery = PFInstallation.query()
            pushQuery.whereKeyExists("user")
            pushQuery.whereKey("user", matchesQuery: query)
            
            
            var push:PFPush = PFPush()
            push.setQuery(pushQuery)
            push.setData(dataSend)
            push.sendPushInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                
                if(success == true){
                    
                    println("success!")
                    
                }else{
                    
                    println("error")
                }
            })
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
                    self.beaconGatherData.initRegion()
                    self.beaconTransmitData.transmitBeacon(tempMajor, minorNumber: tempMinor)
                    
                    
                    

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
