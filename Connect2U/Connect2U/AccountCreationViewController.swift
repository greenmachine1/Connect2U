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
    

    // return button //
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    

    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        
        signUpButton.backgroundColor = colorPalette.greenColor
        signUpButton.tintColor = colorPalette.whiteColor
        
    }

}
