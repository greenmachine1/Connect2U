//
//  DrillDownPeople.swift
//  Connect2U
//
//  Created by Cory Green on 11/26/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class DrillDownPeople: NSObject {
    
    var arrayOfPeopleToReturn:Array<String>?
    
    
    override init() {
        super.init()
    }
    

    init(passedInArrayOfPeople:Array<AnyObject!>) {
        super.init()
        
        
        
    }
    
    
    
    // these functions will allow the user to drill down information //
    // based on criteria //
    
    // age //
    func updateDataBasedOnAge(passedInArrayOfPeople:Array<AnyObject!>) ->Array<AnyObject!>{
        
        var newAgeArray:Array<AnyObject>?
        
        
        
        
        // will return a new array of people who pertain to age //
        return newAgeArray!
    }
    
    
    // gender //
    func updateDataBasedOnGender(passedInArrayOfPeople:Array<AnyObject!>) ->Array<AnyObject!>{
        
        var newGenderArray:Array<AnyObject>?
        
        
        
        
        // will return a new array of people who pertain gender //
        return newGenderArray!
    }
    
    
    // interests //
    func updateDataBasedOnInterest(passedInArrayOfPeople:Array<AnyObject!>) ->Array<AnyObject!>{
        
        var newInterestsArray:Array<AnyObject>?
        
        
        
        // will return a new array of people who pertain to the interests //
        return newInterestsArray!
    }
    
    
    
    
    

}
