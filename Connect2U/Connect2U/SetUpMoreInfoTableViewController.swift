//
//  SetUpMoreInfoTableViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class SetUpMoreInfoTableViewController: UITableViewController {

    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var interestsView: UIView!

    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
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
        
        ageView.backgroundColor = colorPalette.greenColor
        ageView.tintColor = colorPalette.whiteColor
        pictureView.backgroundColor = colorPalette.greenColor
        interestsView.backgroundColor = colorPalette.greenColor
        cancelButtonView.backgroundColor = colorPalette.greenColor
        
        
        
        cancelButton.backgroundColor = colorPalette.darkGreenColor
        
    }


}
