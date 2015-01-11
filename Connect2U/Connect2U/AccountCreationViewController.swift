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
    
    var majorNumber:Int?
    var minorNumber:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColors()
        
        userName.delegate = self
        passWord.delegate = self
        secondPassword.delegate = self
        
        secondPassword.hidden = true
        
        // 9469) and Optional(2706
        majorNumber = self.randomNumberGeneration()
        minorNumber = self.randomNumberGeneration()
        
        println("both numbers \(majorNumber) and \(minorNumber)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    // creating random numbers for the iBeacon section //
    func randomNumberGeneration() ->Int{
        
        return 0 + Int(arc4random_uniform(UInt32(10000 - 0 + 1)))
    }
    
    
    
    
    
    
    // user clicks the sign up feature //
    @IBAction func signUpOnClick(sender: UIButton) {
        
        println("button clicked! and shit")
        
        // checking to make sure that both the username and password fields are not blank //
        if((userName.text == "") || (passWord.text == "")){
            
            self.setUpMessage("Please enter your User name and Password", message: "It is a requirement to sign up.", cameFromGoodLogin: false)
         
        }else{
            
            // send the sign up through! //
            if(passWord.text == secondPassword.text){
                
                
                // set up the user sign in //
                self.userSignup(userName.text, passwordString: secondPassword.text,majorNumber:majorNumber!, minorNumber:minorNumber!)
            
        
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
        
        println("in here... and stuff")
        
        var alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        // if coming from a good login //
        // this presents the user with more options //
        if(cameFromGoodLogin == true){
            // creates the Ok button that essentially does nothing //
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
                // need to go to the personal info page
                // takes you the user to your personal settings //
                let setupInfo = self.storyboard?.instantiateViewControllerWithIdentifier("SetupInfo") as MoreInfoViewControllerContainerViewController
            
                self.navigationController?.pushViewController(setupInfo, animated: true)
  
            }))
            
            // the no button essentially takes the user to the main page //
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { action in
                
                println("signed in under someone new")
                
                // need to go to the main page with the user logged in //
                let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoggedIn
                
                self.navigationController?.pushViewController(login, animated: true)
                
            }))
            
        }
            
            
            
        else{
            
            // creates the Ok button that essentially does nothing //
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                
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
    func userSignup(userNameString:String, passwordString:String, majorNumber:Int, minorNumber:Int){
        
        
        
        var user:PFUser = PFUser()
        
        // sets up the name and password but leaves the rest of the fields open //
        // so they can come back and edit them at a later time //
        user.username = userNameString
        user.password = passwordString
        user["major"] = majorNumber
        user["minor"] = minorNumber
        user["gender"] = "unknown"
        user["interests"] = ["biking","swimming","joggin","hair"]
        user["picture"] = "face3.png"
        user["age"] = 29
        user["long"] = 0.0
        user["lat"] = 0.0
        user["signedIn"] = false
        user["literalLocation"] = ""
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
            
            // successful log in //
            if(error == nil){
                
                var currentUser = PFUser.currentUser()
                
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = currentUser
                installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    if(success){
                        
                        println("successfully added the user to the installation")
                        println(PFInstallation.currentInstallation())
                        
                        // log in under a new user was a success!! //
                        self.setUpMessage("Success!", message: "Do you want to set up user info?", cameFromGoodLogin: true)
                        
                    }else{
                        
                        
                        
                    }
                })
                
                
                // log in under a new user was a success!! //
                //self.setUpMessage("Success!", message: "Do you want to set up user info?", cameFromGoodLogin: true)
                
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
        var cornerRadiusValue:CGFloat = 8.0
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        
        
        signUpButton.backgroundColor = colorPalette.greenColor
        signUpButton.tintColor = colorPalette.whiteColor
        signUpButton.layer.cornerRadius = cornerRadiusValue
        signUpButton.clipsToBounds = true
    }
}
