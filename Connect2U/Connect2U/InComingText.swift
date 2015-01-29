//
//  InComingText.swift
//  Connect2U
//
//  Created by Cory Green on 1/20/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit
import Parse

@objc protocol UpdateTextDelegate{
    
    func updateChatObjectFromNewChatHelperClass(object:AnyObject, index:Int)
    
}

class InComingText: NSObject {
    
    var arrayOfChats:Array<NewChat> = []
    var delegate:UpdateTextDelegate?
    
    
    
    // recieves texts and then delegates them
    override init() {
        super.init()
        
        // ** when a push notification comes in this gets called ** //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textMessageRecieved:", name: "textMessage", object:nil)
        

    }
    
    func textMessageRecieved(object:NSNotification){
        
        //println("recieved text message and im in the sendTextMessage object : \(object.description)")
        self.messageRecieved(object)
        
    }
    
    
    
    
    
    
    
    // what happens when a text comes in //
    func messageRecieved(object:AnyObject){
        
        var messageRecieved:String = ""
        
        var firstLevelOfInComingObject:AnyObject? = object.valueForKey("userInfo")
        if(firstLevelOfInComingObject != nil){
            
            messageRecieved = firstLevelOfInComingObject?.valueForKey("message") as String
            println("mesage recieved \(messageRecieved)")
            
        }
        
        
        
        var originalPersonId:[AnyObject] = []
        var arrayOfIdsFromIncomingMessage:Array<AnyObject> = []
        
        // basically Ill be comparing the incoming object with those that are already in //
        // the array of chats.  Those that have the appropriate object id + PFUser.current().objectId //
        // and only those, will get pushed the chat message update //
        
        
        // used to get the id of the chat objects //
        if(arrayOfChats.count != 0){
            
            
            
            
            
            println("array of Chats \(arrayOfChats)")
            
            for(var i = 0; i < arrayOfChats.count; i++){
                
                var firstLayer:AnyObject? = arrayOfChats[i].personsPassedIn
                if(firstLayer != nil){
                    
                    var secondLayer:AnyObject? = firstLayer!.valueForKey("userInfo")
                    if(secondLayer != nil){
                        
                        var objectId:AnyObject? = secondLayer!.valueForKey("objectId")!
                        if(objectId != nil){
                            
                            if(objectId != nil){
                                
                                var finalObjectId:AnyObject? = objectId?.firstObject
                                if(finalObjectId != nil){
                                    
                                    println("original id ")
                                    
                                    var tempDictionary = [finalObjectId!,PFUser.currentUser().objectId]
                                    
                                    originalPersonId.append(tempDictionary)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }

        
        var tempArrayForThoseInvolved:[AnyObject] = []
        
        var firstLevel:AnyObject? = object.valueForKey("userInfo")
        if(firstLevel != nil){
            
            tempArrayForThoseInvolved.append(firstLevel!.valueForKey("usersInvolved")!)
        }

        for(index, element) in enumerate(originalPersonId){
            
            for(_index, _element) in enumerate(tempArrayForThoseInvolved){
                
                
                
                
                
                // comparing //
                if(element.isEqual(_element)){
                    
                    println("the index invovled \(index)")
                    
                    println("person passed in \(arrayOfChats[index].personsPassedIn)")
                    
                    var userNamePassedIn:AnyObject?
                    
                    
                    
                    
                    var firstLevel:AnyObject? = arrayOfChats[index].personsPassedIn
                    if(firstLevel != nil){
                        
                        var secondLevel:AnyObject? = firstLevel?.valueForKey("userInfo")
                        if(secondLevel != nil){
                            
                            
                            
                            
                            userNamePassedIn = secondLevel!.valueForKey("username")
                            
                            println("user name passed in \(userNamePassedIn!)")
                            println("\n\nrecieved object \(object.description)\n\n")
                            
                            var tempDictionary = [messageRecieved :userNamePassedIn!]
                            
                            delegate?.updateChatObjectFromNewChatHelperClass(tempDictionary, index: index)

                    
                        }
                    }
                }
            }
        }
    }
    
    
    func updateListOfChats(newArrayOfChats:Array<NewChat>){
        
        arrayOfChats = newArrayOfChats
        
    }
    
    
    
   
}
