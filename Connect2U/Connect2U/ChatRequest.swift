//
//  ChatRequest.swift
//  Connect2U
//
//  Created by Cory Green on 12/29/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//


// primarily used to send out a chat request and then listen for a response //
import UIKit
import Parse

@objc protocol RequestChatDelegate{
    
    // the userClickedOnChatRequest var will be the index of the //
    // alert view button //
    func userClickedOnChatRequestAlert(userClickedOnChatRequest:Int, personalInfo:AnyObject)
    
}

class ChatRequest: NSObject, UIAlertViewDelegate {
    
    var currentUser:PFUser?
    var _toUser:PFUser?
    
    var userRequestingChat:PFUser?
    var delegate:RequestChatDelegate?
    
    var currentUserInfo: AnyObject?
    
    override init(){
        super.init()
        

    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestChat:", name: "requestToChat", object: nil)
    }
    
    
    // sends out the request to chat //
    func sendRequestToChat(toUser:PFUser, fromUser:PFUser){
        
        currentUser = fromUser
        _toUser = toUser
        
        var currentUserDictionary = ["objectId":currentUser!.objectId,
                                     "age":currentUser!.objectForKey("age")!,
                                     "gender":currentUser!.objectForKey("gender")!,
                                     "interests":currentUser!.objectForKey("interests")!,
                                     "picture":currentUser!.objectForKey("picture")!,
                                     "username":currentUser!.objectForKey("username")!]
        
        println("current user from dictionary \(currentUserDictionary)")
        
        
        
        
        PFCloud.callFunctionInBackground("requestToChat", withParameters: ["toUser":self._toUser!.objectId, "fromUser":currentUserDictionary]) { (returnInfo:AnyObject!, error:NSError!) -> Void in
            
            // sent successfully //
            if(error == nil){
                
                println("returned user things and such : \(returnInfo)")
                
            }else{
                
                println(error.description)
            }
        }
        
    }
    
    
    
    
    
    // ---------- this is the recieving side of chat requests ------------ //
    
    // gets called when a request comes through //
    func requestChat(notification:NSNotification){
                
        println("notification mofo! : \(notification.description)")
        
        // checking to make sure the notification is not a push from location updates //
        if(notification.userInfo?.values.array[1] != nil){
            
            // making sure the object has personal data attached //
            if(notification.userInfo?.values.array[2] != nil){
                
                println("this is different stuff \(notification.userInfo?.values.array[1])")
            
                // getting the user info into this variable //
                currentUserInfo = notification.userInfo?.values.array[2]
            
                println("current stuff : \(currentUserInfo!) \n \n")
            
                var alert:UIAlertView = UIAlertView(title: "wants to chat with you", message: "What do you want to do?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "View Profile", "Chat")
            
                alert.show()
            }
        }
    }
    
    
    
    
    // alert view asking the user what they would like to do in response to the //
    // request for chat by the other user //
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        println("clicked! : \(buttonIndex)")
        
        if(buttonIndex == 0){
            
            // cancel //
            println("clicked on \(buttonIndex)")
            
            self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!)
            
            
        }else if(buttonIndex == 1){
            
            // view profile //
            println("clicked on \(buttonIndex)")
            
            self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!)
            
        }else{
            
            // chat //
            println("clicked on \(buttonIndex)")
            
            self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!)
            
        }
        
    }
    
    
    
}
