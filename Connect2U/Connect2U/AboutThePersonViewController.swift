//
//  AboutThePersonViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

@objc protocol SetCurrentUserInfo{
    
    func updateCurrentUserInfo()
    
}

class AboutThePersonViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var personName:String?
    var personsPic:String?
    var image:UIImage?
    var personAge:String?
    var personInterests:Array<String>?
    var personGender:String?
    
    var userObjectId:AnyObject?
    
    var userPassedIn:PFUser?
    var personPassedInNotPFUser:AnyObject?
    var cameFromMainUser:Bool?
    
    var toggleBoolean:Bool?
    
    var size:CGSize?
    
    
    // camera stuff //
    let captureSession = AVCaptureSession()
    
    var captureDevice:AVCaptureDevice?
    
    var preview:AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    //@IBOutlet weak var interestsLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageEditText: UITextField!
    @IBOutlet weak var genderEditText: UITextField!
    
    @IBOutlet weak var changePictureButton: UIButton!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    
    @IBOutlet weak var cancelTakePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        size = CGSizeMake(self.picture.frame.size.width / 1.0, self.picture.frame.size.height / 1.0)

        self.setColors()
        
        self.pictureSetUp()
        
        var cornerRadiusOfPicture:CGFloat?
        
        if(self.view.frame.width == 414.0){
            cornerRadiusOfPicture = CGFloat(picture.frame.height - size!.width / 2.0)
        }else if(self.view.frame.width == 375.0){
            cornerRadiusOfPicture = CGFloat(picture.frame.height - size!.width / 1.8)
        }else if(self.view.frame.width == 320.0){
            cornerRadiusOfPicture = CGFloat(picture.frame.height - size!.width / 1.5)
        }else{
            cornerRadiusOfPicture = CGFloat(0.0)
        }
        
        println(self.view.frame.width)
        println(self.view.frame.height)
        
        picture.layer.cornerRadius = cornerRadiusOfPicture!
        picture.clipsToBounds = true
        picture.layer.borderColor = UIColor.blackColor().CGColor
        picture.layer.borderWidth = 3.0
        
        nameTextField.hidden = true
        genderEditText.hidden = true
        ageEditText.hidden = true
        
        toggleBoolean = true
        changePictureButton.hidden = true
        takePictureButton.hidden = true
        cancelTakePictureButton.hidden = true
        
        mainTableView.delegate = self
        
        if(userPassedIn != nil){
            
            userObjectId = userPassedIn?.objectId
            
            personName = userPassedIn?.username
            nameLabel.text = personName
            
            personAge = userPassedIn?.objectForKey("age") as? String
            
            var tempAgeString = "\(personAge!)"
            ageLabel.text = tempAgeString
            
        
            personInterests = userPassedIn?.objectForKey("interests") as? Array
            

            personGender = userPassedIn?.objectForKey("gender") as? String
            genderLabel.text = personGender
        }
        
        if(personPassedInNotPFUser != nil){
            
            var userInfoLevel:AnyObject? = personPassedInNotPFUser?.objectForKey("userInfo")
            if(userInfoLevel != nil){
                
                userObjectId = userInfoLevel!.objectForKey("objectId")
                
                personName = userInfoLevel!.objectForKey("username") as? String
                nameLabel.text = personName
                
                personAge = userInfoLevel!.objectForKey("age") as? String
                
                var tempAgeString = "\(personAge!)"
                ageLabel.text = tempAgeString
                
                
                personInterests = userInfoLevel!.objectForKey("interests") as? Array
                

                personGender = userInfoLevel!.objectForKey("gender") as? String
                genderLabel.text = personGender
            }
        }
        
        
        if(cameFromMainUser == true){
            
            //self.navigationItem.rightBarButtonItem?.enabled = false
            var rightEditButton:UIBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "editButton")
            self.navigationItem.rightBarButtonItem = rightEditButton
            
        }
        
        
    }
    
    
    // called when the return key is pressed //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    // sets the options to be edited //
    func editButton(){
        
        if(toggleBoolean == true){
            
            nameTextField.hidden = false
            genderEditText.hidden = false
            ageEditText.hidden = false
            changePictureButton.hidden = false
            
            toggleBoolean = false

            // adding the '+' to the end of the list //
            personInterests?.append("Add New Entry")
            
            
            nameTextField.text = nameLabel.text
            genderEditText.text = genderLabel.text
            ageEditText.text = ageLabel.text
            
            
            
            mainTableView.reloadData()
            
            self.navigationItem.rightBarButtonItem?.title = "Done"
            
        }
        
        else if(toggleBoolean == false){
            nameTextField.hidden = true
            genderEditText.hidden = true
            ageEditText.hidden = true
            changePictureButton.hidden = true
            
            toggleBoolean = true
            
            // remove the '+' in the list //
            personInterests?.removeLast()
            
            mainTableView.reloadData()
            
            self.navigationItem.rightBarButtonItem?.title = "Edit Profile"
            
            println("hit done!!")
            
            
            
            // stops the camera //
            captureSession.stopRunning()
            
            
            
            
            
            // saving the users info upon hitting done! //
            self.saveUsersInfo()
        }
    }
    
    
    
    
    
    
    
    // save the users info //
    func saveUsersInfo(){
        
        var currentUser:PFUser = PFUser.currentUser()
        
        if((nameTextField.text != personName) || (genderEditText.text != personGender) || (ageEditText.text != personAge)){
            
            if( (!(nameTextField.text.isEmpty)) || (!(genderEditText.text.isEmpty)) ||
                (!(ageEditText.text.isEmpty)) ){
                
                    
                    //var currentUser:PFUser = PFUser.currentUser()
                    currentUser.username = nameTextField.text
                    currentUser.setValue(genderEditText.text, forKey: "gender")
                    currentUser.setValue(ageEditText.text, forKey: "age")
                    currentUser.setValue(personInterests, forKey: "interests")
                    currentUser.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
                        
                        if(success == true){
                            
                            println("save succeeded!")
                            
                            self.nameLabel.text = currentUser.username
                            self.genderLabel.text = currentUser.objectForKey("gender") as? String
                            self.ageLabel.text = currentUser.objectForKey("age") as? String
                            self.personInterests = currentUser.objectForKey("interests") as? Array
                            
                        }else{
                            
                            println("error:\(error.description)")
                        }
                    }
            }
            
        
        }else{
            
            
            println("stuff hasnt changed")
            
        }
    }
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = personInterests![indexPath.row] as String
        var deleteImage = UIImage(named: "DeleteButton.png") as UIImage?
        var deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        if(cell.textLabel?.text == "Add New Entry"){
            
            cell.textLabel?.textColor = UIColor.blueColor()
            cell.textLabel?.textAlignment = .Center
            
        }
        
        
        // creating the delete button per row //
        if(toggleBoolean == false && indexPath.row != personInterests!.count - 1){
            deleteImage = UIImage(named: "DeleteButton.png") as UIImage?
            deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
            deleteButton.frame = CGRectMake(cell.frame.width - 60.0, 7.0, 35.0, 35.0)
            deleteButton.setImage(deleteImage, forState: .Normal)
            deleteButton.tag = indexPath.row
            deleteButton.addTarget(self, action: "deleteButtonPressedFromFriends:", forControlEvents: UIControlEvents.TouchUpInside)
        
            cell.addSubview(deleteButton)
            
        }else{
            
            for(index, view) in enumerate(cell.subviews){

                if(view.isKindOfClass(UIButton)){
                        
                    view.removeFromSuperview()
                }
            }
        }
        
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("in here at \(indexPath.row)")
        
        if(toggleBoolean == false){
            
            if(indexPath.row == personInterests!.count - 1){
                
                println("add new entry")
                
                // should send the user to add a new entry view //
            }
            
        }
        
    }
    
    
    
    
    
    // removing item from the list //
    func deleteButtonPressedFromFriends(sender:UIButton){

        personInterests?.removeAtIndex(sender.tag)
        mainTableView.reloadData()
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personInterests!.count
    }

    
    
    
    

    

    // setting colors for the view //
    func setColors(){
        
        var colorPalette = ColorPalettes()
        
        self.view.backgroundColor = colorPalette.lightBlueColor
        self.nameLabel.textColor = colorPalette.whiteColor
        
        ageLabel.textColor = colorPalette.whiteColor

        genderLabel.textColor = colorPalette.whiteColor

        
        changePictureButton.backgroundColor = colorPalette.whiteColor
        changePictureButton.layer.cornerRadius = 5.0
        changePictureButton.clipsToBounds = true
        changePictureButton.layer.borderWidth = 2.0
        changePictureButton.layer.borderColor = UIColor.blackColor().CGColor
        changePictureButton.alpha = 1.0
        
        takePictureButton.backgroundColor = colorPalette.whiteColor
        takePictureButton.layer.cornerRadius = 5.0
        takePictureButton.clipsToBounds = true
        takePictureButton.layer.borderWidth = 2.0
        takePictureButton.layer.borderColor = UIColor.blackColor().CGColor
        takePictureButton.alpha = 1.0
        
        cancelTakePictureButton.backgroundColor = colorPalette.whiteColor
        cancelTakePictureButton.layer.cornerRadius = 5.0
        cancelTakePictureButton.clipsToBounds = true
        cancelTakePictureButton.layer.borderWidth = 2.0
        cancelTakePictureButton.layer.borderColor = UIColor.blackColor().CGColor
        cancelTakePictureButton.alpha = 1.0
        
        
        nameTextField.layer.borderWidth = 2.0
        nameTextField.layer.borderColor = UIColor.blackColor().CGColor
        nameTextField.clipsToBounds = true
        nameTextField.layer.borderWidth = 2.0
        
        nameTextField.delegate = self
        
        genderEditText.layer.borderWidth = 2.0
        genderEditText.layer.borderColor = UIColor.blackColor().CGColor
        genderEditText.clipsToBounds = true
        genderEditText.layer.borderWidth = 2.0
        
        genderEditText.delegate = self
        
        ageEditText.layer.borderWidth = 2.0
        ageEditText.layer.borderColor = UIColor.blackColor().CGColor
        ageEditText.clipsToBounds = true
        ageEditText.layer.borderWidth = 2.0
        
        ageEditText.delegate = self
        
    }
    
    
    
    // setting up to take a picture //
    func pictureSetUp(){
        
        captureSession.sessionPreset = AVCaptureSessionPresetMedium
        let devices = AVCaptureDevice.devices()
        
        for device in devices{
            
            if(device.hasMediaType(AVMediaTypeVideo)){
                
                // getting the front facing camera //
                if(device.position == AVCaptureDevicePosition.Front){
                    
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func changePicOnClick(sender: UIButton) {
        
        if(captureDevice != nil){
            
            self.beginSession()
        }
    }
    
    
    func beginSession(){
        
        var error:NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &error))
        
        preview = AVCaptureVideoPreviewLayer(session: captureSession)
        
        var frameForCamera = CGRectMake(self.picture.frame.origin.x - size!.width, self.picture.frame.origin.y - size!.height, self.picture.frame.width + size!.width, self.picture.frame.height + size!.height)

        
        
        
        println(picture.frame)
        println(frameForCamera)
        
        //preview?.frame = self.picture.frame
        preview?.frame = frameForCamera
        self.picture.layer.addSublayer(preview)
        

        captureSession.startRunning()
        
        changePictureButton.hidden = true
        takePictureButton.hidden = false
        cancelTakePictureButton.hidden = false
    }
    
    @IBAction func takePictureButtonOnClick(sender: UIButton) {
        
        
        
        
        
        println("in here!")
        
        
    }
    
    
    
    
    
    
    
    
    
}
