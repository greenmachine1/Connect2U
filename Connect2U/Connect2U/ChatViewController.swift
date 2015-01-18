//
//  ChatViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,SideBarDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    
    var mainInputField:UITextField?
    var mainReturnButton:UIButton?
    
    var personPassedIn:AnyObject?
    var personNameChattingWith:PFUser?
    
    var otherPersonId:AnyObject?
    var personId:AnyObject?
    var personName:String?
    
    var tempBoolToggle:Bool = true

    var mainArrayFullOfConversation:[AnyObject]?
    
    var arrayOfOtherPeoplePassedInForGroupingUpWith:AnyObject?
    var finalArrayOfPeoplePassedInMinusYouMinusPerson:Array<AnyObject> = []
    
    var sideBar:SideBar = SideBar()
    
    var listOfFriends:[String] = ["Grant", "Mark", "Joe", "Brittany"]
    var listOfRequests:[String] = ["Joe", "David", "Steve", "Berry"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainArrayFullOfConversation = []

        self.setColors()

        mainTableView.delegate = self
        
        
        // for some reason, I was getting no interaction what so ever from my //
        // UITableView... this fixed it //
        self.mainTableView.userInteractionEnabled = true
        
        println("\n \n person passed in \(personPassedIn?.description)")
        
        println("Everyone passed in --> \(arrayOfOtherPeoplePassedInForGroupingUpWith)")
        
        
        

        
        if(personPassedIn != nil){
            
            println("in here --> not sure whats going on!")
            
            if(personPassedIn!.valueForKey("userInfo") != nil){
                
                var personPassed: AnyObject? = personPassedIn!.valueForKey("userInfo")
                
                if(personPassedIn != nil){
                    
                    var secondLevel: AnyObject? = personPassed?.objectForKey("userInfo")
                    if(secondLevel != nil){
                
                        personName = secondLevel!.valueForKey("username") as? String
                        personId = secondLevel!.valueForKey("objectId")
                    
                    }else{

                        personName = personPassed!.valueForKey("username") as? String
                        personId = personPassed!.valueForKey("objectId")
                        
                        
                    }
                }
            }
        }
        
        // making a new array of people to group with minus you and minus the person //
        // currently chatting with //
        self.removalOfOtherPersonFromArray(arrayOfOtherPeoplePassedInForGroupingUpWith!)
        
        
        
    
        // group chat button //
        var editButton:UIBarButtonItem = UIBarButtonItem(title: "Group Chat", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("group"))
        self.navigationItem.rightBarButtonItem = editButton
        
        

        var widthOfScreen:CGFloat = CGFloat(self.view.frame.width / 2)
        
        // this is all static data that will be updated at a later time //
        mainInputField = UITextField(frame: CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 50.0), width: self.view.frame.width - 120 , height: 30.0))
        
        
        mainInputField?.borderStyle = UITextBorderStyle.RoundedRect
        mainInputField?.text = "Enter Text"
        mainInputField?.backgroundColor = UIColor.whiteColor()
        
        mainInputField?.delegate = self
        
        self.view.addSubview(mainInputField!)
        
        
        // value for x for the return button //
        var sendButtonXValue:CGFloat = CGFloat(self.mainInputField!.frame.origin.x + self.mainInputField!.frame.width + 10.0)
        
        mainReturnButton = UIButton(frame: CGRect(x: sendButtonXValue, y: CGFloat(self.view.frame.height - 50.0), width: 100.0, height: 30.0))

        mainReturnButton?.setTitle("Send", forState: UIControlState.Normal)
        mainReturnButton?.addTarget(self, action: Selector("mainReturn"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(mainReturnButton!)
        
        
        
        
        
        
        // notification for showing the keyboard //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShow"), name: UIKeyboardWillShowNotification, object: nil)
        
        // ** when a push notification comes in this gets called ** //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textMessageRecieved:", name: "textMessage", object:nil)
    
        
    }
    
    
    
    
    
    func removalOfOtherPersonFromArray(arrayPassedIn:AnyObject){
        
        finalArrayOfPeoplePassedInMinusYouMinusPerson = arrayPassedIn as Array
        
        println("array passed in --> \(arrayPassedIn) and the id of the person you are chatting with -->\(personId)")
        
        for(var i = 0; i < arrayPassedIn.count; i++){
            
            var objectId:AnyObject? = arrayPassedIn.valueForKey("objectId")
            if(objectId != nil){
                
                if((objectId?.isEqual(personId)) != nil){
                    
                    println("they are the same")
                    
                    finalArrayOfPeoplePassedInMinusYouMinusPerson.removeAtIndex(i)
                
                }
            }
            
        }
        
        println("new array --> \(finalArrayOfPeoplePassedInMinusYouMinusPerson)")
    }
    
    
    
    
    
    
    func updateTheUsersForGroup(peoplePassedIn:AnyObject){
        
        self.removalOfOtherPersonFromArray(peoplePassedIn)
        
    }
    
    
    
    
    
    
    
    
    func textMessageRecieved(object:NSNotification){
        
        println("recieved text message and im in the sendTextMessage object : \(object.description)")
        self.sendTextInfoBack(object)
        
    }
    
    
    
    
    // ----- where texts come back -----  //
    // putting the info into a dictionary, then into an array //
    func sendTextInfoBack(textInfo: AnyObject) {
        
        println("this info is in the chat view controller \(textInfo.description)")
        
        var incomingPersonText:String? = ""
        var incomingPersonId:String? = ""
        
        
        if(!(textInfo.isEqual(nil))){
        
            var firstLevel:AnyObject? = textInfo.valueForKey("userInfo")?
            
            if(firstLevel != nil){
                println("first level \(firstLevel?)")
                
                var secondLevel:AnyObject? = firstLevel!.valueForKey("message")
                if(secondLevel != nil){
                    
                    var message:String = secondLevel! as String
                    
                    println("message --> \(message)")
                    incomingPersonText = secondLevel! as? String
                    
                    var objectIdLevel:AnyObject? = firstLevel!.valueForKey("userInfo")
                    if(objectIdLevel != nil){
                        println("in here!")
                        
                        println(objectIdLevel)
                        var objectId:AnyObject? = objectIdLevel?.valueForKey("objectId")
                        println(objectId)
                        
                        incomingPersonId = objectIdLevel!.valueForKey("objectId") as? String
                    }
                    
                }
                
            }
            
            println("this and that \(incomingPersonText!)")
            
            
            var tempDictionary:[String:String] = [incomingPersonId! as String:incomingPersonText! as String]
            println(tempDictionary)
            
            mainArrayFullOfConversation?.append(tempDictionary)
            if(mainArrayFullOfConversation != nil){
                
                println(mainArrayFullOfConversation!)
                
                mainTableView.reloadData()
                
                if mainTableView.contentSize.height > mainTableView.frame.size.height
                {
                    let offset = CGPoint(x: 0, y: mainTableView.contentSize.height - mainTableView.frame.size.height)
                    mainTableView.setContentOffset(offset, animated: false)
                }
            }
            

            
            
        }
        
    }
    
    // dismisses the sidebar //
    override func viewDidDisappear(animated: Bool) {
        sideBar.fromFriendsButton(false)
        
        tempBoolToggle = true
    }
    
    
    // initializing the side bar //
    override func viewWillAppear(animated: Bool) {
        
        sideBar = SideBar(callingView: self.view, friends: listOfFriends, requests:Array<String>(), fromLoggedInView:false)
        
        sideBar.delegate = self
        
    }
    
    func sideBarDidSelectAtIndex(index:Int){
        
        println("index number selected \(index)")
        
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
    
    

    func group(){
        
        if(tempBoolToggle == false){
            
            sideBar.fromFriendsButton(false)
            
            self.tempBoolToggle = true
            
        }else if(tempBoolToggle == true){
            
            sideBar.fromFriendsButton(true)
            
            self.tempBoolToggle = false
        }
        
    }
    

    
    
    // moving the textfield up for the keyboard //
    func keyboardShow(){
        
        mainInputField?.frame = CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 320.0), width: self.view.frame.width - 120, height: 30.0)
    
        // 320
        var sendButtonXValue:CGFloat = CGFloat(self.mainInputField!.frame.origin.x + self.mainInputField!.frame.width + 10.0)
        
        mainReturnButton?.frame = CGRect(x: sendButtonXValue, y: CGFloat(self.mainInputField!.frame.origin.y), width: 100.0, height: 30.0)
    }
    
    
    
    
    
    
    
    
    
    // send off the text //
    func mainReturn(){

        var tempDictionary:[String:String] = [PFUser.currentUser().objectId as String: mainInputField!.text]
        
        mainArrayFullOfConversation?.append(tempDictionary)
        

        // sending out a text message to the other user //
        self.sendTextMessage(mainInputField!.text, toUser: self.personId!)
        
        
        
        if(mainArrayFullOfConversation != nil){
            
            mainTableView.reloadData()
            
            if mainTableView.contentSize.height > mainTableView.frame.size.height
            {
                let offset = CGPoint(x: 0, y: mainTableView.contentSize.height - mainTableView.frame.size.height)
                mainTableView.setContentOffset(offset, animated: false)
            }
            
            
        }
        
    }
    
    
    func sendTextMessage(text:String, toUser:AnyObject){
        
        // setting up a dictionary of all the info to send over //
        var currentUserDictionary = ["objectId":PFUser.currentUser().objectId,
            "age":PFUser.currentUser().objectForKey("age")!,
            "gender":PFUser.currentUser().objectForKey("gender")!,
            "interests":PFUser.currentUser().objectForKey("interests")!,
            "picture":PFUser.currentUser().objectForKey("picture")!,
            "username":PFUser.currentUser().objectForKey("username")!]
        
        
        
        
        
        
        // basically needs to send over an alert saying that 'You' want to chat with them and //
        // the can either click ok or view profile //
        var dataSend = ["userInfo": currentUserDictionary, "text":true, "message": text]
        
        var query:PFQuery = PFUser.query()
        query.whereKey("objectId", equalTo: toUser)
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
    
    
    
    
    
    
    
    
    
    
    // the return key //
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        
        println("in here")
        
        mainInputField?.resignFirstResponder()
        
        // moving the keyboard back down.... statically //
        mainInputField?.frame = CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 50.0), width: self.view.frame.width - 120 , height: 30.0)
        
        // 320
        var sendButtonXValue:CGFloat = CGFloat(self.mainInputField!.frame.origin.x + self.mainInputField!.frame.width + 10.0)
        
        mainReturnButton?.frame = CGRect(x: sendButtonXValue, y: CGFloat(self.view.frame.height - 50.0), width: 100.0, height: 30.0)
        
        return true
        
    }
    

    

    // what will be in each row //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        
        
        // pin pointing if the text came from this user or someone else
        if(mainArrayFullOfConversation![indexPath.row].valueForKey(PFUser.currentUser().objectId as String) != nil){
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellRight", forIndexPath: indexPath) as RightChatCell
            
            println(mainArrayFullOfConversation![indexPath.row].objectForKey(PFUser.currentUser().objectId) as? String)
            
            
            cell.backgroundColor = darkGreenColor
            cell.layer.cornerRadius = 3.0
            cell.rightLabel.text = "You"
            cell.rightLabel.textColor = whiteColor
            cell.rightLabel.backgroundColor = darkGreenColor
            cell.rightLabel.layer.cornerRadius = 3.0
            cell.rightLabel.clipsToBounds = true
            cell.dataLabel.textColor = whiteColor
            cell.dataLabel.backgroundColor = darkGreenColor
            cell.dataLabel.text = mainArrayFullOfConversation![indexPath.row].objectForKey(PFUser.currentUser().objectId) as? String
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            
            
            
            return cell
            
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellLeft", forIndexPath: indexPath) as ChatLeftCell
            
            
            
            cell.backgroundColor = greenColor
            cell.layer.cornerRadius = 3.0
            cell.leftLabel.text = personName
            cell.leftLabel.textColor = darkGreenColor
            cell.leftLabel.backgroundColor = greenColor
            cell.leftLabel.layer.cornerRadius = 3.0
            cell.leftLabel.clipsToBounds = true
            cell.dataLabel.textColor = darkGreenColor
            cell.dataLabel.backgroundColor = greenColor
            cell.dataLabel.text = mainArrayFullOfConversation![indexPath.row].objectForKey(personId) as? String
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            
            
            
            return cell
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        

    }

    
    
    // number of rows //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArrayFullOfConversation!.count
    }
    
    // height of the rows //
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    
    
    
    
    
    
    
    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        mainTableView.backgroundColor = colorPalette.lightBlueColor
        
    }


}
