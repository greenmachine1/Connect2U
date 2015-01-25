//
//  ChatViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

@objc protocol UpdateObjectDelegate{
    
    func updateChatObject(object:AnyObject, atIndex:Int) ->Array<AnyObject>
    
}


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
    
    
    
    // this holds the data being passed in //
    var mainChatObject:NewChat?
    
    var userPassedInObjectId:AnyObject?
    var userPassedInUserName:AnyObject?
    var indexNumber:Int?
    
    var delegate:UpdateObjectDelegate?
    
    var tempArrayOfMessages:[AnyObject]?
    var passedInMessages:[AnyObject]?
    
    var arrayOfUsersInvolved:Array<AnyObject>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainArrayFullOfConversation = []

        self.setColors()

        mainTableView.delegate = self
        
        
        // for some reason, I was getting no interaction what so ever from my //
        // UITableView... this fixed it //
        self.mainTableView.userInteractionEnabled = true
        
        tempArrayOfMessages = passedInMessages
        

        if(mainChatObject != nil){

    
            //println("main object ---> \(mainChatObject!.returnLabelForListOfChats())")
            
            var mainChatObjectReturn:AnyObject? = mainChatObject?.returnLabelForListOfChats()
            if(mainChatObjectReturn != nil){
                
                var secondLevel:AnyObject? = mainChatObjectReturn?.objectForKey("userInfo")
                if(secondLevel != nil){
                    
                    // used throughout the chat //
                    userPassedInObjectId = secondLevel!.objectForKey("objectId")
                    userPassedInUserName = secondLevel!.objectForKey("username")
                }
            }
        }
        
        println("\n \n whats getting to the chat controller --> \(mainChatObject?.readFullMessage())\n \n ")
        
        
        
        
        
        
        

        
        if(personPassedIn != nil){
            
            println("in here --> not sure whats going on!")
            
            if(personPassedIn!.valueForKey("userInfo") != nil){
                
                println("person passed in drill -->\(personPassedIn!)")
                
                var personPassed: AnyObject? = personPassedIn!.valueForKey("userInfo")
                
                println("parson passed : \(personPassed!)")
                
                if(personPassedIn != nil){
                    
                    var secondLevel: AnyObject? = personPassed?.objectForKey("userInfo")
                    if(secondLevel != nil){
                        
                        println("second level and stuff \(secondLevel!)")
                
                        userPassedInUserName = secondLevel!.valueForKey("username") as? String
                        userPassedInObjectId = secondLevel!.valueForKey("objectId")
                        
                        println("user name and object id \(userPassedInUserName), \(userPassedInObjectId)")
                        
                
                    
                    }else{

                        userPassedInUserName = personPassed!.valueForKey("username") as? String
                        userPassedInObjectId = personPassed!.valueForKey("objectId")
                        
                        
                    }
                }
            }
        }
        

        
        
        
    
        // group chat button //
        var editButton:UIBarButtonItem = UIBarButtonItem(title: "Group Chat", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("group"))
        self.navigationItem.rightBarButtonItem = editButton
        
        

        var widthOfScreen:CGFloat = CGFloat(self.view.frame.width / 2)
        
        // this is all static data that will be updated at a later time //
        mainInputField = UITextField(frame: CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 50.0), width: self.view.frame.width - 120 , height: 30.0))
        
        
        mainInputField?.borderStyle = UITextBorderStyle.RoundedRect
        mainInputField?.placeholder = "Enter Text"
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTheView:", name: "updateTableView", object:nil)
    
        
    }
    
    
    
    
    // updates the tableview remotely //
    func updateTheView(object:NSNotification){
        
        println("object passed in -->\(object.description)")
        
        
        var userInfobject:AnyObject? = object.valueForKey("userInfo")
        if(userInfobject != nil){
            
            var userPassedInObject:AnyObject? = userInfobject?.valueForKey("userPassedIn")
            if(userPassedInObject != nil){
                
                var userNameValue:AnyObject? = userPassedInObject?.valueForKey("userInfo")
                if(userNameValue != nil){
                    
                    var username:AnyObject? = userNameValue?.valueForKey("username")
                    if(username != nil){
                        
                        var finalUserName:AnyObject? = username!.firstObject!
                        println("username \(finalUserName!)")
                        
                        var stringConversionOfFinalName:String = finalUserName as String
                        
                        if(stringConversionOfFinalName == userPassedInUserName! as String){
                            
                            println("final and passed \(stringConversionOfFinalName) and \(userPassedInUserName)")
                            
                            println("its the same and you should be here")
                            
                            var firstLevel:AnyObject? = object.valueForKey("userInfo")
                            if(firstLevel != nil){
                                
                                var secondLevel:[AnyObject] = firstLevel?.valueForKey("userInfo") as Array<AnyObject>
                                
                                tempArrayOfMessages = secondLevel
                                
                                self.mainTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    

    
    
    
    
    
    

    
    
    
    
    
    func textMessageRecieved(object:NSNotification){
        
        //println("recieved text message and im in the sendTextMessage object : \(object.description)")
        self.sendTextInfoBack(object)
        
    }
    
    
    
    // getting the username and text message sent
    func sendTextInfoBack(textInfo:AnyObject){
        
        
        
        println("text recieved!!! -->\(textInfo.description)")
        
        var incomingPersonText:String? = ""
        var incomingPersonName:String? = ""
        
        var firstLevel:AnyObject?
        
        if(!(textInfo.isEqual(nil))){
            
            println("text info --> \(textInfo.description)\n \n ")
            
            firstLevel = textInfo.valueForKey("userInfo")?
            if(firstLevel != nil){
                
                println("first level info --> \(firstLevel!)\n \n ")
                
                var secondLevel:AnyObject? = firstLevel!.valueForKey("message")
                if(secondLevel != nil){
                    
                    println("second level info -->\(secondLevel!)\n \n ")
                    
                    var tempArrayForThoseInvolved:Array<AnyObject> = firstLevel?.valueForKey("usersInvolved") as Array
                    if(tempArrayForThoseInvolved.count != 0){
                        
                        for(var i = 0; i < tempArrayForThoseInvolved.count ; i++){
                            
                            println("those involved \(tempArrayForThoseInvolved[i])")
                            arrayOfUsersInvolved?.append(tempArrayForThoseInvolved[i])
                            
                        }
                        
                    }
                    
                    incomingPersonText! = secondLevel! as String
                    
                    println("incoming person text --> \(incomingPersonText!)\n \n ")
                    
                    var userNameLevel:AnyObject? = firstLevel!.valueForKey("userInfo")
                    if(userNameLevel != nil){
                        
                        println("userName level --> \(userNameLevel!)\n \n ")
                        
                        incomingPersonName = userNameLevel!.valueForKey("username") as? String
                        
                        if(incomingPersonName != nil){
                            
                            // setting this in the main object to be kept safe and eventually returned to //
                            // the main view //
                            var tempDictionaryToHoldPersonAndMessage = [incomingPersonText!:incomingPersonName!]
                            
                            tempArrayOfMessages = delegate?.updateChatObject(tempDictionaryToHoldPersonAndMessage, atIndex: indexNumber!)

                            mainTableView.reloadData()
                            
                            
                            // keeping the listview always at the bottom //
                            if mainTableView.contentSize.height > mainTableView.frame.size.height
                            {
                                let offset = CGPoint(x: 0, y: mainTableView.contentSize.height - mainTableView.frame.size.height)
                                mainTableView.setContentOffset(offset, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    // send off the text //
    func mainReturn(){
        
        // sending out a text message to the other user //
        self.sendTextMessage(mainInputField!.text, toUser: self.userPassedInObjectId!)
        
        var tempDictionaryToHoldPersonAndMessage = [mainInputField!.text:PFUser.currentUser().username]
        
        tempArrayOfMessages = delegate?.updateChatObject(tempDictionaryToHoldPersonAndMessage, atIndex: indexNumber!)
        
        mainTableView.reloadData()
        
        
        // resetting the text field //
        mainInputField!.text = ""
        
        // keeping the listview always at the bottom //
        if mainTableView.contentSize.height > mainTableView.frame.size.height
        {
            let offset = CGPoint(x: 0, y: mainTableView.contentSize.height - mainTableView.frame.size.height)
            mainTableView.setContentOffset(offset, animated: false)
        }
    }
    
    
    
    

    
    // dismisses the sidebar //
    override func viewDidDisappear(animated: Bool) {
        
        // used to send back the final object when the view is no more //
        
        sideBar.fromFriendsButton(false)
        
        tempBoolToggle = true
        
        // removing the observer from recieving textMessage once left the view //
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "textMessage", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateTableView", object: nil)
    }
    
    
    // initializing the side bar //
    override func viewWillAppear(animated: Bool) {
        
        sideBar = SideBar(callingView: self.view, friends: listOfFriends, requests:Array<String>(), fromLoggedInView:false)
        
        sideBar.delegate = self
        
    }
    
    
    
    
    
    
    
    func sideBarDidSelectAtIndex(index:Int, sectionOfSelection:Int){
        
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
    

    
    
    func sendTextMessage(text:String, toUser:AnyObject){
        
        // setting up a dictionary of all the info to send over //
        var currentUserDictionary = ["objectId":PFUser.currentUser().objectId,
            "age":PFUser.currentUser().objectForKey("age")!,
            "gender":PFUser.currentUser().objectForKey("gender")!,
            "interests":PFUser.currentUser().objectForKey("interests")!,
            "picture":PFUser.currentUser().objectForKey("picture")!,
            "username":PFUser.currentUser().objectForKey("username")!]
        
        
        // creating an array of those involved //
        var arrayOfUsersInvolved:Array<AnyObject> = [PFUser.currentUser().objectId, toUser]
        
        
        
        
        // basically needs to send over an alert saying that 'You' want to chat with them and //
        // the can either click ok or view profile //
        var dataSend = ["userInfo": currentUserDictionary, "text":true, "message": text, "usersInvolved":arrayOfUsersInvolved]
        
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
        //if((mainChatObject!.readFullMessage()[indexPath.row].allValues.first?.isEqual(PFUser.currentUser().username)) == true){
        if((tempArrayOfMessages![indexPath.row].allValues.first?.isEqual(PFUser.currentUser().username)) == true){
            
            println("in here with cory")
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellRight", forIndexPath: indexPath) as RightChatCell
            
            var tempMessageString:String? = tempArrayOfMessages![indexPath.row].allKeys.first as? String
            
            
            
            cell.backgroundColor = whiteColor
            cell.layer.cornerRadius = 3.0
            cell.rightLabel.text = "You"
            cell.rightLabel.textColor = darkGreenColor
            cell.rightLabel.backgroundColor = whiteColor
            cell.rightLabel.layer.cornerRadius = 3.0
            cell.rightLabel.clipsToBounds = true
            cell.dataLabel.textColor = darkGreenColor
            cell.dataLabel.backgroundColor = whiteColor
            
            cell.dataLabel.text = tempMessageString!
            

            
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            
            
            
            return cell
            
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellLeft", forIndexPath: indexPath) as ChatLeftCell
            
            //var tempMessageString:String? = mainChatObject!.totalMessages[indexPath.row].allKeys.first as? String
            var tempMessageString:String? = tempArrayOfMessages![indexPath.row].allKeys.first as? String
            
            cell.backgroundColor = greenColor
            cell.layer.cornerRadius = 3.0
            cell.leftLabel.text = userPassedInUserName as? String
            cell.leftLabel.textColor = whiteColor
            cell.leftLabel.backgroundColor = greenColor
            cell.leftLabel.layer.cornerRadius = 3.0
            cell.leftLabel.clipsToBounds = true
            cell.dataLabel.textColor = whiteColor
            cell.dataLabel.backgroundColor = greenColor
            cell.dataLabel.text = tempMessageString!
            
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            
            return cell
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        

    }

    
    
    // number of rows //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tempArrayOfMessages != nil){
            return tempArrayOfMessages!.count
        }
        
        return 0

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
