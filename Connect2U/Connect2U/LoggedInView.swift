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
    func didClickOnUser(index:Int, nameOfPerson:Array<AnyObject>)
    
}


class LoggedInView: NSObject {
    
    var circleRadius:CGFloat?
    var locationOfCircle:CGPoint?
    let colorPalette = ColorPalettes()
    let mainView:UIView!
    let circle:CAShapeLayer = CAShapeLayer()
    var peopleArray:Array<AnyObject> = []
    
    var otherPersonButton:UIButton?
    var personLabel:UILabel?
    var circleAroundPeople:CAShapeLayer?
    
    // delegate variable //
    var delegate:CircleDelegate?
    
    
    
    override init(){
        super.init()
        
        self.peopleArray.removeAll(keepCapacity: false)
    }
    
    
    
    // custom init //
    init(callingView:UIView, circleSize:Int , location:CGPoint, otherPeople:Array<AnyObject>){
        super.init()
        
        circleRadius = CGFloat(circleSize)
        locationOfCircle = location
        mainView = callingView
        
        if(otherPeople.count != 0){
            peopleArray = otherPeople
        }
        self.createCircle()
    }



    // creation of the main circle //
    func createCircle(){
        
        circle.path = UIBezierPath(roundedRect: CGRectMake(locationOfCircle!.x - 100,
            locationOfCircle!.y - 100, CGFloat(3.0 * circleRadius!),
            CGFloat(3.0 * circleRadius!)),
            cornerRadius: CGFloat(circleRadius!)).CGPath
        
        
        // the fill color //
        circle.fillColor = colorPalette.darkGreenColor.CGColor
     
        self.mainView.layer.addSublayer(circle)
    }
    

    
    
    
    func createOtherPeoplePictures(){
        
        
        otherPersonButton?.removeFromSuperview()
        personLabel?.removeFromSuperview()
        circleAroundPeople?.removeFromSuperlayer()
        
        for(var i = 0; i < peopleArray.count; i++){
            
            // placement around the main circle //
            var x = Double(locationOfCircle!.x) + Double(circleRadius! * 1.5) * cos(2 * M_PI * Double(i) / Double(peopleArray.count))
            var y = Double(locationOfCircle!.y) + Double(circleRadius! * 1.5) * sin(2 * M_PI * Double(i) / Double(peopleArray.count))
            
            
            // creation of the picture buttons //
            otherPersonButton = UIButton(frame: CGRect(x: x, y: y, width: 100.0, height: 100.0))
            
            otherPersonButton!.setImage(UIImage(named: "face\(1).png"), forState: UIControlState.Normal)
            otherPersonButton!.layer.cornerRadius = 50
            otherPersonButton!.layer.borderWidth = 3.0
            otherPersonButton!.layer.borderColor = UIColor.blackColor().CGColor
            otherPersonButton!.clipsToBounds = true
            otherPersonButton!.tag = i
            otherPersonButton!.addTarget(self, action: Selector("personClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            
        

            
            
            // creating the name label //
            personLabel = UILabel()
            var whiteColorWithOpacity:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
            
            
            personLabel!.text = peopleArray[i].username?
            personLabel!.textColor = UIColor.blackColor()
            personLabel!.sizeToFit()
            personLabel!.layer.cornerRadius = 5.0
            personLabel!.clipsToBounds = true
            
            // getting the resized frame //
            var personLabelFrame:CGRect = personLabel!.frame
            
            
            // getting the exact center of the circle and putting a label there... slightly below center //
            personLabel!.frame = CGRect(x: x + Double((otherPersonButton!.frame.width / 2) - personLabelFrame.width / 2), y: y + Double((otherPersonButton!.frame.size.height / 2) - 40.0), width: Double(personLabel!.frame.size.width), height: Double(personLabel!.frame.size.height))

            personLabel!.backgroundColor = whiteColorWithOpacity
            personLabel!.textAlignment = .Center
            

            // creating a layer behind the persons profile pic //
            circleAroundPeople = CAShapeLayer()
            
            circleAroundPeople!.path = UIBezierPath(roundedRect: CGRectMake(CGFloat(x - 5.0) ,
                CGFloat(y - 5.0), CGFloat(1.1 * circleRadius!),
                CGFloat(1.1 * circleRadius!)),
                cornerRadius: CGFloat(circleRadius!)).CGPath
            
            circleAroundPeople!.fillColor = colorPalette.lightBlueColor.CGColor

            
            self.mainView.layer.addSublayer(circleAroundPeople!)
            
            self.mainView.addSubview(otherPersonButton!)
            self.mainView.addSubview(personLabel!)

        }
    }
    
    
    
    // what happens when a person is clicked //
    func personClicked(sender:UIButton){
        
        var personClickedOnIndex:Int = Int(sender.tag)
        
        // sending the info back to the LoggedIn View //
        delegate?.didClickOnUser(personClickedOnIndex, nameOfPerson: peopleArray)
    }
    
    
    
    
    
    
    
    
    // called after the circle has been created and anytime after the fact //
    func updatePeople(otherPeople:Array<AnyObject>){
        
        self.peopleArray.removeAll(keepCapacity: false)
        
        
        
        self.peopleArray = otherPeople
        // refresh the circle //
        self.createOtherPeoplePictures()
        
    }
    
    
    
    
}
