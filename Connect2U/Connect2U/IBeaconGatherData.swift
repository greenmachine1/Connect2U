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

class IBeaconGatherData: NSObject, CLLocationManagerDelegate,CBPeripheralManagerDelegate {
    
    var beaconRegion:CLBeaconRegion = CLBeaconRegion()
    let locationManagerThing:CLLocationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "5BB5174B-D0B1-402B-9DEC-CDFB00E3C58E")
    let identifierString = "com.Cory.MessingAroundWithiBeacons"
    
    
    var beaconPeripheralData:NSDictionary?
    var peripheralManager = CBPeripheralManager()
    
    var major:Int?
    var minor:Int?
    
    override init(){
        super.init()
        
        locationManagerThing.delegate = self
        locationManagerThing.requestWhenInUseAuthorization()
        
        
        
        
        // my line of thinking is that once the random number gets generated //
        // it will get passed to the server along with that user //
        // the reciever will pick it up once it comes accross it and then go back //
        // to the server and retrieve that users data //
        // once the users accuracy is too large or the users distance is unknown //
        // that user no longer is within range... very simple //
        
        // need to create random major and minor numbers //
        
        
        
        // listening for beacon activity //
        //self.initRegion()
        
        //self.transmitBeacon()
    }
    
    
    
    
    // ------ transmit beacon section -------- //

    // transmits the beacon //
    func transmitBeacon(majorNumber:Int, minorNumber:Int){
        
        var tempMajor = UInt16(majorNumber)
        var tempMinor = UInt16(minorNumber)
        
        // for some reason I have to conver the numbers to UInt16 //
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: tempMajor, minor: tempMinor, identifier: identifierString)
        
        self.beaconPeripheralData = self.beaconRegion.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)

        
    }
    
    
    
    
    func stopTransmitting(){
        
        var tempBeacon:CLBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        self.peripheralManager.stopAdvertising()
        self.locationManagerThing.stopRangingBeaconsInRegion(tempBeacon)
    }
    
    
    
    
    // required method for CBPeripheralManagerDelegate //
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if(peripheral.state == CBPeripheralManagerState.PoweredOn){
            println("Powered on")
            self.peripheralManager.startAdvertising(self.beaconPeripheralData)
            
        }else if(peripheral.state == CBPeripheralManagerState.PoweredOff){
            println("Powered off")
            
            self.peripheralManager.stopAdvertising()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // -------- recieve beacon section ----------- //
    
    
    func initRegion(){
        
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifierString)
        
        if(!(self.beaconRegion.isEqual(nil))){
            
            self.locationManagerThing.startMonitoringForRegion(self.beaconRegion)
        }
        
        self.locationManager(self.locationManagerThing, didStartMonitoringForRegion: self.beaconRegion)
    }
    
    
    
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        
        if(!(self.beaconRegion.isEqual(nil))){
            
            self.locationManagerThing.startRangingBeaconsInRegion(self.beaconRegion)
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
        println(region.description)
        
        
        self.locationManagerThing.startRangingBeaconsInRegion(self.beaconRegion)
        
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        
        self.locationManagerThing.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
    
    // coming within range of beacon... //
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
    
        
        println("all beacons \(beacons)")
    
    }
    

   
}
