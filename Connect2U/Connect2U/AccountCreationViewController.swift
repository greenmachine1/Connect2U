//
//  AccountCreationViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class AccountCreationViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userName:UITextField!
    @IBOutlet weak var passWord:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()
        
        userName.delegate = self
        passWord.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // on signup button //
    @IBAction func signUpOnClick(sender: AnyObject) {
        
        // should take the user to set up their age, picture, gender, and interests //
        
        
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    

    // setting colors for the view //
    func setColors(){
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
        
        signUpButton.backgroundColor = greenColor
        signUpButton.tintColor = whiteColor
        
    }

}
