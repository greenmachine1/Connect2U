//
//  ViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/11/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//


// this is the log in screen that allows the users to log in or create a new account //

import UIKit
import Parse

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
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        // background color //
        self.view.backgroundColor = lightBlueColor
        
        // color of the navigation controller bar //
        self.navigationController?.navigationBar.barTintColor = greenColor
        self.navigationController?.navigationBar.tintColor = whiteColor
        
        // color for the buttons //
        logInButton.backgroundColor = greenColor
        logInButton.tintColor = whiteColor
        
        facebookButton.tintColor = whiteColor
        
        newAccountButton.backgroundColor = greenColor
        newAccountButton.tintColor = whiteColor
        
    }
    


}

