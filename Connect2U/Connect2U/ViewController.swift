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
    
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    let reachability = Reachability.reachabilityForInternetConnection()

    
    var loggedInVariable:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        
        
        if(!(reachability.isReachable())){
            self.popUpMessageForNoInternet()
        }
        
        reachability.startNotifier()
        

        self.setColors()
    
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        
        if(loggedInVariable == false){
            
            self.userStillLoggedIn()
            
        }else{
            
            PFUser.logOut()

            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        newAccountButton.hidden = true
        facebookButton.hidden = true
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
                
                userNameTextField.placeholder = "Username"
                passwordTextField.placeholder = "Password"
                
                userNameTextField.enabled = true
                passwordTextField.enabled = true
                
                logInButton.enabled = true
                forgotPassword.enabled = true
                moreOptionsButton.enabled = true
                
                newAccountButton.enabled = true
                facebookButton.enabled = true
            } else {
                println("Reachable via Cellular")
                userNameTextField.placeholder = "Username"
                passwordTextField.placeholder = "Password"
                
                userNameTextField.enabled = true
                passwordTextField.enabled = true
                
                logInButton.enabled = true
                forgotPassword.enabled = true
                moreOptionsButton.enabled = true
                
                newAccountButton.enabled = true
                facebookButton.enabled = true
                
            }
            self.userStillLoggedIn()
        } else {
            
            // no internet //
            self.popUpMessageForNoInternet()
        }
    }
    
    
    
    func popUpMessageForNoInternet(){
        
        // pop up with a notification saying that they need to connect to the internet in order to use //
        var alert:UIAlertController = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to log in", preferredStyle: UIAlertControllerStyle.Alert)
        
        // creates the Ok button that essentially does nothing //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        userNameTextField.enabled = false
        passwordTextField.enabled = false
        
        userNameTextField.placeholder = "No Connection"
        passwordTextField.placeholder = "Please Connect"
        
        logInButton.enabled = false
        forgotPassword.enabled = false
        moreOptionsButton.enabled = false
        newAccountButton.enabled = false
        facebookButton.enabled = false
    }
    
    
    @IBAction func moreOptionsOnClick(sender: UIButton) {
        
        newAccountButton.hidden = false
        facebookButton.hidden = false
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        newAccountButton.hidden = true
        facebookButton.hidden = true
        
    }
    
    
    
    // removing self from observer //
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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

        if(reachability.isReachable()){
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
        
        
        var loginFrame = logInButton.frame.size
        
        var newColorPalette = ColorPalettes()
        
        var cornerRadiusValue:CGFloat = newAccountButton.frame.width / 2
        
        // background color //
        self.view.backgroundColor = newColorPalette.lightBlueColor
        
        // color of the navigation controller bar //
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = newColorPalette.lightBlueColor
        self.navigationController?.navigationBar.tintColor = newColorPalette.whiteColor
        
        // color for the buttons //
        logInButton.backgroundColor = newColorPalette.darkGreenColor
        logInButton.tintColor = newColorPalette.whiteColor
        
        
        
        userNameTextField.backgroundColor = newColorPalette.whiteColor
        userNameTextField.textColor = newColorPalette.darkGreenColor
        passwordTextField.backgroundColor = newColorPalette.whiteColor
        passwordTextField.textColor = newColorPalette.darkGreenColor
        

        
        
        //forgotPassword.backgroundColor = newColorPalette.greenColor
        forgotPassword.tintColor = newColorPalette.whiteColor
        moreOptionsButton.tintColor = newColorPalette.whiteColor
        newAccountButton.tintColor = newColorPalette.whiteColor
        facebookButton.tintColor = newColorPalette.whiteColor
        
        facebookButton.backgroundColor = newColorPalette.darkGreenColor
        newAccountButton.backgroundColor = newColorPalette.darkGreenColor
        facebookButton.layer.cornerRadius = cornerRadiusValue
        facebookButton.clipsToBounds = true
        newAccountButton.layer.cornerRadius = cornerRadiusValue
        newAccountButton.clipsToBounds = true
        
    }
}

