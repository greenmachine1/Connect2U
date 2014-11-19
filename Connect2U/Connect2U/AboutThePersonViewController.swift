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
    
    
    
    // this is going to be dummy data for each user //
    var sueData:[String] = ["Sue","22", "female", "Baseball", "Hockey", "Shopping", "Jogging", "Swimming" ]
    var kevinData:[String] = ["Kevin", "28", "Male", "Jogging", "Football", "Programming"]
    var jamesData:[String] = ["James", "31", "Male", "Gaming", "Programming", "Eating", "Beards"]
    var georgeData:[String] = ["George", "102", "Male", "Fire", "Mullets", "Vampires", "English", "Aging"]
    
    var coryData:[String] = ["Cory", "30", "Male", "Programming", "Cars", "Baseball", "Swimming"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
        picture.layer.cornerRadius = 100
        picture.clipsToBounds = true
        picture.layer.borderColor = UIColor.blackColor().CGColor
        picture.layer.borderWidth = 3.0
        
        // setting the picture of the user //
        picture.image = UIImage(named: personsPic)
        
        nameLabel.text = listOfPeoplesNames[personIndex]
        
        
        
        
        // this is clunky dummy data for now //
        switch (personIndex){
            
            // cory //
        case 0:
            ageLabel.text = "Age: \(coryData[1])"
            genderLabel.text = "Gender: \(coryData[2])"
            interestsLabel.text = "Interests :\(coryData[3]), \(coryData[4]), \(coryData[5]), \(coryData[6])"
            
            
            // also, within the users profile, they can set it to where they can edit the data //
            var editButton:UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("doSomething"))
            self.navigationItem.rightBarButtonItem = editButton
            
            
            
            
            // sue //
        case 1:
            ageLabel.text = "Age: \(sueData[1])"
            genderLabel.text = "Gender: \(sueData[2])"
            interestsLabel.text = "Interests :\(sueData[3]), \(sueData[4]), \(sueData[5]), \(sueData[6]), \(sueData[7])"
            
            self.connectButton()
            
            // kevin //
        case 2:
            ageLabel.text = "Age: \(kevinData[1])"
            genderLabel.text = "Gender: \(kevinData[2])"
            interestsLabel.text = "Interests :\(kevinData[3]), \(kevinData[4]), \(kevinData[5])"
            
            self.connectButton()
            
            // james //
        case 3:
            ageLabel.text = "Age: \(jamesData[1])"
            genderLabel.text = "Gender: \(jamesData[2])"
            interestsLabel.text = "Interests :\(jamesData[3]), \(jamesData[4]), \(jamesData[5]), \(jamesData[6])"
            
            self.connectButton()
            
            // george //
        case 4:
            ageLabel.text = "Age: \(georgeData[1])"
            genderLabel.text = "Gender: \(georgeData[2])"
            interestsLabel.text = "Interests :\(georgeData[3]), \(georgeData[4]), \(georgeData[5]), \(georgeData[6]), \(georgeData[7])"
            
            self.connectButton()
            
        default:
            ageLabel.text = ""
            genderLabel.text = ""
            interestsLabel.text = ""
            
        }
        
        
        
        
    }
    
    
    
    func connectButton(){
        
        // also, within the users profile, they can set it to where they can edit the data //
        var editButton:UIBarButtonItem = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("connect"))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // setting colors for the view //
    func setColors(){
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
        self.nameLabel.textColor = whiteColor
        
        ageLabel.textColor = whiteColor
        ageLabel.backgroundColor = greenColor
        ageLabel.textAlignment = .Center
        
        genderLabel.textColor = whiteColor
        genderLabel.backgroundColor = greenColor
        genderLabel.textAlignment = .Center
        
        interestsLabel.textColor = whiteColor
        interestsLabel.backgroundColor = greenColor
        interestsLabel.textAlignment = .Center
    }
    
    
    
    

}
