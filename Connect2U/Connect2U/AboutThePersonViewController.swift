//
//  AboutThePersonViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class AboutThePersonViewController: UIViewController {
    
    
    var personName:String?
    var personsPic:String?
    var image:UIImage?
    var personAge:Int?
    var personInterests:Array<String>?
    var personGender:String?
    
    var userPassedIn:PFUser?
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
        var cornerRadiusOfPicture = CGFloat(picture.frame.height / 2)
        
        println(picture.frame.height)
        println(picture.frame.width)
        
        picture.layer.cornerRadius = cornerRadiusOfPicture
        picture.clipsToBounds = true
        picture.layer.borderColor = UIColor.blackColor().CGColor
        picture.layer.borderWidth = 3.0
        if(personName != nil){
            nameLabel.text = personName!
        }
        if(personAge != nil){
            ageLabel.text = "\(personAge!)"
        }
        if(personInterests != nil){
            interestsLabel.text = "\(personInterests!)"
        }
        if(personGender != nil){
            genderLabel.text = personGender!
        }
        if(personsPic != nil){
            picture.image = UIImage(named: personsPic!)
        }
    }

    
    
    
    
    
    
    
    
    
    func connectButton(){
        
        // also, within the users profile, they can set it to where they can edit the data //
        var editButton:UIBarButtonItem = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("connect"))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // this is for editing functionality //
    func doSomething(){
        
        println("do something")
    }
    
    
    
    
    
    
    
    // within the users profile, we can choose to connect with them //
    func connect(){
        println("connect")
        
        // takes you the user to your personal settings //
        let chatController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
        chatController.personPassedIn = userPassedIn
            
        self.navigationController?.pushViewController(chatController, animated: true)
        
    }
    
    
    
    
    
    

    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        self.nameLabel.textColor = colorPalette.whiteColor
        
        ageLabel.textColor = colorPalette.whiteColor
        ageLabel.backgroundColor = colorPalette.greenColor
        ageLabel.textAlignment = .Center
        
        genderLabel.textColor = colorPalette.whiteColor
        genderLabel.backgroundColor = colorPalette.greenColor
        genderLabel.textAlignment = .Center
        
        interestsLabel.textColor = colorPalette.whiteColor
        interestsLabel.backgroundColor = colorPalette.greenColor
        interestsLabel.textAlignment = .Center
    }
}
