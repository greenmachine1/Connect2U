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
    
    var tempImageArray:[UIImage] = []
    

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
        
        tempImageArray.removeAll(keepCapacity: false)
        
        
        println("array passed in from main class \(arrayPassedInFromMainClass)")
        
        

        
        var cgpointToDoubleConversionForX:Double = Double(locationPointOfCircle!.x)
        var cgpointToDoubleConversionForY:Double = Double(locationPointOfCircle!.y)
        
        
        for(var i = 0; i < arrayPassedInFromMainClass!.count; i++){
            
            // placement around the main circle //
            var x = Double(cgpointToDoubleConversionForX) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(newProfilePics.count))
            var y = Double(cgpointToDoubleConversionForY) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(newProfilePics.count))
        
            
            var tempName: AnyObject? = newProfilePics[i].valueForKey("username")
            
            
            println("in here \(i)")
            
            var mainObjectArray:[AnyObject]? = newProfilePics[i] as? Array
            
            println("main object array --> \(mainObjectArray!)")
            
            if(mainObjectArray != nil){
                
                var pictureObject:PFFile? = mainObjectArray?.first?.objectForKey("picture") as PFFile?
                if(pictureObject != nil){
                    
                    var fileName = pictureObject!.name
                    if(fileName.rangeOfString("profilePic.png", options: nil, range: nil, locale: nil) != nil){
                        
                        println("is the profile pic")
                        
                        
                    }
                    
                    var tempImage:UIImage = UIImage(named: "default_center.png")!
                    tempImageArray.append(tempImage)
                    
                    for(var j = 0; j < tempImageArray.count; j++){
                        
                        self.createProfilePics(x, yValue: y, sizeValue: self.circleRadius!, userPicture: tempImageArray[j], selfTag: j, userNameString: tempName!.firstObject! as String, userPicBlank:false)
                    }
                    
                    
                    // updating the picture //
                    self.updatePictureAtButtonIndex(pictureObject!, index: i, temporaryImageArray: tempImageArray)
                    
                    /*
                    pictureObject!.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                        
                        if(data != nil){
                            
                            if(fileName.rangeOfString("profilePic.png", options: nil, range: nil, locale: nil) != nil){
                                
                                println("is the profile pic")
                                // need to flip the image if this is here //
                                var image:UIImage = UIImage(data: data)!
                                var flippedImage = UIImage(CGImage: image.CGImage, scale: 1.5, orientation:.LeftMirrored)
                                
                                println("index \(i)")
                                
                                tempImageArray.append(flippedImage!)
                                
                                
                            }else{
                                
                                var image = UIImage(named: "default_center.png")
                                
                                
                                println("index \(i)")
                                tempImageArray.append(image!)
                                // need to append an image here //
                                //tempImageArray.insert(image!, atIndex: i)
                                
                            }
                            

                            
                        }else{
                            
                            println("nope picture could not be downloaded -->\(error.description)")
                            
                            // just in case the image cannot be displayed //
                            var image = UIImage(named: "default_center.png")

                        }
                        
                        for(var j = 0; j < tempImageArray.count; j++){
                            
                            self.createProfilePics(x, yValue: y, sizeValue: self.circleRadius!, userPicture: tempImageArray[j], selfTag: j, userNameString: tempName!.firstObject! as String, userPicBlank:false)
                        }
                    })

                    */
                }
            }
            
            /*
            for(var j = 0; j < tempImageArray.count; j++){
                
                self.createProfilePics(x, yValue: y, sizeValue: self.circleRadius!, userPicture: tempImageArray[j], selfTag: j, userNameString: tempName!.firstObject! as String, userPicBlank:false)
            }
            */
        }
    }
    
    
    
    func updatePictureAtButtonIndex(pictureFile:PFFile ,index:Int, temporaryImageArray:Array<UIImage>){
        
        var subViews = callingViewMain!.subviews as Array<UIView>
        
        for someViews in subViews{
            
            if(someViews.isKindOfClass(UIButton)){
                if(someViews.tag < subViews.count){
                    
                    println("index \(someViews.tag)")
                    
                    if(someViews.tag == index){
                        
                        var tempButton:UIButton = someViews as UIButton
                        
                        pictureFile.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                            
                            if(data != nil){
                                
                                var image:UIImage = UIImage(data: data)!
                                
                                var imageFlipped:UIImage = UIImage(CGImage: image.CGImage, scale: 1.0, orientation: .LeftMirrored)!
                                
                                tempButton.setImage(imageFlipped, forState: UIControlState.Normal)
                                
                            }else{
                                
                                println("error in uploading \(error.description)")
                                self.updatePictureAtButtonIndex(pictureFile, index: index, temporaryImageArray:self.tempImageArray)
                                
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
    func createProfilePics(xValue:Double, yValue:Double, sizeValue:Double, userPicture:UIImage, selfTag:Int, userNameString:String, userPicBlank:Bool){
        
        var mainButton:UIButton = UIButton()
        mainButton = UIButton(frame: CGRect(x: xValue, y: yValue, width: sizeValue, height: sizeValue))
        
        if(userPicBlank == false){
            mainButton.setImage(userPicture, forState: UIControlState.Normal)
            mainButton.setImage(userPicture, forState: UIControlState.Highlighted)
        }else{
            mainButton.backgroundColor = UIColor.whiteColor()
            mainButton.setTitle("No Pic", forState: UIControlState.Normal)
            mainButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

        }
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
        mainLabel.frame = CGRect(x: xValue + Double((mainButton.frame.width / 2) - personLabelFrame!.width / 2), y: yValue + Double((mainButton.frame.size.height / 2) + 50.0), width: Double(mainLabel.frame.size.width), height: Double(mainLabel.frame.size.height))
        

        mainLabel.backgroundColor = whiteColorWithOpacity
        mainLabel.textAlignment = .Center
        
        callingViewMain!.addSubview(mainLabel)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func profileClicked(sender:UIButton){
        
        println("touched in here ")
        
        if(arrayPassedInFromMainClass != nil){

            println("sender \(sender.tag) and count \(arrayPassedInFromMainClass!.count)")
            
            // sending the person clicked back to the main view to view their profile or chat //
            delegate?.returnPersonClicked(arrayPassedInFromMainClass![sender.tag])
        }
    }
}
