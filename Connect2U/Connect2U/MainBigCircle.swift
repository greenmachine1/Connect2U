//
//  MainBigCircle.swift
//  Connect2U
//
//  Created by Cory Green on 11/28/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class MainBigCircle: NSObject {
    
    let theMainView:UIView!
    var radiusOfTheMainCircle:Double?
    var locationOfCircle:CGPoint?
    let circle:CAShapeLayer = CAShapeLayer()
    
    let palette:ColorPalettes = ColorPalettes()
   
    override init() {
        super.init()
    }
    
    // override
    init(mainView:UIView, radiusOfCircle:Double, location:CGPoint) {
        super.init()
        
        theMainView = mainView
        radiusOfTheMainCircle = radiusOfCircle
        locationOfCircle = location
        
        self.createCircle()
        
    }
    
    func createCircle(){
        
        circle.path = UIBezierPath(roundedRect: CGRectMake(locationOfCircle!.x - 100,
            locationOfCircle!.y - 100, CGFloat(3.0 * radiusOfTheMainCircle!),
            CGFloat(3.0 * radiusOfTheMainCircle!)),
            cornerRadius: CGFloat(radiusOfTheMainCircle!)).CGPath
        
        
        // the fill color //
        circle.fillColor = palette.darkGreenColor.CGColor
        
        self.theMainView.layer.addSublayer(circle)
        
        
    }
    
}
