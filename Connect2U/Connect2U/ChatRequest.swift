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
    func returnedUserResponseToChat(wantsToChatYesOrNo:Bool, user:AnyObject)
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "responseToTheRequestToChat:", name: "responseToChat", object: nil)
    }
    
    
    
    
    // method used to send back to LoggedIn, the other users response to chat //
    func responseToTheRequestToChat(sender:NSNotification){
        
        var requestToChatVariable:Int = sender.userInfo!.values.array.count
        if(requestToChatVariable != 0){
            
            for(var i = 0; i < requestToChatVariable; i++){
                
                if(sender.userInfo!.keys.array[i].isEqual("requestChat")){
                    
                    if(sender.userInfo!.values.array[i] as NSObject == 0){
                        
                        self.delegate?.returnedUserResponseToChat(false, user: sender)
                        
                    }else if(sender.userInfo!.values.array[i] as NSObject == 1){
                        
                        self.delegate?.returnedUserResponseToChat(true, user: sender)
                    }
                }
            }
        }
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
        
        

            var firstLevel:AnyObject! = notification.valueForKey("userInfo")!.objectForKey("userInfo")!
            var nameString:AnyObject! = firstLevel.objectForKey("username")
        
            // getting the user info into this variable //
            currentUserInfo = notification.userInfo
        
            var alert:UIAlertView = UIAlertView(title: "\(nameString) wants to chat with you", message: "What do you want to do?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "View Profile", "Chat")
            
            alert.show()
        

    }
    
    
    
    
    
    
    
    
    // tells the sender that its ok to chat! //
    func sendOutTheOkToChat(isOk:Bool, toUser:AnyObject){
        
        if(toUser.objectForKey("userInfo") != nil){
            
            var firstObject:AnyObject? = toUser.objectForKey("userInfo")
            
            if(firstObject?.objectForKey("objectId") != nil){
                var objectId:AnyObject? = firstObject?.objectForKey("objectId")
        
                println("object ID and crap --> \(objectId!)")
                
                // basically sending out a return ok/not ok to chat response to the person who originally called //
                PFCloud.callFunctionInBackground("okOrNotToChat", withParameters: ["toUser":objectId as String,"fromUser":PFUser.currentUser().objectId, "requestToChat":isOk]) { (response:AnyObject!, error:NSError!) -> Void in
                    
                    if(error == nil){
                        
                        println("response from sending out a response.... : \(response.description)")
                        println("success in sending response")
                        
                    }else{
                        
                        println("error happened --> \(error.description)")
                    }
                    
                    
                }
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
