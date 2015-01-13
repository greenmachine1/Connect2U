//
//  IBeaconTransmitData.swift
//  Connect2U
//
//  Created by Cory Green on 1/11/15.
//  Copyright (c) 2015 com.Cory. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class IBeaconTransmitData: NSObject, CLLocationManagerDelegate,CBPeripheralManagerDelegate {
   
    var beaconRegion:CLBeaconRegion = CLBeaconRegion()

    //let _locationManagerThing:CLLocationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "5BB5174B-D0B1-402B-9DEC-CDFB00E3C58E")
    let identifierString = "com.Cory.MessingAroundWithiBeacons"
    
    var beaconPeripheralData:NSDictionary?
    var peripheralManager = CBPeripheralManager()
    
    override init(){
        super.init()
        
        
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
}
