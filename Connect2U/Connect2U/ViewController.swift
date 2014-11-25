//
//  ViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/11/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//


// this is the log in screen that allows the users to log in or create a new account //

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleText: UINavigationItem!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        
        
        
        
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // sets all the colors for the view
    func setColors(){
        
        var newColorPalette = ColorPalettes()
        
        // background color //
        self.view.backgroundColor = newColorPalette.lightBlueColor
        
        // color of the navigation controller bar //
        self.navigationController?.navigationBar.barTintColor = newColorPalette.greenColor
        self.navigationController?.navigationBar.tintColor = newColorPalette.whiteColor
        
        // color for the buttons //
        logInButton.backgroundColor = newColorPalette.greenColor
        logInButton.tintColor = newColorPalette.whiteColor
        
        facebookButton.tintColor = newColorPalette.whiteColor
        
        newAccountButton.backgroundColor = newColorPalette.greenColor
        newAccountButton.tintColor = newColorPalette.whiteColor
        
    }
    


}

