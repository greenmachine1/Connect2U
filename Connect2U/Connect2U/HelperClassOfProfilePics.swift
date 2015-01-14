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
    
    var previousPeopleArray:Array<AnyObject>?
    
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
        
        previousPeopleArray = arrayPassedIn
        
        self.drawProfilePics(arrayPassedIn)
        
        
        
    }
    
    
    func drawProfilePics(newProfilePics:Array<AnyObject>){
        
        //println("previous people : \(previousPeopleArray!)")
        
        println("new profile pics--- > \(newProfilePics)")
        println("new Profile pics! \(newProfilePics.count)")
        
        
        
        for(var i = 0; i < newProfilePics.count; i++){
            
            //println(newProfilePics[i].valueForKey("username")!)
            //println(newProfilePics[i].valueForKey("picture")!)
            
            //var tempName:String = String(newProfilePics[i].valueForKey("username")! as NSString)
            //var tempPic:String = String(newProfilePics[i].valueForKey("picture")! as NSString)
            
            var tempName: AnyObject? = newProfilePics[i].valueForKey("username")
            var tempPic:AnyObject? = newProfilePics[i].valueForKey("picture")
            
            
            println("both values --> \(tempName!.firstObject! as String)")
            println("both values --> \(tempPic!.firstObject! as String)")
        }
        
        
        //println("new profile pics name -- >\(newProfilePics[0])")
        
        
    
        var subViews = callingViewMain!.subviews as Array<UIView>
        
        for someViews in subViews{
            
            if(someViews.isKindOfClass(UIButton)){
                if(someViews.tag < subViews.count){
                    someViews.removeFromSuperview()
                }
            }
            
            if(someViews.isKindOfClass(UILabel)){
                if(someViews.tag < subViews.count){
                    someViews.removeFromSuperview()
                }
            }
        }
        
        
        arrayPassedInFromMainClass!.removeAll(keepCapacity: false)
        arrayPassedInFromMainClass = newProfilePics
        
        var cgpointToDoubleConversionForX:Double = Double(locationPointOfCircle!.x)
        var cgpointToDoubleConversionForY:Double = Double(locationPointOfCircle!.y)
        
        for(var i = 0; i < arrayPassedInFromMainClass!.count; i++){
            
            // placement around the main circle //
            var x = Double(cgpointToDoubleConversionForX) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(newProfilePics.count))
            var y = Double(cgpointToDoubleConversionForY) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(newProfilePics.count))
        
            
            /*
            var tempName:String = newProfilePics[i].objectForKey("username") as NSString
            var tempPic:String = newProfilePics[i].objectForKey("picture") as NSString
            
            
            

            self.createProfilePics(x, yValue: y, sizeValue: circleRadius!, userPictureString: tempPic, selfTag: i, userNameString:tempName)
            */
            //var tempName:String = newProfilePics[i].valueForKey("username")!
            //var tempPic:String = newProfilePics[i].valueForKey("picture")!
            
            var tempName: AnyObject? = newProfilePics[i].valueForKey("username")
            var tempPic:AnyObject? = newProfilePics[i].valueForKey("picture")
            
            self.createProfilePics(x, yValue: y, sizeValue: circleRadius!, userPictureString: tempPic!.firstObject! as String, selfTag: i, userNameString:tempName!.firstObject! as String)
        }

    }
    
    
    
    
    
    // removing the button and label from the scene //
    // this is kinda redundant but will have to do for now //
    func updateProfilePics(newProfilePics:Array<AnyObject>){
    
        var newArray:Array<AnyObject> = newProfilePics
                
        self.drawProfilePics(newArray)
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
        mainButton.alpha = 0
        mainButton.clipsToBounds = true
        
        // animating the picture //
        mainButton.addTarget(self, action: Selector("profileClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveLinear & .AllowUserInteraction & .BeginFromCurrentState, animations: { () -> Void in
            mainButton.alpha = 1
        }, completion: nil)
        
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
        mainLabel.alpha = 0
        
        // animating the label //
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveLinear & .AllowUserInteraction & .BeginFromCurrentState, animations: { () -> Void in
            mainLabel.alpha = 1
            }, completion: nil)
        
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
            
            //println(arrayPassedInFromMainClass![sender.tag].objectForKey("username")!)
            println(arrayPassedInFromMainClass![sender.tag].objectForKey("username")!)
        }
        
        
        // sending the person clicked back to the main view to view their profile or chat //
        delegate?.returnPersonClicked(arrayPassedInFromMainClass![sender.tag])
        
    }
}
