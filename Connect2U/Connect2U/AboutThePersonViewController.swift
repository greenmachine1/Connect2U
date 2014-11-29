//
//  AboutThePersonViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class AboutThePersonViewController: UIViewController {
    
    
    var personIndex:Int!
    var listOfPeoplesNames:[String]!
    var personsPic:String!
    var image:UIImage!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
        picture.layer.cornerRadius = 100
        picture.clipsToBounds = true
        picture.layer.borderColor = UIColor.blackColor().CGColor
        picture.layer.borderWidth = 3.0
        

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
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("chat") as ChatViewController
            
        self.navigationController?.pushViewController(aboutViewController, animated: true)
        
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
