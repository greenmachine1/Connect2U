//
//  HelperClassOfProfilePics.swift
//  Connect2U
//
//  Created by Cory Green on 11/28/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class HelperClassOfProfilePics: NSObject {
   
    let locationPointOfCircle:CGPoint?
    let arrayPassedInFromMainClass:Array<AnyObject>?
    var circleRadius:Double?
    var callingViewMain:UIView?
    
    

    override init() {
        super.init()
    }
    
    
    // custom init //
    init(callingView:UIView,location:CGPoint, arrayPassedIn:Array<AnyObject>, circleOfRadius:Double) {
        super.init()
        
        locationPointOfCircle = location
        arrayPassedInFromMainClass = arrayPassedIn
        circleRadius = circleOfRadius
        callingViewMain = callingView
        
        self.drawProfilePics(arrayPassedIn)
        
    }
    
    
    func drawProfilePics(newProfilePics:Array<AnyObject>){
        
        
        var cgpointToDoubleConversionForX:Double = Double(locationPointOfCircle!.x)
        var cgpointToDoubleConversionForY:Double = Double(locationPointOfCircle!.y)
        
        for(var i = 0; i < newProfilePics.count; i++){
            
            // placement around the main circle //
            var x = Double(cgpointToDoubleConversionForX) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(newProfilePics.count))
            var y = Double(cgpointToDoubleConversionForY) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(newProfilePics.count))
        
            
            
            //var tempName:String = newProfilePics[i].username
            //var tempPic:String = newProfilePics[i].picture
            
            var tempName = "Jeorge"
            var tempPic = "face3.png"
    
            var mainProfilePics:MainProfilePics = MainProfilePics(viewMain: callingViewMain!, userName: tempName, userPicture: tempPic, xLocation: x, yLocation: y, size: circleRadius!, tag: i + 1)
    
        }

    }
    
    
    
    
    func updateProfilePics(newProfilePics:Array<AnyObject>){
        
        var subViews = callingViewMain!.subviews as Array<UIView>
        
        for someView in subViews{
        
            if(someView.isKindOfClass(UIButton)){
                
                for(var k = 0; k < subViews.count; k++){
                
                    if(someView.tag == k + 1){
                
                        someView.removeFromSuperview()
                    }
                }
            }
        }
    
        self.drawProfilePics(newProfilePics)
        
    }
    
}
