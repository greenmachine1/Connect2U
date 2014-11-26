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
            
            self.setUpMessage("Please enter your User name and Password", message: "It is a requirement to sign up.", cameFromGoodLogin: false)
         
        }else{
            
            // send the sign up through! //
            if(passWord.text == secondPassword.text){
                
                
                // set up the user sign in //
                self.userSignup(userName.text, passwordString: secondPassword.text)
            
        
            }else{
                
                self.setUpMessage("Password Incorrect", message: "Please enter the same password again", cameFromGoodLogin: false)
                
            }
        }
    }
    
    
    
    
    
    // forgot password click //
    @IBAction func forgotPasswordClick(sender: UIButton) {
        
        
        
        
    }
    
    
    
    
    
    
    // show popup message //
    func setUpMessage(title:String, message:String, cameFromGoodLogin:Bool){
        
        var alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // creates the Ok button that essentially does nothing //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        
        if(cameFromGoodLogin == true){
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
                
                println("in here")
                
            }))
            
        }
        
        
        
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
    
    
    
    
    
    // the actual parse sign up //
    func userSignup(userNameString:String, passwordString:String){
        
        var user = PFUser()
        user.username = userNameString
        user.password = passwordString
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            
            // successful log in //
            if(error == nil){
                
                self.setUpMessage("Success!", message: "Do you want to set up user info?", cameFromGoodLogin: true)
                
            }else{
                
                // something happened //
                var errorString:String = error.userInfo!["error"] as NSString

                if(errorString.rangeOfString(errorString) != nil){
                    
                    self.setUpMessage("User Name is already taken", message: "Please use a different User Name", cameFromGoodLogin: false)
                    
                    // resetting the username and password fields //
                    self.passWord.text = ""
                    self.userName.text = ""
                    self.secondPassword.text = ""
                    self.secondPassword.hidden = true
                }
                
                
            }
            
            
        }
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        
        signUpButton.backgroundColor = colorPalette.greenColor
        signUpButton.tintColor = colorPalette.whiteColor
        
    }

}
