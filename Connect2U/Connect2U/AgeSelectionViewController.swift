//
//  AgeSelectionViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class AgeSelectionViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var ageSelection: UIPickerView!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ageSelection.delegate = self
        
        self.setColors()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows //
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 119
    }
    
    
    // what goes into each row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return "\(row + 18)"
        
    }
    
    // number of components in each row //
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()

        self.view.backgroundColor = colorPalette.lightBlueColor
        
        ageSelection.backgroundColor = colorPalette.lightBlueColor
        genderSelector.backgroundColor = colorPalette.lightBlueColor
        genderSelector.tintColor = colorPalette.whiteColor
    }

    



}
