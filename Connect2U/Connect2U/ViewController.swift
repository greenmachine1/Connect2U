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
    @IBOutlet weak var forgotPassword: UIButton!
    
    
    var loggedInVariable:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
    
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        
        if(loggedInVariable == false){
            
            self.userStillLoggedIn()
            
        }else{
            
            PFUser.logOut()

            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
    }
    
    
    
    
    

    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func userStillLoggedIn(){
        
        var currentUser = PFUser.currentUser()
        
        if(Reachability.isConnectedToNetwork() != false){
            
            println("is connected ")
        
            if(currentUser != nil){
        
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = currentUser
                installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                    if(success){
                        
                    }
                })
            
                // need to go to the main page with the user logged in //
                let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoggedIn
            
                self.navigationController?.pushViewController(login, animated: true)
            }
        }
    }
    
    
    
    
    
    
    
    
    // log in //
    @IBAction func logInClick(sender: UIButton) {
        
        println("login clicked")
        
        println("current User and stuff ! : \(PFUser.currentUser())")
        
        if(PFUser.currentUser() == nil){
        
            var currentUser = PFUser.currentUser()
        
            // if there is info in the fields, attempt to verify //
            if( !(userNameTextField.text.isEmpty) && !(passwordTextField.text.isEmpty)){
            
                
                PFUser.logInWithUsernameInBackground(userNameTextField.text, password: passwordTextField.text, block: { (user:PFUser!, error:NSError!) -> Void in
                    
                    // successful log in //
                    if(user != nil){
                
                        currentUser = user
                    
                        var installation:PFInstallation = PFInstallation.currentInstallation()
                        installation["user"] = currentUser
                        installation.saveInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
                            if(success){
                            
                                println("successfully added the user to the installation")
                                println(PFInstallation.currentInstallation())
                            
                            }
                        })

                        // log that person in! //
                        // need to go to the main page with the user logged in //
                        
                        if(currentUser != nil){
                            
                            println("in this line of codex!")
                            let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoggedIn
                    
                            self.navigationController?.pushViewController(login, animated: true)
                        }
                        
                    }else{
                        var userInfo:String = error.userInfo!["error"] as NSString
                        if((userInfo.rangeOfString("invalid login credentials")) != nil){
                        
                            self.displayMessage("No user found!", message: "Please enter a different user", cameFromNoUser:true)
                        }
                    }
                })
            }else{
                // they probably left a field blank, this does not clear the fields //
                self.displayMessage("Log in failed!", message: "Please enter a user name and password", cameFromNoUser:false)
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    // displaying a message //
    func displayMessage(title:String, message:String, cameFromNoUser:Bool){
        
        var alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // creates the Ok button that essentially does nothing //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
            if(cameFromNoUser == true){
            
                self.userNameTextField.text = ""
                self.passwordTextField.text = ""
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    
    
    // sets all the colors for the view
    func setColors(){
        
        
        //var loginFrame = logInButton.frame.size
        var createNewAccountFrame = newAccountButton.frame.size
        var signInWithFacebookFrame = facebookButton.frame.size
        
        //var navigationBarFrame = self.navigationController?.navigationBar.frame
    
        
        // main logo setup //
        //var mainLogo:UIImageView = UIImageView(image: UIImage(named: "Connect_2_U_Log.png"))
        //mainLogo.frame = CGRectMake(CGFloat(20.0), CGFloat(navigationBarFrame!.height + 30.0), CGFloat(self.view.frame.width - 40.0), CGFloat(self.view.frame.height / 4))
        
        //self.view.addSubview(mainLogo)
        
        
        //println(mainLogo.frame)
        
        var newColorPalette = ColorPalettes()
        
        //var cornerRadiusValue:CGFloat = loginFrame.width / 2
        
        // background color //
        self.view.backgroundColor = newColorPalette.lightBlueColor
        
        // color of the navigation controller bar //
        //self.navigationController?.navigationBarHidden = false
        //self.navigationController?.navigationBar.barTintColor = newColorPalette.greenColor
        //self.navigationController?.navigationBar.tintColor = newColorPalette.whiteColor
        
        // color for the buttons //
        //logInButton.backgroundColor = newColorPalette.darkGreenColor
        //logInButton.tintColor = newColorPalette.whiteColor
        //logInButton.layer.cornerRadius = cornerRadiusValue
        //logInButton.clipsToBounds = true
        logInButton.setBackgroundImage(UIImage(contentsOfFile: "LogIn.png"), forState: UIControlState.Normal)
        
        
        facebookButton.backgroundColor = newColorPalette.greenColor
        facebookButton.tintColor = newColorPalette.whiteColor
        //facebookButton.layer.cornerRadius = cornerRadiusValue
        facebookButton.clipsToBounds = true
        
        newAccountButton.backgroundColor = newColorPalette.greenColor
        newAccountButton.tintColor = newColorPalette.whiteColor
        //newAccountButton.layer.cornerRadius = cornerRadiusValue
        newAccountButton.clipsToBounds = true
        
        forgotPassword.backgroundColor = newColorPalette.greenColor
        forgotPassword.tintColor = newColorPalette.whiteColor
        //forgotPassword.layer.cornerRadius = cornerRadiusValue
        forgotPassword.clipsToBounds = true
        
    }
}

