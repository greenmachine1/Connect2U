//
//  AccountCreationViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class AccountCreationViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userName:UITextField!
    @IBOutlet weak var passWord:UITextField!
    @IBOutlet weak var secondPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()
        
        userName.delegate = self
        passWord.delegate = self
        secondPassword.delegate = self
        
        secondPassword.hidden = true
        
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
    
    // user clicks the sign up feature //
    @IBAction func signUpOnClick(sender: UIButton) {
        
        if((userName.text == "") || (passWord.text == "")){
            
            var alert:UIAlertController = UIAlertController(title: "Please enter your Email address and Password", message: "It is a requirement to sign up.", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            // creates the Ok button that essentially does nothing //
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
         // send the sign up through! //
        }else{
            
            
            
            if(passWord.text == secondPassword.text){
                
                
                // send everything through ! //
                // this is where everything gets sent through to parse //
                
                
                
                
                
                
                
                
                
            }else{
                
                var alert:UIAlertController = UIAlertController(title: "Password Incorrect", message: "Please enter the same password again.", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                // creates the Ok button that essentially does nothing //
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    
    // when leaving the first password entry blank //
    func textFieldDidEndEditing(textField: UITextField) {
        if((textField.tag == 1) && (textField.text == "")){
            
            secondPassword.hidden = true
            
        }
    }
    
    
    
    
    // when the user starts typing , the second field opens up //
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField.tag == 1){
           
            secondPassword.hidden = false
            
        }
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
