//
//  IBeaconGatherData.swift
//  Connect2U
//
//  Created by Cory Green on 1/10/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Parse

@objc protocol IBeaconInfo{
   
   // ** returns an array of all the users ** //
   func returnAllUsers(users:Array<AnyObject>)
   
   func returnLocationData(locationString:String)
   
}

class IBeaconGatherData: NSObject, CLLocationManagerDelegate {
    
    var beaconRegion:CLBeaconRegion = CLBeaconRegion()
    var _beaconRegion:CLBeaconRegion = CLBeaconRegion()
    let locationManagerThing:CLLocationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "5BB5174B-D0B1-402B-9DEC-CDFB00E3C58E")
    let identifierString = "com.Cory.MessingAroundWithiBeacons"
    
   
   var tempBeaconArray:Array<AnyObject> = []
   var finalArray:Array<AnyObject> = []
   
   var delegate:IBeaconInfo?
   
    override init(){
        super.init()
        
      locationManagerThing.delegate = self
      locationManagerThing.requestWhenInUseAuthorization()
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopServicesFromAppDelegate:", name: "stopiBeacon", object: nil)
      
      
      
      
        

    }
   
   func stopServicesFromAppDelegate(notification:NSNotification){
      
      println("This got called")
      
      // stop recieving notifications //
      self.stopRecieving()
      
   }
   
   



    
    func stopRecieving(){
        
         var tempBeacon:CLBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
         self.locationManagerThing.stopRangingBeaconsInRegion(tempBeacon)
        
         tempBeaconArray.removeAll(keepCapacity: false)
      
         self.delegate?.returnAllUsers(Array<AnyObject>())
    }
    
    
    
    
    
    
    
    
    
    
    // -------- recieve beacon section ----------- //
    
    
    func initRegion(){
        
        self._beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        if(!(self._beaconRegion.isEqual(nil))){
            
            self.locationManagerThing.startMonitoringForRegion(self._beaconRegion)
         
            self.locationManager(self.locationManagerThing, didStartMonitoringForRegion: self._beaconRegion)
        }else{
         
         println("object is nil")
         
      }
        
      
    }
    
    
    
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
      
      println(region.description)
      
      self._beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        if(!(self._beaconRegion.isEqual(nil))){
            
            self.locationManagerThing.startRangingBeaconsInRegion(self._beaconRegion)
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
        println(region.description)
      
      self._beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
      
      if(!(self._beaconRegion.isEqual(nil))){
        
        self.locationManagerThing.startRangingBeaconsInRegion(self._beaconRegion)
      }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
      
      self._beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
      
      if(!(self._beaconRegion.isEqual(nil))){
        
        self.locationManagerThing.stopRangingBeaconsInRegion(self._beaconRegion)
      }
    }
    
    
    
    // coming within range of beacon... //
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
      
      
         // stops calling the comparison method if there are no beacons //
         if(beacons.count != 0){
            
            var temporaryArrayOfDictionaries:Array<AnyObject> = []
            
            for items in beacons{
               
               if(items.proximity != CLProximity.Unknown){
                  
                  var tempDictionary = ["major":items.major, "minor":items.minor]
                  
                  temporaryArrayOfDictionaries.append(tempDictionary)
                  
               }
            }
            //self.comparisonOfArrays(beacons)
            self.comparisonOfArrays(temporaryArrayOfDictionaries)
         }
      

    }
   
   
   
   
   
    
    
    
    // comparing two arrays
    func comparisonOfArrays(inComingObjects:AnyObject){
      
      var inComingArrayArray:Array = Array<AnyObject>()
      inComingArrayArray = inComingObjects as Array
      

   
      if(tempBeaconArray.isEmpty){
         
         tempBeaconArray = inComingArrayArray
         
         for (index, elements) in enumerate(tempBeaconArray){
            
            var majorNumber: AnyObject! = elements.objectForKey("major")
            var minorNumber: AnyObject! = elements.objectForKey("minor")
            
            //send to server
            println("initial array sent to server ")
            self.lookUpUsersByArray(tempBeaconArray)
         }
      
      }
      
      
      // something has changed in the way of how large the array is ...
   
      if((tempBeaconArray.count > inComingArrayArray.count) || (tempBeaconArray.count < inComingArrayArray.count)){
         
         println("somethings changed and therefor the array is different")
         tempBeaconArray = inComingArrayArray
         self.lookUpUsersByArray(tempBeaconArray)
      
      // if thats not the case, we can assume they are the same size... //
      }else{

         
         // this only gets called if there are the same amount of objects that get replaced //
         // by the same number of objects.... this will hardly ever take place, at least the else //
         // statement that is.
         for(index, element) in enumerate(tempBeaconArray){
            
            for(_index, _element) in enumerate(inComingArrayArray){
               
               if((element.objectForKey("major")?.isEqual(_element.objectForKey("major"))) != nil){
                  
               }else{
                  
                  println("things changed")
                  tempBeaconArray.insert(inComingArrayArray[_index], atIndex: index)
                  
                  self.lookUpUsersByArray(tempBeaconArray)
               }
            }
         }
      }
      
      
      // seeing if the temp array is empty //
      if(tempBeaconArray.isEmpty){
         
         self.delegate?.returnAllUsers(Array<AnyObject>())
      }
   }

   
   
   

   
   
   
   
   
   // making the call to the parse server to look up and bring back user info //
   func lookUpUsersByArray(arrayOfMajorAndMinorNumbers:Array<AnyObject>){
      

      var tempObject:Array<AnyObject> = []
      var tempArrayLength = 0
      
      
      for(var i = 0; i < arrayOfMajorAndMinorNumbers.count; i++){
         
         var tempMajor:Int = arrayOfMajorAndMinorNumbers[i].valueForKey("major") as Int
         var tempMinor:Int = arrayOfMajorAndMinorNumbers[i].valueForKey("minor") as Int
         
         println("major and minor \(tempMajor), \(tempMinor)")
         
         PFCloud.callFunctionInBackground("findUsersIBeacon", withParameters: ["major":tempMajor, "minor": tempMinor]) { (results:AnyObject!, error:NSError!) -> Void in
         
            if(error == nil){
            
               tempObject.append(results)
               

               //println("temp Object -->\(tempObject)")
               self.delegate?.returnAllUsers(tempObject)
            
            }else{
            
               println(error.description)
            
            }
         
         }
      }
      
      println("array is done loading")

   }
   


}













