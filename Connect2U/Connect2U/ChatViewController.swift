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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()

        sendText.delegate = self
        mainTableView.delegate = self
        
        
        // for some reason, I was getting no interaction what so ever from my //
        // UITableView... this fixed it //
        self.mainTableView.userInteractionEnabled = true

        
        println("\n \n person passed in \(personPassedIn)")
        
        
        if(personPassedIn != nil){
            
            var personPassed: AnyObject? = personPassedIn!.valueForKey("userInfo")
            
            println("this is getting rediculas \(personPassed)")
            
            // two sets of different info are being passed in //
            if(personPassed!.objectForKey("username") != nil){
                
                println("there is a user name here")
                
                personId = personPassed!.objectForKey("objectId")
                println("person Id passed in : \(personId!)")
                
            }else if(personPassed!.objectForKey("userInfo") != nil){
                
                println("there isnt a user name here")
                personId = personPassed!.objectForKey("userInfo")
                println("person ID passed in : --> \(personId!)")
                
            }
            
        }
        
        
    
        // group chat button //
        var editButton:UIBarButtonItem = UIBarButtonItem(title: "Group Chat", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("group"))
        self.navigationItem.rightBarButtonItem = editButton
        
        

        var widthOfScreen:CGFloat = CGFloat(self.view.frame.width / 2)
        
        // this is all static data that will be updated at a later time //
        mainInputField = UITextField(frame: CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 50.0), width: 300.0 , height: 30.0))
        mainInputField?.borderStyle = UITextBorderStyle.RoundedRect
        mainInputField?.text = "Enter Text"
        mainInputField?.backgroundColor = UIColor.whiteColor()
        
        mainInputField?.delegate = self
        
        self.view.addSubview(mainInputField!)
        
        mainReturnButton = UIButton(frame: CGRect(x: 320.0, y: CGFloat(self.view.frame.height - 50.0), width: 100.0, height: 30.0))
        mainReturnButton?.setTitle("Send", forState: UIControlState.Normal)
        mainReturnButton?.addTarget(self, action: Selector("mainReturn"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(mainReturnButton!)
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShow"), name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    
    
    
    // where texts come back //
    func sendTextInfoBack(textInfo: AnyObject) {
        
        println("this info is in the chat view controller \(textInfo)")
        
    }
    
    
    
    
    
    
    
    

    // removing the observer for text notificaitons //
    override func viewWillDisappear(animated: Bool) {
        println("view will disappear")
        
        sendText.removeNotificationObserver()
    }
    
    
    func group(){
        
        println("in here")
        
    }
    

    
    
    // moving the textfield up for the keyboard //
    func keyboardShow(){
        
        mainInputField?.frame = CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 320.0), width: 300.0, height: 30.0)
        
        mainReturnButton?.frame = CGRect(x: 320.0, y: CGFloat(self.view.frame.height - 320.0), width: 100.0, height: 30.0)
    
    }
    
    
    
    
    
    
    
    
    
    // send off the text //
    func mainReturn(){

        // sending off to send out the text message to the user //
        sendText.sendTextMessage(mainInputField!.text, toUser: self.personId!)

        
    }
    
    
    
    
    
    
    
    
    
    
    // the return key //
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        
        println("in here")
        
        mainInputField?.resignFirstResponder()
        
        // moving the keyboard back down.... statically //
        mainInputField?.frame = CGRect(x: 20.0, y: CGFloat(self.view.frame.height - 50.0), width: 300.0 , height: 30.0)
        
        mainReturnButton?.frame = CGRect(x: 320.0, y: CGFloat(self.view.frame.height - 50.0), width: 100.0, height: 30.0)
        
        return true
        
    }
    

    

    // what will be in each row //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
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
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row : \(indexPath.row)")
    }
    
    
    
    
    // number of rows //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
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
