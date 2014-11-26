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
        
        // checking to make sure that both the username and password fields are not blank //
        if((userName.text == "") || (passWord.text == "")){
            
            self.setUpMessage("Please enter your Email address and Password", message: "It is a requirement to sign up.")
            
         // send the sign up through! //
        }else{
            
            
            if(passWord.text == secondPassword.text){
                
                
                // send everything through ! //
                // this is where everything gets sent through to parse //
                // checking for the '@' symbol to be present
                var atCharacter:String = "@"
                var dotCharacter:String = "."
                
                
                // checking to see whether the username string contains '@' and a '.' //
                if((userName.text.rangeOfString(atCharacter) != nil) && (userName.text.rangeOfString(dotCharacter) != nil)){
                    
                    
                    
                    
                    // really.... pass them through //
                    
                    
                    
                }else{
                    
                    self.setUpMessage("Please enter a correct email Address", message: "It is a requirement to sign up.")
            
                }
                
            }else{
                
                self.setUpMessage("Password Incorrect", message: "Please enter the same password again")
                
            }
        }
    }
    
    
    
    
    
    // forgot password click //
    @IBAction func forgotPasswordClick(sender: UIButton) {
        
        
        
        
    }
    
    
    
    
    
    
    // show popup message //
    func setUpMessage(title:String, message:String){
        
        var alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // creates the Ok button that essentially does nothing //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    // when leaving the first password entry blank //
    func textFieldDidEndEditing(textField: UITextField) {
        if((textField.tag == 1) && (textField.text == "")){
            
            secondPassword.hidden = true
            
            // making the second textfield blank //
            secondPassword.text = ""
            
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
