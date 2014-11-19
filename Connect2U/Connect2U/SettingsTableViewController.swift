//
//  SettingsTableViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var ageSwitch: UISwitch!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var pictureSwitch: UISwitch!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var interestsView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var pictureView: UIView!
    
    
    @IBOutlet var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // log out button //
    @IBAction func onLogOut(sender: AnyObject) {
        
        println("pushed!")
    }
    
    
    
    
    
    
    // setting colors for the view //
    func setColors(){
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
     
        // setting background colors for the table view elements //
        settingsTableView.backgroundColor = lightBlueColor
        nameView.backgroundColor = lightBlueColor
        ageView.backgroundColor = lightBlueColor
        genderView.backgroundColor = lightBlueColor
        interestsView.backgroundColor = lightBlueColor
        pictureView.backgroundColor = lightBlueColor
        
        
        logOutButton.backgroundColor = greenColor
        
        
    }

}
