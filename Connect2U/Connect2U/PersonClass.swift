//
//  PersonClass.swift
//  Connect2U
//
//  Created by Cory Green on 11/24/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class PersonClass: NSObject {
    
    var nameString:String?
    var pictureString:String?
    var genderString:String?
    var interestsArray:Array<String>?
   
    override init(){
        super.init()
        
    }
    
    
    // custom init //
    init(name:String, picture:String, gender:String, interests:Array<String>) {
        super.init()
        
        nameString = name
        pictureString = picture
        genderString = gender
        interestsArray = interests
    }
    
    
    
    
}
