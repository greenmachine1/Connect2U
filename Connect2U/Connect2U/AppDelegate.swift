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
        
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        println("in here as well!")
        
        var currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            if(success){
                
                println(currentInstallation["user"])
                
            }else{
                
                println("\(error.description)")
                
            }
        }
    }

    
    
    
    
    
    // when a push comes in
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
        // trick for the silent updates -- if the content available is set to 1 and you check for it //
        // as being true, you can not pass it to the handlePush which is where the vibrate is coming from //
        if(userInfo.values.array[0].objectForKey("content-available") != nil){
            
            var contentAvailable:AnyObject = userInfo.values.array[0].objectForKey("content-available")!
            
            println("this is here now : \(contentAvailable)")
            if(contentAvailable as NSObject == 1){
                
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.postNotificationName("pushNotification", object: nil)
                
                
            }
            
            
            
            
        }
        /*
        else if(userInfo.values.array[0].objectForKey("content-available") == nil){
            

            println(userInfo.description)
            
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("textMessage", object:self, userInfo:userInfo)
            
            PFPush.handlePush(userInfo)
            
        }
        */
        
        else if(userInfo.values.array[0].objectForKey("content-available") == nil){
            
            
            
            
            // this is for recieving a friends request //
            if(!(userInfo.values.array[1].isEqual(nil))){
                
                println("The entire thing thats passed in!!!!!!! -- > : \(userInfo.description) \n \n \n \n ")
            
                //println("user passed in : \(userPassedIn.description)")
                
                println("this is there as well : \(userInfo.values.array[1])")
            
                println("user info : \(userInfo.description)")
            
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.postNotificationName("requestToChat", object:self, userInfo:userInfo)
            }
        }
    }
    
    
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("the description \(notification.description)")
    }
    
    


}

