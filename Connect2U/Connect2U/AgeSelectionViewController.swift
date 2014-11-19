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
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
        
        ageSelection.backgroundColor = lightBlueColor
        genderSelector.backgroundColor = lightBlueColor
        genderSelector.tintColor = whiteColor
    }

    



}
