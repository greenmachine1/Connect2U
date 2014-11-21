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
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
     
        // setting background colors for the table view elements //
        settingsTableView.backgroundColor = colorPalette.lightBlueColor
        nameView.backgroundColor = colorPalette.lightBlueColor
        ageView.backgroundColor = colorPalette.lightBlueColor
        genderView.backgroundColor = colorPalette.lightBlueColor
        interestsView.backgroundColor = colorPalette.lightBlueColor
        pictureView.backgroundColor = colorPalette.lightBlueColor
        
        
        logOutButton.backgroundColor = colorPalette.darkGreenColor
        
        
    }

}
