//
//  ChatViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RecievedTextDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    
    var mainInputField:UITextField?
    var mainReturnButton:UIButton?
    
    var personPassedIn:AnyObject?
    var personNameChattingWith:PFUser?
    var sendText = sendTextMessage()
    
    var otherPersonId:AnyObject?
    var personId:AnyObject?
    var personName:String?
    
    
    
    
    
    var mainArrayFullOfConversation:[AnyObject]?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainArrayFullOfConversation = []

        self.setColors()

        sendText.delegate = self
        mainTableView.delegate = self
        
        
        // for some reason, I was getting no interaction what so ever from my //
        // UITableView... this fixed it //
        self.mainTableView.userInteractionEnabled = true
        
        println("\n \n person passed in \(personPassedIn)")
        

        
        
        if(personPassedIn != nil){
            
            var personPassed: AnyObject? = personPassedIn!.valueForKey("userInfo")
            if(personPassed != nil){

                personName = personPassed!.objectForKey("username") as? String
                personId = personPassed!.objectForKey("objectId")
                println(personName)
                
                
            }else{

                personName = personPassedIn!.valueForKey("username") as? String
                println(personName)
                personId = personPassedIn!.objectId
            }
        }
        
        
    
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
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShow"), name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    
    
    
    // where texts come back //
    // putting the info into a dictionary, then into an array //
    func sendTextInfoBack(textInfo: AnyObject) {
        
        println("this info is in the chat view controller \(textInfo.description)")
        
        if(!(textInfo.isEqual(nil))){
        
            var incomingPersonId:String = textInfo.valueForKey("object")!.objectForKey("userInfo") as String
        
            var incomingPersonText:String = textInfo.valueForKey("object")!.valueForKey("aps")!.objectForKey("alert") as String

            println("this and that \(incomingPersonId) \(incomingPersonText)")
            
            var tempDictionary:[String:String] = [incomingPersonId:incomingPersonText]
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
    
    
    
    
    
    
    
    

    // removing the observer for text notificaitons //
    override func viewWillDisappear(animated: Bool) {
        
        sendText.removeNotificationObserver()
    }
    
    
    func group(){
        
        println("in here")
        
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
        
        // sending off to send out the text message to the user //
        sendText.sendTextMessage(mainInputField!.text, toUser: self.personId!)
        if(mainArrayFullOfConversation != nil){
            
            mainTableView.reloadData()
            
            if mainTableView.contentSize.height > mainTableView.frame.size.height
            {
                let offset = CGPoint(x: 0, y: mainTableView.contentSize.height - mainTableView.frame.size.height)
                mainTableView.setContentOffset(offset, animated: false)
            }
            
            
        }
        
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
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        if((indexPath.row % 2) == 0){

            let cell = tableView.dequeueReusableCellWithIdentifier("cellLeft", forIndexPath: indexPath) as ChatLeftCell
            
            cell.backgroundColor = greenColor
            cell.layer.cornerRadius = 3.0
            cell.leftLabel.text = "Cory @ 18:10pm"
            cell.leftLabel.textColor = darkGreenColor
            cell.leftLabel.backgroundColor = greenColor
            cell.leftLabel.layer.cornerRadius = 3.0
            cell.leftLabel.clipsToBounds = true
            cell.dataLabel.textColor = darkGreenColor
            cell.dataLabel.backgroundColor = greenColor
            cell.dataLabel.text = "Hey, hows it going?"
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true

            
        
            return cell
            
        }else{
            
            //let cell = tableView.dequeueReusableCellWithIdentifier("cellRight") as RightChatCell
            let cell = tableView.dequeueReusableCellWithIdentifier("cellRight", forIndexPath: indexPath) as RightChatCell
            
            
            cell.backgroundColor = darkGreenColor
            cell.layer.cornerRadius = 3.0
            cell.rightLabel.text = "Kevin @ 18:11pm"
            cell.rightLabel.textColor = whiteColor
            cell.rightLabel.backgroundColor = darkGreenColor
            cell.rightLabel.layer.cornerRadius = 3.0
            cell.rightLabel.clipsToBounds = true
            cell.dataLabel.textColor = whiteColor
            cell.dataLabel.backgroundColor = darkGreenColor
            cell.dataLabel.text = "Im pretty good, how are you?"
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true

            
            
            return cell
        }
        */
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
