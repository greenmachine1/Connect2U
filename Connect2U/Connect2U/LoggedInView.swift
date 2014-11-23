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
        
        
        // the fill color //
        circle.fillColor = colorPalette.darkGreenColor.CGColor
     
        self.mainView.layer.addSublayer(circle)
        
    }
    
    
    func createOtherPeoplePictures(){
        
        
        
        
        var nameLabel:UILabel = UILabel(frame: CGRect(x: 100.0, y: 100.0, width: 100.0, height: 30.0))
        nameLabel.backgroundColor = colorPalette.darkGreenColor
        nameLabel.text = "Name"
        
        self.mainView.addSubview(nameLabel)
        
    }
    
    
    
    


}
