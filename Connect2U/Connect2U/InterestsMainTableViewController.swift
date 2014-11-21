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
        
        var colorPalette = ColorPalettes()

        self.view.backgroundColor = colorPalette.lightBlueColor
        interestsList.backgroundColor = colorPalette.greenColor
        
        automotive.backgroundColor = colorPalette.greenColor
        collecting.backgroundColor = colorPalette.greenColor
        music.backgroundColor = colorPalette.greenColor
        games.backgroundColor = colorPalette.greenColor
        art.backgroundColor = colorPalette.greenColor
        science.backgroundColor = colorPalette.greenColor
        nature.backgroundColor = colorPalette.greenColor

    }
    
    

 }
