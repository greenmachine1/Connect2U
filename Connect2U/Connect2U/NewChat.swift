//
//  NewChat.swift
//  Connect2U
//
//  Created by Cory Green on 1/19/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit
import Parse

@objc protocol ChatObjectDelegate{
    
    //func changesToChatList()
    
}

class NewChat: NSObject {
    
    var delegate:ChatObjectDelegate?
    
    // array of people passed in //
    var personsPassedIn:Array<AnyObject> = []
    var youObjectId = PFUser.currentUser().objectId
    
    // the total messages held in an array //
    var totalMessages:Array<AnyObject> = []
    
    override init(){
        super.init()
    }
    
    init(personPassedIn:AnyObject) {
        super.init()
        
        
        // addin the person passed in to the personsPassedInArray //
        personsPassedIn.append(personPassedIn)
    }
    
    
    
    // updates the list of poeple involved in this chat //
    func updateListOfPeopleInvolved(newPeopleAddedToChat:Array<AnyObject>){
    
        // adding people to the personsPassedIn Array //
        for(index, element) in enumerate(newPeopleAddedToChat){
            
            personsPassedIn.append(element)
        }
        
    }
    
    
    
    // sends out the message //
    func sendMessage(personThatSentTheMessage:AnyObject, messageSent:String){
        
        var messagesThemselves = [messageSent: personThatSentTheMessage as String]
        
        totalMessages.append(messagesThemselves)
    }
    
    
    
    // recieved the message //
    func recievedMessage(personThatSentTheMessage:AnyObject, messageRecieved:String){
        
        var messagesThemselves = [messageRecieved: personThatSentTheMessage as String]
        
        totalMessages.append(messagesThemselves)
    }
    
    
    
    // unloads the entire message
    func readFullMessage() ->AnyObject{
        
        return totalMessages as Array
    }
    
    
    // returns the entire object to be parsed down for its user name in other classes //
    func returnLabelForListOfChats() ->AnyObject{
        
        println("in the new chat return \(personsPassedIn[0])")
        
        return personsPassedIn[0]
        
    }
    
    func returnEntireObject()->AnyObject{
        
        return self
    
    }
    
    func removeEntireConversationAndPutInNew(newArray:AnyObject){
        
        totalMessages.removeAll(keepCapacity: false)
        totalMessages = newArray as Array
    }
}
