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
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("startiBeacon", object: nil)
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
        
        println("\n \n \n recieved push notification! \(userInfo.description)\n \n \n ")
        
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
                    
                }else{
                    
                    // letting the rest of the app know that it needs to update the user info //
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("requestToUpdate", object:self, userInfo:userInfo)
                    
                    
                }
                
                
            }
            
        }
        
     }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("the description \(notification.description)")
    }
}

