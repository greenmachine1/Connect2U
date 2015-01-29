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
    func userClickedOnChatRequestAlert(userClickedOnChatRequest:Int, personalInfo:AnyObject, fromGroup:Bool)
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "responseToTheRequestToChat:", name: "responseToRequest", object: nil)
    }
    
    
    
    
    
    
    
    
    
    // method used to send back to LoggedIn, the other users response to chat //
    func responseToTheRequestToChat(sender:NSNotification){
        
        println("\n \n \n \n \n sender description !!!! ----->\(sender.description)\n \n \n \n \n \n \n \n \n")
        
        
        var requestToChatVariable = sender.userInfo!.values.array.count
        
        println(requestToChatVariable)
        
        for(var i = 0; i < requestToChatVariable; i++){
            
            if(sender.userInfo!.keys.array[i].isEqual("responseToRequest")){
                
                if(sender.userInfo!.values.array[i].isEqual(1)){
                    
                    println("blah blah --> true")
                    
                    self.delegate?.returnedUserResponseToChat(true, user: sender)
                    
                }else{
                    
                    println("blah blah --> false")
                    
                    self.delegate?.returnedUserResponseToChat(false, user: sender)
                }
            }
            
        }
        

    }
    
    
    
    
    
    
    // sends out the request to chat //
    // upon recieving - the user gets a bunch of info //
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
    // this recieves a bunch of info //
    
    // gets called when a request comes through //
    func requestChat(notification:NSNotification){
                
        println("notification mofo! : \(notification.description)")
        
            
            var firstLevel:AnyObject! = notification.valueForKey("userInfo")!.objectForKey("userInfo")!
            var nameString:AnyObject! = firstLevel.objectForKey("username")
        
    
            // getting the user info into this variable //
            // this isnt the problem //
            currentUserInfo = notification.userInfo
        
            println("\n\n\n\nnotification \(currentUserInfo!)\n\n\n")
        
        if var cameFromGroupChat:AnyObject? = currentUserInfo!.valueForKey("group"){
            
            println("\n \n \n \n \n \n cameFrom group chat boolean \(cameFromGroupChat?) \n \n \n \n \n \n ")
            
            
            // group chat request //
            if(cameFromGroupChat != nil){
                var alert:UIAlertView = UIAlertView(title: "Group wants to chat with you", message: "What do you want to do?", delegate: self, cancelButtonTitle: "Dont Chat", otherButtonTitles:"Chat", "Respond Later")
                
                alert.tag = 0
            
                alert.show()
                
            }else{
                
                
                // regular chat requests
                var alert:UIAlertView = UIAlertView(title: "\(nameString) wants to chat with you", message: "What do you want to do?", delegate: self, cancelButtonTitle: "Dont Chat", otherButtonTitles: "View Profile", "Chat", "Respond Later")
                
                alert.tag = 1
                
                alert.show()
                
            }
            
        }else{
        
        
        
            // group chat sends over different data //
            // such as a group property which is a bool //
            // also sends over the objectIds of those chatting with //
        
        
            println("current user info sent in from chat request ---> \(currentUserInfo?.description)")

            
            
        }
    }
    
    
    
    
    
    
    
    
    // tells the sender that its ok to chat! //
    func sendOutTheOkToChat(isOk:Bool, toUser:AnyObject){
        
        if(toUser.objectForKey("userInfo") != nil){
            
            var firstObject:AnyObject? = toUser.objectForKey("userInfo")
            
            if(firstObject?.objectForKey("objectId") != nil){
                var objectId:AnyObject? = firstObject?.objectForKey("objectId")
        
                // basically sending out a return ok/not ok to chat response to the person who originally called //
                PFCloud.callFunctionInBackground("okOrNotToChat", withParameters: ["toUser":objectId as String,"fromUser":PFUser.currentUser().objectId, "requestToChat":isOk]) { (response:AnyObject!, error:NSError!) -> Void in
                    
                    if(error == nil){
                        
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
        
        println("\n\n\nalert \(alertView.description)\n \n\n\n")
        
        println("user info passed in to alertview --> \(self.currentUserInfo!)")
        
        println("clicked! : \(buttonIndex)")
        
        
        
        // for accepting group chat //
        if(alertView.tag == 0){

            if(buttonIndex == 0){
                
                println("cancel button")
                
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:true)
                
            }else if(buttonIndex == 1){
                
                println("chat button")
                
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:true)
                
            }else{
                
                println("respond later")
                
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:true)
                
            }
            
            
            
        // regular chat acceptance //
        }else{

            if(buttonIndex == 0){
            
                // cancel //
                println("clicked on \(buttonIndex)")
                println("cancel")
            
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:false)
            
            
            }else if(buttonIndex == 1){
            
                // view profile //
                println("clicked on \(buttonIndex)")
                println("view profile")
            
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:false)
            
            }else if(buttonIndex == 2){
            
                // chat //
                println("clicked on \(buttonIndex)")
                println("chat")
            
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:false)
            
            }else{
            
                // respond later //
            
                println("clicked on \(buttonIndex)")
                println("save for later")
            
                self.delegate?.userClickedOnChatRequestAlert(buttonIndex, personalInfo: self.currentUserInfo!,fromGroup:false)
            
            }
        }
    }
}
