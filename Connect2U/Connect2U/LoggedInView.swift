//
//  LoggedInView.swift
//  Connect2U
//
//  Created by Cory Green on 11/23/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

// creating a new sidebar delegate //
// one required function and 2 optional //
@objc protocol CircleDelegate{
    
    // function required for implementing this delegate //
    func didClickOnUser(index:Int, nameOfPerson:Array<String>)
    
}


class LoggedInView: NSObject {
    
    var circleRadius:CGFloat?
    var locationOfCircle:CGPoint?
    let colorPalette = ColorPalettes()
    let mainView:UIView!
    let circle:CAShapeLayer = CAShapeLayer()
    var peopleArray:Array<String>?
    
    // delegate variable //
    var delegate:CircleDelegate?
    
    
    
    override init(){
        super.init()
    }
    
    
    
    // custom init //
    init(callingView:UIView, circleSize:Int , location:CGPoint, otherPeople:Array<String>){
        super.init()
        
        circleRadius = CGFloat(circleSize)
        
        locationOfCircle = location
        
        mainView = callingView
        
        peopleArray = otherPeople
        
        self.createCircle()
        
    }



    // creation of the main circle //
    func createCircle(){
        
        circle.path = UIBezierPath(roundedRect: CGRectMake(locationOfCircle!.x - 50, locationOfCircle!.y - 50, CGFloat(2.0 * circleRadius!), CGFloat(2.0 * circleRadius!)), cornerRadius: CGFloat(circleRadius!)).CGPath
        
        // the fill color //
        circle.fillColor = colorPalette.darkGreenColor.CGColor
     
        self.mainView.layer.addSublayer(circle)
  
    }
    

    
    
    
    func createOtherPeoplePictures(){
        
        for(var i = 0; i < peopleArray!.count; i++){
            
    
            // placement around the main circle //
            var x = Double(locationOfCircle!.x) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(peopleArray!.count))
            var y = Double(locationOfCircle!.y) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(peopleArray!.count))
            
            
            // creation of the picture buttons //
            var otherPersonButton:UIButton = UIButton(frame: CGRect(x: x, y: y, width: 100.0, height: 100.0))
            
            otherPersonButton.setImage(UIImage(named: "face\(1).png"), forState: UIControlState.Normal)
            otherPersonButton.layer.cornerRadius = 50
            otherPersonButton.layer.borderWidth = 3.0
            otherPersonButton.layer.borderColor = UIColor.blackColor().CGColor
            otherPersonButton.clipsToBounds = true
            otherPersonButton.tag = i
        
            otherPersonButton.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
            self.mainView.addSubview(otherPersonButton)
        }
    }
    
    
    
    // what happens when a person is clicked //
    func personClicked(sender:UIButton){
        
        var personClickedOnIndex:Int = Int(sender.tag)
        
        // sending the info back to the LoggedIn View //
        delegate?.didClickOnUser(personClickedOnIndex, nameOfPerson: peopleArray!)
    }
    
    
    
    
}
