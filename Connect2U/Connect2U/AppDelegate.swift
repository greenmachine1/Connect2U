//
//  AppDelegate.swift
//  Connect2U
//
//  Created by Cory Green on 11/11/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // setting up for the Parse Connect2U project side //
        Parse.setApplicationId("JSfr6Q2SbXv3oipCnuGFYOyJBlmB4bix5OFQHciz", clientKey: "4U9EqhEhNDpydFnrzXWIEM998Lmx3Z1zXyBOA1ya")
        
        // push notification setup //
        var userNotificationTypes:UIUserNotificationType = (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound)
        
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:userNotificationTypes , categories: nil)

        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        // sending a notification to the ibeaconGatherData class to let it know that the app has gone into the //
        // background and should stop recieving notifications //
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("stopiBeacon", object: nil)
        
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("startiBeacon", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // telling the iBeaconGatherData that it needs to stop recieving data //
        // when stopping the app //
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("stopiBeacon", object: nil)
    }
    
    
    
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        println("\n \n in here as well! \n \n ")
        
        var currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            if(success){
                
                println(currentInstallation["user"])
                
            }else{
                
                println("\n \n error in saving the installation \(error.description) \n \n ")
                
            }
        }
    }

    
    
    
    
    
    // when a push comes in
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        println("recieved push notification! \(userInfo.description)")
        
        println("count and stuff!!! \(userInfo.count)")
        
        
        for(var i = 0; i < userInfo.count; i++){
            
            if(userInfo.keys.array[i].isEqual("request")){
                
                // 1 represents this is a chat request //
                if(userInfo.values.array[i].isEqual(1)){
                    
                    println("request to chat coming in!")
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("requestToChat", object:self, userInfo:userInfo)
                
                // 0 is something else //
                }else{
                    
                    
                    
                }
                
            }else if(userInfo.keys.array[i].isEqual("responseToRequest")){
                
                println("response to chat came in")
                
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.postNotificationName("responseToRequest", object:self, userInfo:userInfo)
                

            }else{
                
                
                if(userInfo.keys.array[i].isEqual("text")){
                
                if(userInfo.values.array[i].isEqual(1)){
                    
                    println("recieved Text")
                    
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("textMessage", object:self, userInfo:userInfo)
                    
                    }
                }
                
                
            }
            
        }
        
        /*
        var userCount = userInfo.values.array.count
        
        for(var i = 0; i < userCount; i++){
            
            println(userInfo.keys.array[i])
            if(userInfo.keys.array[i].isEqual("request")){
                
                // sent over a chat request //
                if(userInfo.values.array[i].isEqual(1)){
                    
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("requestToChat", object:self, userInfo:userInfo)
                    
                    println("should display a popup asking what you wnat to do next")
                    
                    
                // this is equal to the user sending over a chat request //
                }else{
                    
                    
                }
                
             // checking for text send over //
            }else if(userInfo.keys.array[i].isEqual("text")){
                
                println("text came in!")
                
            }
            
        }

        */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
    
        // trick for the silent updates -- if the content available is set to 1 and you check for it //
        // as being true, you can not pass it to the handlePush which is where the vibrate is coming from //
        if(userInfo.values.array[0].objectForKey("content-available") != nil){
            
            var contentAvailable:AnyObject = userInfo.values.array[0].objectForKey("content-available")!
            var booleanValue:Bool = false
            
            println("this is here now : \(contentAvailable)")
            if(contentAvailable as NSObject == 1){
                
                var numberInNotification:Int = userInfo.values.array.count
                
                for(var i = 0; i < numberInNotification; i++){
                    println("poop! -->\(userInfo.values.array[i])")
                    
                    if(userInfo.keys.array[i].isEqual("textFromPerson") == true){
                        
                        booleanValue = true
                        
                        // letting the text class know that there is a new text coming in //
                        let notificationCenter = NSNotificationCenter.defaultCenter()
                        notificationCenter.postNotificationName("textMessage", object: userInfo)
                    }
                    
                }
            
                if(booleanValue == false){
                    
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("pushNotification", object: nil)
                }
                
            }
            
            
            
            
        }
        
        // taking care of other push notifications such as updates and texts //
        else if(userInfo.values.array[0].objectForKey("content-available") == nil){
            
            println(userInfo.description)
            
            var didRecieveRequestForChat = 3
            var numberInNotification:Int = userInfo.values.array.count
            
            for(var i = 0; i < numberInNotification - 1; i++){
                
                println(userInfo.values.array[i])
                println("draw the attention here!\(userInfo.keys.array[i])")
                
                
                if(userInfo.keys.array[i].isEqual("requestChat")){
                    
                    println("recieved an ok or denial of chat")
                    didRecieveRequestForChat = 1
                    break
                    
                }else{
                    
                    didRecieveRequestForChat = 0
                    
                }
            }
            
            if(didRecieveRequestForChat == 0){
                
                // request for chat //
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.postNotificationName("requestToChat", object:self, userInfo:userInfo)
                
                println("\n \n app delegate request to chat --> :\(userInfo)\n \n  ")
                
            }else if(didRecieveRequestForChat == 1){
                
                // response to the chat request //  
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName("responseToChat", object:self, userInfo:userInfo)
                
                println("\n \n app delegate response to chat --> :\(userInfo)\n \n  ")
                
            }
        
        }



        */
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("the description \(notification.description)")
    }
}

