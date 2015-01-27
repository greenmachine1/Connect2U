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
        
        println("new profile pics--- > \(newProfilePics)")
        println("new Profile pics! \(newProfilePics.count)")
        

        
        
    
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
        
            
            var tempName: AnyObject? = newProfilePics[i].valueForKey("username")
            //var tempPic:AnyObject? = newProfilePicsi].valueForKey("picture")
            
            
            
            
            
            
            // need to come in here and look up each individual picture one at a time //
            
            
            var objectData:[AnyObject] = arrayPassedInFromMainClass! as Array
            if(objectData.count != 0){
                
                var fileObject:AnyObject = objectData[i].valueForKey("picture") as AnyObject!
                println("file object \(fileObject)")
                
                if(!(fileObject.isEqual(nil))){
                    
                    var theFinalFile:PFFile = fileObject.firstObject as PFFile
                    
                    if(!(theFinalFile.isEqual(nil))){
                        
                        
                        theFinalFile.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                            
                            if(data != nil){
                                
                                println("in here debug ")
                                var imageOfMe:UIImage = UIImage(data: data)!
                                
                                var flippedImage = UIImage(CGImage: imageOfMe.CGImage, scale: 1.5, orientation:.LeftMirrored)
                                
                                
                                if((tempName != nil) && (flippedImage != nil)){

                                    
                                    self.createProfilePics(x, yValue: y, sizeValue: self.circleRadius!, userPicture: flippedImage!, selfTag: i, userNameString: tempName!.firstObject! as String)
                                }
                            }
                        })
                    }
                }
                
            }
            

        }
    }
    
    
    
    
    
    // removing the button and label from the scene //
    // this is kinda redundant but will have to do for now //
    func updateProfilePics(newProfilePics:Array<AnyObject>){
    
        var newArray:Array<AnyObject> = newProfilePics
                
        self.drawProfilePics(newArray)
    }
    
    
    
    
    
    
    // creation of the profile pics //
    func createProfilePics(xValue:Double, yValue:Double, sizeValue:Double, userPicture:UIImage, selfTag:Int, userNameString:String){
        
        var mainButton:UIButton = UIButton()
        
        mainButton = UIButton(frame: CGRect(x: xValue, y: yValue, width: sizeValue, height: sizeValue))
        mainButton.setImage(userPicture, forState: UIControlState.Normal)
        mainButton.setImage(userPicture, forState: UIControlState.Highlighted)
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
        
        println("touched in here ")
        
        if(arrayPassedInFromMainClass != nil){

            println("sender \(sender.tag) and count \(arrayPassedInFromMainClass!.count)")
            
            // sending the person clicked back to the main view to view their profile or chat //
            delegate?.returnPersonClicked(arrayPassedInFromMainClass![sender.tag - 1])
        }
        
        

        
    }
}
