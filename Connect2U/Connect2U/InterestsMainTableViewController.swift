//
//  InterestsMainTableViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class InterestsMainTableViewController: UITableViewController {

    @IBOutlet weak var interestsList: UITableViewCell!
    
    @IBOutlet weak var automotive: UITableViewCell!
    @IBOutlet weak var collecting: UITableViewCell!
    @IBOutlet weak var music: UITableViewCell!
    @IBOutlet weak var games: UITableViewCell!
    @IBOutlet weak var art: UITableViewCell!
    @IBOutlet weak var science: UITableViewCell!
    @IBOutlet weak var nature: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
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
        interestsList.backgroundColor = greenColor
        
        automotive.backgroundColor = greenColor
        collecting.backgroundColor = greenColor
        music.backgroundColor = greenColor
        games.backgroundColor = greenColor
        art.backgroundColor = greenColor
        science.backgroundColor = greenColor
        nature.backgroundColor = greenColor

    }
    
    

 }
