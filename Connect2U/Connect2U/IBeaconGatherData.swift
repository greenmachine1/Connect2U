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

class IBeaconGatherData: NSObject, CLLocationManagerDelegate {
    
    var beaconRegion:CLBeaconRegion = CLBeaconRegion()
    var _beaconRegion:CLBeaconRegion = CLBeaconRegion()
    let locationManagerThing:CLLocationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "5BB5174B-D0B1-402B-9DEC-CDFB00E3C58E")
    let identifierString = "com.Cory.MessingAroundWithiBeacons"
    
   
   var tempBeaconArray:Array<AnyObject> = []
    
    override init(){
        super.init()
        
        locationManagerThing.delegate = self
        locationManagerThing.requestWhenInUseAuthorization()
        

    }



    
    func stopRecieving(){
        
        var tempBeacon:CLBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        self.locationManagerThing.stopRangingBeaconsInRegion(tempBeacon)
        
        tempBeaconArray.removeAll(keepCapacity: false)
    }
    
    
    
    
    
    
    
    
    
    
    // -------- recieve beacon section ----------- //
    
    
    func initRegion(){
        
        self._beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        if(!(self._beaconRegion.isEqual(nil))){
            
            self.locationManagerThing.startMonitoringForRegion(self._beaconRegion)
        }
        
        self.locationManager(self.locationManagerThing, didStartMonitoringForRegion: self._beaconRegion)
    }
    
    
    
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        
        if(!(self._beaconRegion.isEqual(nil))){
            
            
            
            self.locationManagerThing.startRangingBeaconsInRegion(self._beaconRegion)
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
        println(region.description)
        
        
        self.locationManagerThing.startRangingBeaconsInRegion(self._beaconRegion)
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        
        self.locationManagerThing.stopRangingBeaconsInRegion(self._beaconRegion)
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
      
      println("whats coming in! == \(inComingObjects)")
      
      var inComingArrayArray:Array = Array<AnyObject>()
      inComingArrayArray = inComingObjects as Array
      

      if(tempBeaconArray.isEmpty){
         
         tempBeaconArray = inComingArrayArray
         
         for (index, elements) in enumerate(tempBeaconArray){
            
            var majorNumber: AnyObject! = elements.objectForKey("major")
            var minorNumber: AnyObject! = elements.objectForKey("minor")
            
            //send to server
            println("initial array sent to server ")
         }
      
      }
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      /*
      for (index, elements) in enumerate(inComingArrayArray){
         
         for(_index, _elements) in enumerate(tempBeaconArray){
            
            if(_elements.valueForKey("major")!.isEqual(elements.valueForKey("major")!)){
               
               println("equal and stuff")
            }else{
               
               println("not equal")
               tempBeaconArray = inComingArrayArray
            }
            
            
         }
         
      }
      */
      
      
      
      
      
      
      
      
      /*
      for (index, elements) in enumerate(inComingArrayArray){
         
         var majorNumber: AnyObject! = elements.objectForKey("major")
         var minorNumber: AnyObject! = elements.objectForKey("minor")
         
         println("major \(majorNumber), minor \(minorNumber)")
         
         for (_index, _elements) in enumerate(tempBeaconArray){
            
            var _majorNumber: AnyObject! = _elements.objectForKey("major")
            var _minorNumber: AnyObject! = _elements.objectForKey("minor")
            
            if((_majorNumber as Int == majorNumber as Int) && (_minorNumber as Int == _minorNumber as Int)){
               
               println("\n they are the same number\n ")
            }else{
               
               println("\n \n\n \n \n \n \n \n They arent the same number\n \n \n \n \n \n \n \n \n ")
               tempBeaconArray = inComingArrayArray
               
               println("temp array : \(tempBeaconArray)")
               
            }
            
         }
         
         
      }
      */
      
      
      
      
      /*
      var inComingArrayArray:Array = Array<AnyObject>()
      inComingArrayArray = inComingArray as Array
      
      if(tempBeaconArray.isEmpty){
         
         tempBeaconArray = inComingArrayArray
      }
      
      for (index, element) in enumerate(inComingArrayArray){
         
         println("\n \n \(element)\n \n")
         
         if(element.isEqual(tempBeaconArray[0])){
            
            println("they are the same")
         }else{
            
            println("they are not the same")
         }
         
      }
      */
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      /*
      if(tempBeaconArray.count != inComingArrayArray.count){
         
         tempBeaconArray = inComingArrayArray
         
         println("\n \n not equal and should be sent to the server\n \n \n ")
         
         for (index, elements) in enumerate(tempBeaconArray){
            
            println("elements --> \(elements.major), \(elements.minor)")
            
            var majorNumber:Int = elements.major as Int
            var minorNumber:Int = elements.minor as Int
            
            self.lookUpUserByMajorAndMinor(majorNumber, minorNumber: minorNumber)
            
         }
      }
      
      
      for (index,elements) in enumerate(inComingArrayArray){
         
         if((!(tempBeaconArray[index].major == elements.major)) || (inComingArrayArray[index].proximity == CLProximity.Unknown)){
            
            tempBeaconArray = inComingArrayArray
            
            println("\n \n not equal and should be sent to the server\n \n \n ")
            
         }else{
            
            println("equal")
            
         }
         
      }
      
      println("tempBeaconArray -- > \(tempBeaconArray)")
      */
      

      
      /*
      tempBeaconArray.removeAll(keepCapacity: false)
         
      for (index, element) in enumerate(inComingArrayArray){
            
         if(element.proximity != CLProximity.Unknown){
            
            tempBeaconArray.insert(element, atIndex: index)
            
         }
            
      }
      
      if(tempBeaconArray.count != 0){
         
         println("temp beacon array -- > \(tempBeaconArray)")
         println("count in that array --> \(tempBeaconArray.count)")
         
      }else{
         
         println("the array is empty")
         
      }
      */
         
      
      
      
      
      
      
      
      
      
      
      
      /*
      for(var i = 0; i < inComingArrayArray.count; i++){
         
         if(!(inComingArrayArray[i].proximity == CLProximity.Unknown)){
            
            tempBeaconArray.removeAll(keepCapacity: false)
            
            tempBeaconArray.insert(inComingArrayArray[i], atIndex: i)
            
         }else{
            
            tempBeaconArray.removeAtIndex(i)
            break
         }
      }
      
      println("array count --> \(tempBeaconArray.count)")
      */
      
      
      /*
      for(var j = 0; j < inComingArrayArray.count; j++){
         
         if(inComingArrayArray[j].proximity == CLProximity.Unknown){
            
            
            println("lost the beacon --> \(inComingArrayArray[j])")
            
            for(var k = 0; k < tempBeaconArray.count; k++){
               
               if(tempBeaconArray[k].isEqual(inComingArrayArray[k])){
                  
                  println("equal and should be removed")
                  
               }
            }
         }
         
      }
      */
      
      //println("temp beacon array : \(tempBeaconArray)")
      /*
      for itemsInInComingArray in inComingArrayArray{
         
         // if the proximity has gone to unknown, that beacon has //
         // gone out of range and therefor should be removed from //
         // the main array //
         if(itemsInInComingArray.proximity == CLProximity.Unknown){
         
            println("lost the beacon --> out of range with --> \(itemsInInComingArray)")
            
            /*
            for(var i = 0; i < tempBeaconArray.count; i++){
               
               if(tempBeaconArray[i].isEqual(itemsInInComingArray)){
                  
                  println("same object")
                  //tempBeaconArray.removeAtIndex(i)
                  
               }
               
            }
            */
            
            
         }
         
      }
      
      //println("temp beacon array \(tempBeaconArray)")

      */
    }

    
    
    
    
    // looking up the user by major and minor values //
    func lookUpUserByMajorAndMinor(majorNumber:Int, minorNumber:Int){
        
        println("this is in the function \(majorNumber), \(minorNumber)")
        
        
        PFCloud.callFunctionInBackground("findUsersIBeacon", withParameters: ["major":majorNumber,"minor":minorNumber]) { (results:AnyObject!, error:NSError!) -> Void in
            
            if(error == nil){
                
                println("results are in! : \(results.description)")
                
            }
            
        }
        
        
    }

}













