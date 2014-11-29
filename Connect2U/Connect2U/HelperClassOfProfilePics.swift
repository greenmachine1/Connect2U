//
//  HelperClassOfProfilePics.swift
//  Connect2U
//
//  Created by Cory Green on 11/28/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

@objc protocol ReturnWithPersonClicked{
    
    // returns to the main view with the person clicked //
    func returnPersonClicked(person:AnyObject)
    
}


class HelperClassOfProfilePics: NSObject {
   
    let locationPointOfCircle:CGPoint?
    var arrayPassedInFromMainClass:Array<AnyObject>?
    var circleRadius:Double?
    var callingViewMain:UIView?
    var palette:ColorPalettes?
    
    var delegate:ReturnWithPersonClicked?
    

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
        
        arrayPassedInFromMainClass!.removeAll(keepCapacity: false)
        arrayPassedInFromMainClass = newProfilePics
        
        println("\(arrayPassedInFromMainClass!.count)")
        
        
        var cgpointToDoubleConversionForX:Double = Double(locationPointOfCircle!.x)
        var cgpointToDoubleConversionForY:Double = Double(locationPointOfCircle!.y)
        
        for(var i = 0; i < newProfilePics.count; i++){
            
            // placement around the main circle //
            var x = Double(cgpointToDoubleConversionForX) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(newProfilePics.count))
            var y = Double(cgpointToDoubleConversionForY) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(newProfilePics.count))
        
            
            
            var tempName:String = newProfilePics[i].objectForKey("username") as NSString
            var tempPic:String = newProfilePics[i].objectForKey("picture") as NSString

            self.createProfilePics(x, yValue: y, sizeValue: circleRadius!, userPictureString: tempPic, selfTag: i + 1, userNameString:tempName)
            
            
        }

    }
    
    
    
    
    
    // removing the button and label from the scene //
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
            if(someView.isKindOfClass(UILabel)){
                for(var l = 0; l < subViews.count; l++){
                    if(someView.tag == l + 1){
                        
                        someView.removeFromSuperview()
                    }
                }
            }
        }
        self.drawProfilePics(newProfilePics)
    }
    
    
    
    
    
    
    // creation of the profile pics //
    func createProfilePics(xValue:Double, yValue:Double, sizeValue:Double, userPictureString:String, selfTag:Int, userNameString:String){
        
        var mainButton:UIButton = UIButton()
        
        mainButton = UIButton(frame: CGRect(x: xValue, y: yValue, width: sizeValue, height: sizeValue))
        mainButton.setImage(UIImage(named: userPictureString), forState: UIControlState.Normal)
        mainButton.layer.cornerRadius = 50
        mainButton.layer.borderWidth = 3.0
        mainButton.layer.borderColor = UIColor.blackColor().CGColor
        mainButton.tag = selfTag
        mainButton.clipsToBounds = true
        
        mainButton.addTarget(self, action: Selector("profileClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        callingViewMain!.addSubview(mainButton)
        
        
        
        
        
        // creating the name label //
        var mainLabel:UILabel = UILabel()
        var whiteColorWithOpacity:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        
        mainLabel.text = userNameString
        mainLabel.textColor = UIColor.blackColor()
        mainLabel.sizeToFit()
        mainLabel.layer.cornerRadius = 5.0
        mainLabel.clipsToBounds = true
        mainLabel.tag = selfTag
        
        // getting the resized frame //
        var personLabelFrame:CGRect?
        personLabelFrame = mainLabel.frame
        
        
        // getting the exact center of the circle and putting a label there... slightly below center //
        mainLabel.frame = CGRect(x: xValue + Double((mainButton.frame.width / 2) - personLabelFrame!.width / 2), y: yValue + Double((mainButton.frame.size.height / 2) + 30.0), width: Double(mainLabel.frame.size.width), height: Double(mainLabel.frame.size.height))
        
        
        
        
        mainLabel.backgroundColor = whiteColorWithOpacity
        mainLabel.textAlignment = .Center
        
        callingViewMain!.addSubview(mainLabel)
        
    }
    
    
    
    
    func profileClicked(sender:UIButton){
        
        if(arrayPassedInFromMainClass != nil){
            
            println(arrayPassedInFromMainClass![sender.tag - 1].objectForKey("username")!)
        }
        
        
        // sending the person clicked back to the main view to view their profile or chat //
        delegate?.returnPersonClicked(arrayPassedInFromMainClass![sender.tag - 1])
        
        
        
        
    }
}
