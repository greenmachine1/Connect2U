//
//  MainProfilePics.swift
//  Connect2U
//
//  Created by Cory Green on 11/28/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class MainProfilePics: NSObject {
   
    var userNameString:String?
    var userPictureString:String?
    var xValue:Double?
    var yValue:Double?
    var sizeValue:Double?
    var selfTag:Int?
    
    let mainView:UIView?
    
    var frameOfView:CGRect?
    var mainButton:UIButton?
    var mainLabel:UILabel?
    
    var circleAroundPeople:CAShapeLayer?
    
    
    var palette:ColorPalettes = ColorPalettes()
    
    
    override init() {
        super.init()
    }
    
    // my custom override init //
    
    init(viewMain:UIView,userName:String, userPicture:String, xLocation:Double, yLocation:Double, size:Double, tag:Int) {
        super.init()
        
        userNameString = userName
        userPictureString = userPicture
        xValue = xLocation
        yValue = yLocation
        sizeValue = size
        selfTag = tag
        mainView = viewMain
        
        //self.createCircleAroundPeople()
        //self.createPersonLabel()
        self.createProfilePics()
        
        
    }

    
    
    
    
    
    // creation of the profile pics //
    func createProfilePics(){
        
        mainButton = UIButton(frame: CGRect(x: xValue!, y: yValue!, width: sizeValue!, height: sizeValue!))
        mainButton!.setImage(UIImage(named: userPictureString!), forState: UIControlState.Normal)
        mainButton!.layer.cornerRadius = 50
        mainButton!.layer.borderWidth = 3.0
        mainButton!.layer.borderColor = UIColor.blackColor().CGColor
        mainButton!.tag = selfTag!
        mainButton!.clipsToBounds = true
        
        self.mainView!.addSubview(mainButton!)
        
        
    }
    
    
    func createCircleAroundPeople(){
        
        
        // creating a layer behind the persons profile pic //
        circleAroundPeople = CAShapeLayer()
        
        circleAroundPeople!.path = UIBezierPath(roundedRect: CGRectMake(CGFloat(xValue! - 5.0) ,
            CGFloat(yValue! - 5.0), CGFloat(1.1 * sizeValue!),
            CGFloat(1.1 * sizeValue!)),
            cornerRadius: CGFloat(sizeValue!)).CGPath
        
        circleAroundPeople!.fillColor = palette.lightBlueColor.CGColor
        
        self.mainView?.layer.addSublayer(circleAroundPeople)
        
    }
    
    
    func createPersonLabel(){
        
        // creating the name label //
        mainLabel = UILabel()
        var whiteColorWithOpacity:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        
        mainLabel!.text = userNameString
        mainLabel!.textColor = UIColor.blackColor()
        mainLabel!.sizeToFit()
        mainLabel!.layer.cornerRadius = 5.0
        mainLabel!.clipsToBounds = true
        mainLabel!.tag = selfTag!
        
        // getting the resized frame //
        var personLabelFrame:CGRect = mainLabel!.frame
        
        
        // getting the exact center of the circle and putting a label there... slightly below center //
        mainLabel!.frame = CGRect(x: xValue! + Double((mainButton!.frame.width / 2) - personLabelFrame.width / 2), y: yValue! + Double((mainButton!.frame.size.height / 2) - 40.0), width: Double(mainLabel!.frame.size.width), height: Double(mainLabel!.frame.size.height))
        
        mainLabel!.backgroundColor = whiteColorWithOpacity
        mainLabel!.textAlignment = .Center
        
        self.mainView?.addSubview(mainLabel!)
        
        
    }
    
}








