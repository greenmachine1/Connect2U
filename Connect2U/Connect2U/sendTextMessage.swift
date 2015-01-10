//
//  sendTextMessage.swift
//  Connect2U
//
//  Created by Cory Green on 12/28/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

@objc protocol RecievedTextDelegate{
    
    // delegate method that sends the text info back to the chat view //
    func sendTextInfoBack(textInfo:AnyObject)
    
}

class sendTextMessage: NSObject {
    
    var delegate:RecievedTextDelegate?
    
    var textMessage:String?
   
    override init() {
        super.init()
        
        textMessage = ""
        
        // ** when a push notification comes in this gets called ** //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textMessageRecieved:", name: "textMessage", object: nil)

    }
    

    func textMessageRecieved(object:NSNotification){
        
        println("recieved text message and im in the sendTextMessage object : \(object.description)")
        self.delegate?.sendTextInfoBack(object)
   
    }
    
    
    // making sure we remove the observer when leaving //
    func removeNotificationObserver(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "textMessage", object: nil)
        
    }
    
    
    
    
    
    
    
    // sends off a text message to the users in the array //
    // this will be cloud code //
    func sendTextMessage(message:String, toUser:AnyObject){
        
        textMessage = message
        
        println("\(textMessage!) and the person : \(toUser)")
        println("currentUser : \(PFUser.currentUser().objectId)")
        
        
        // calls the cloud function which takes in the actual text message and the user info //
        // sends it to that user //
        PFCloud.callFunctionInBackground("sendText", withParameters: ["textMessage": textMessage!, "toUser": toUser, "fromUser": PFUser.currentUser().objectId]) { (returnInfo:AnyObject!, error:NSError!) -> Void in
            
            // sent successfully //
            if(error == nil){
                
                println("returned user things and such : \(returnInfo)")
                
            }else{
                
                println(error.description)
            }
            
        }
    }
}
