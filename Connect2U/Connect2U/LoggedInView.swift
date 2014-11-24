//
//  LoggedInView.swift
//  Connect2U
//
//  Created by Cory Green on 11/23/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit


class LoggedInView: NSObject {
    
    var circleRadius:CGFloat?
    var locationOfCircle:CGPoint?
    let colorPalette = ColorPalettes()
    let mainView:UIView!
    let circle:CAShapeLayer = CAShapeLayer()
    

    
    var peopleArray:Array<String>?
    
    
    
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
        
        self.createOtherPeoplePictures()
    }



    // creation of the main circle //
    func createCircle(){
        
        circle.path = UIBezierPath(roundedRect: CGRectMake(locationOfCircle!.x - 50, locationOfCircle!.y - 50, CGFloat(2.0 * circleRadius!), CGFloat(2.0 * circleRadius!)), cornerRadius: CGFloat(circleRadius!)).CGPath
        
        println("location of circle : x : \(locationOfCircle!.x) y : \(locationOfCircle!.y)")
        
        
        // the fill color //
        circle.fillColor = colorPalette.darkGreenColor.CGColor
     
        self.mainView.layer.addSublayer(circle)
  
    }
    

    
    
    
    func createOtherPeoplePictures(){
        
        for(var i = 1; i < 4; i++){
            
            
            
            
            
            
            // this is the angle //
            // dividing the circle by the amount of pictures present //
            var division:Double = 360.0 / 4.0
            
            
            
            
        
            // x and y values //
            var x = Double(circleRadius! * 1.5) * cos(division * Double(i))
            var y = Double(circleRadius! * 1.5) * sin(division * Double(i))
            
            println("\(x):\(y)")
            
            
        
            var otherPersonButton:UIButton = UIButton(frame: CGRect(x:locationOfCircle!.x + CGFloat(x), y:locationOfCircle!.y + CGFloat(y), width:100.0, height:100.0))
            
            otherPersonButton.setImage(UIImage(named: "face\(i).png"), forState: UIControlState.Normal)
            otherPersonButton.layer.cornerRadius = 50
            otherPersonButton.layer.borderWidth = 3.0
            otherPersonButton.layer.borderColor = UIColor.blackColor().CGColor
            otherPersonButton.clipsToBounds = true
        
            self.mainView.addSubview(otherPersonButton)
        
        }
        
        
        
        
        
        
    }
    
    
    
    


}
