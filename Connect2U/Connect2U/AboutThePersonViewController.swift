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
    
    // sends back the user name and picture to the logged in screen //
    func updateCurrentUserInfo(userName:String, userPicture:UIImage)
    
}

class AboutThePersonViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SendDataBackToMain {
    
    
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
    
    var cameFromAccountCreation:Bool = false
    
    var toggleBoolean:Bool?
    
    var size:CGSize?
    
    var delegate:SetCurrentUserInfo?
    
    var passedInArrayOfUsers:Array<AnyObject>?
    var finalArrayOfUsersAsPFUsersId:Array<AnyObject> = []
    
    
    // camera stuff //
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice?
    var preview:AVCaptureVideoPreviewLayer?
    var stillImageOutput:AVCaptureStillImageOutput?
    var mainImage:UIImage?
    var pngVersionOfImage:AnyObject?
    var cancelToggle:Bool = false
    var arrayOfPictures:[UIImage] = []
    var flippedMainImage:UIImage?
    
    
    
    var pictureFromOtherView:UIImage?
    
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageEditText: UITextField!
    @IBOutlet weak var genderEditText: UITextField!
    
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var cancelTakePictureButton: UIButton!
    
    let reachability = Reachability.reachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        
        
        if(!(reachability.isReachable())){
            self.popUpMessageForNoInternet()
            
        }
        
        
        
        
        if(cameFromAccountCreation == true){
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            backButton.addTarget(self, action: "PopToLoggedIn:", forControlEvents: UIControlEvents.TouchUpInside)
            backButton.setTitle("Logged In", forState: UIControlState.Normal)
            backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            backButton.sizeToFit()
            var customButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = customButtonItem
            
        }
        
        
        
        
        reachability.startNotifier()
        
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
        
        
        
        
        
        
        if(passedInArrayOfUsers != nil){
            
            println("passed in array of users....... --> \(passedInArrayOfUsers!)")
            
            finalArrayOfUsersAsPFUsersId.removeAll(keepCapacity: false)
            
            for(index, element) in enumerate(passedInArrayOfUsers!){
                
                if var elementAsPFUser:PFUser? = element.firstObject! as? PFUser{
                    
                    println("element as pf user --> \(elementAsPFUser!)")
                    
                    if var objectId:AnyObject? = elementAsPFUser!.objectId{
                        
                        println("object id --> \(objectId!)")
                        
                        finalArrayOfUsersAsPFUsersId.append(objectId!)
                        
                    }
                }
            }
        }
        
        
        
        // observer for when new people come in //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "updateOfPeople", object: nil)
        
        
        
        if(userPassedIn != nil){
            
            println("person passed in -->\(userPassedIn!.description)")

            userObjectId = userPassedIn?.objectId

            personName = userPassedIn?.username
            nameLabel.text = personName

            personAge = userPassedIn?.objectForKey("age") as? String
            ageLabel.text = personAge!
            
            personInterests = userPassedIn?.objectForKey("interests") as? Array
            
            personGender = userPassedIn?.objectForKey("gender") as? String
            genderLabel.text = personGender
            
            var personPicture:PFFile? = userPassedIn?.objectForKey("picture") as PFFile?
            if(personPicture != nil){
                println("person picture \(personPicture!)")
                
                
                personPicture!.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                    
                    if(data != nil){

                        self.picture.image = UIImage(CGImage: UIImage(data: data)!.CGImage, scale: 1.0, orientation: .LeftMirrored)
                        
                    }else{
                        
                        println("nothing here")
                    }
                })
            }
        }
        
        if(personPassedInNotPFUser != nil){
            
            println("personPassedIn not PFUser -->\(personPassedInNotPFUser!.description)")
            
            var userInfoLevel:AnyObject? = personPassedInNotPFUser?.objectForKey("userInfo")
            if(userInfoLevel != nil){
                
                println("here.... yo!")
                
                userObjectId = userInfoLevel!.objectForKey("objectId")
                
                personName = userInfoLevel!.objectForKey("username") as? String
                nameLabel.text = personName

                personAge = userInfoLevel!.objectForKey("age") as? String
                ageLabel.text = personAge!

                personInterests = userInfoLevel!.objectForKey("interests") as? Array
                personGender = userInfoLevel!.objectForKey("gender") as? String
                genderLabel.text = personGender
                

                if var personPicture:AnyObject = userInfoLevel!.objectForKey("picture"){
                    
                    println("person picture \(personPicture)")
                    
                    if var urlForPicture:NSURL? = NSURL(string: personPicture.objectForKey("url") as String){
                    
                        println("this is legit \(urlForPicture!)")
                        
                        
                        if var imageData:NSData? = NSData(contentsOfURL: urlForPicture!){
                        
                            if var fileForImage:PFFile? = PFFile(data: imageData){
                            
                            
                                fileForImage?.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
                                
                                    if(data != nil){

                                        self.picture.image = UIImage(CGImage: UIImage(data: data)!.CGImage, scale: 1.0, orientation: .LeftMirrored)
                                    
                                    }else{
                                    
                                        println("nope")
                                    }
                                
                                })
                            }
                        
                        }

                    }else{
                        
                        println("nope")
                    }
                    
                    
                }else{
                    
                    println("is nil")
                }
                
            }

        }

        
        
        
        
        
        if(cameFromMainUser == true){
            
            //self.navigationItem.rightBarButtonItem?.enabled = false
            var rightEditButton:UIBarButtonItem = UIBarButtonItem(title: "Edit Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "editButton")
            self.navigationItem.rightBarButtonItem = rightEditButton
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        
        
    }
    
    
    
    func PopToLoggedIn(sender:UIButton){
        
        println("in here touched ")
        
        let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoggedIn
        
        self.navigationController?.pushViewController(login, animated: true)
        
    }
    
    // reachability //
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
                
            } else {
                println("Reachable via Cellular")
                
            }
            
        } else {
            
            // no internet //
            self.popUpMessageForNoInternet()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    
    
    
    
    
    func popUpMessageForNoInternet(){
        
        // pop up with a notification saying that they need to connect to the internet in order to use //
        var alert:UIAlertController = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to log in", preferredStyle: UIAlertControllerStyle.Alert)
        
        // creates the Ok button that essentially does nothing //
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        nameTextField.hidden = true
        genderEditText.hidden = true
        ageEditText.hidden = true
        changePictureButton.hidden = true
        
        toggleBoolean = true
        
        // remove the '+' in the list //
        personInterests?.removeLast()
        
        mainTableView.reloadData()
        
        self.navigationItem.rightBarButtonItem?.title = "Edit Profile"
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        println("hit done!!")

        // stops the camera //
        captureSession.stopRunning()
        
        // saving the users info upon hitting done! //
        self.saveUsersInfo()

    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        // removing the observer //
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    
    
    
    // passed in from the logged in View , came over as a notification//
    func update(peopleObject:NSNotification){
        
        finalArrayOfUsersAsPFUsersId.removeAll(keepCapacity: false)
        
        if(cameFromMainUser == true){
        

        
            if var firstLevel:AnyObject? = peopleObject.userInfo{
            

                
                if var secondLevelArray:Array<AnyObject> = firstLevel?.valueForKey("userInfo") as? Array{
                    

                    
                    for (index, element) in enumerate(secondLevelArray){
                        
                        if var userInfoAsPFUser:PFUser? = element.firstObject as? PFUser{
                            

                            
                            if var personPassedInObjectId:AnyObject? = userInfoAsPFUser?.objectId{
                                
                                
                                finalArrayOfUsersAsPFUsersId.append(personPassedInObjectId!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    // sends out the final notification that they need to update //
    func sendOutNotificationToSelectUsersThatTheyNeedToPollTheServer(){
        
        for(index, element) in enumerate(finalArrayOfUsersAsPFUsersId){
            
            //println("elements id \(element)")
            
            self.sendUpdate(element)
        }
    }
    
    func sendUpdate(toUser:AnyObject){
        
        var currentUserDictionary = ["update": true]
        
        // basically needs to send over an alert saying that 'You' want to chat with them and //
        // the can either click ok or view profile //
        var dataSend = ["userInfo": currentUserDictionary, "text":false]
        
        var query:PFQuery = PFUser.query()
        query.whereKey("objectId", equalTo: toUser)
        query.whereKey("signedIn", equalTo: true)
        
        var pushQuery:PFQuery = PFInstallation.query()
        pushQuery.whereKeyExists("user")
        pushQuery.whereKey("user", matchesQuery: query)
        
        var push:PFPush = PFPush()
        push.setQuery(pushQuery)
        push.setData(dataSend)
        push.sendPushInBackgroundWithBlock({ (success:Bool, error:NSError!) -> Void in
            
            if(success == true){
                
                println("success!")
                
            }else{
                
                println("error")
            }
        })
    }

    
    
    
    
    
    
    // called when the return key is pressed //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    // sets the options to be edited //
    func editButton(){
        
        
        // edit enabled button //
        if(toggleBoolean == true){
            
            nameTextField.hidden = false
            genderEditText.hidden = false
            ageEditText.hidden = false
            changePictureButton.hidden = false
            
            toggleBoolean = false

            // adding the '+' to the end of the list //
            personInterests?.append("Add New Interest")
            
            nameTextField.text = nameLabel.text
            genderEditText.text = genderLabel.text
            ageEditText.text = ageLabel.text
            
            mainTableView.reloadData()
            
            self.navigationItem.rightBarButtonItem?.title = "Done"
            
        }
        
            // done button for editing //
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
        
        if((nameTextField.text != personName) || (genderEditText.text != personGender) || (ageEditText.text != personAge) || self.arrayOfPictures.count > 0) || (self.personInterests!.count > 0){
            
            if( (!(nameTextField.text.isEmpty)) || (!(genderEditText.text.isEmpty)) ||
                (!(ageEditText.text.isEmpty)) || self.arrayOfPictures.count > 0){
                
                    //var currentUser:PFUser = PFUser.currentUser()
                    currentUser.username = nameTextField.text
                    currentUser.setValue(genderEditText.text, forKey: "gender")
                    currentUser.setValue(ageEditText.text, forKey: "age")
                    currentUser.setValue(personInterests, forKey: "interests")
                    
                    if(self.arrayOfPictures.count > 0){
                        
                        println("sending stuff back to the main screen")
                        self.delegate?.updateCurrentUserInfo(PFUser.currentUser().username, userPicture:self.arrayOfPictures.last! as UIImage)
                        
                            var imageData = UIImagePNGRepresentation(self.arrayOfPictures.last! as UIImage)
                            var imageFile:PFFile = PFFile(name: "profilePic.png", data: imageData)
                        
                        
                        
                        currentUser.setValue(imageFile, forKey: "picture")
                        
                    }
                    
                    currentUser.saveInBackgroundWithBlock { (success:Bool, error:NSError!) -> Void in
                        
                        if(success == true){
                            
                            println("success in saving picture and stuff ")
                            
                            self.nameLabel.text = currentUser.username
                            self.genderLabel.text = currentUser.objectForKey("gender") as? String
                            self.ageLabel.text = currentUser.objectForKey("age") as? String
                            self.personInterests = currentUser.objectForKey("interests") as? Array
                            
                            
                            // sends out notifications to the remaining users that they need to update //
                            self.sendOutNotificationToSelectUsersThatTheyNeedToPollTheServer()

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
                
                let interestsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Interests") as InterestsViewController
                
                interestsViewController.delegate = self

                self.navigationController?.pushViewController(interestsViewController, animated: true)
 
            }
            
        }
        
    }
    
    
    func sendBackTheArray(interestArray: Array<String>) {
        
        for(index, element) in enumerate(interestArray){
           
            personInterests?.append(element)
            
            for(_index, _element) in enumerate(personInterests!){
                
                if(_element == "Add New Interest"){
                    
                    personInterests?.removeAtIndex(_index)
                }
            }
        }
        
        
        personInterests?.append("Add New Interest")
        mainTableView.reloadData()
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
        
        mainTableView.backgroundColor = colorPalette.lightBlueColor

        
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
                    
                    var error:NSError? = nil
                    captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &error))
                }
            }
        }
    }
    
    
    
    @IBAction func changePicOnClick(sender: UIButton) {
        
        if(captureDevice != nil){
            
            self.beginSession()
            
            cancelToggle = false
        }
    }
    
    
    func beginSession(){
        
        
        preview = AVCaptureVideoPreviewLayer(session: captureSession)
        
        var frameForCamera = CGRectMake(self.picture.frame.origin.x - size!.width, self.picture.frame.origin.y - size!.height, self.picture.frame.width + size!.width, self.picture.frame.height + size!.height)

        
        //preview?.frame = self.picture.frame
        preview?.frame = frameForCamera
        self.picture.layer.addSublayer(preview)
        
        captureSession.startRunning()
        
        changePictureButton.hidden = true
        takePictureButton.hidden = false
        cancelTakePictureButton.hidden = false
    }
    
    @IBAction func takePictureButtonOnClick(sender: UIButton) {

        // take picture button and use? button
        if(sender.tag == 0){
            
            if(sender.titleLabel?.text == "Take Pic"){
                
                println("take picture")
        
                var sessionQueue: dispatch_queue_t?
                var mainImage:UIImage?
        
                sessionQueue = dispatch_queue_create("CameraSessionController Session", DISPATCH_QUEUE_SERIAL)
        
                dispatch_async(sessionQueue, { () -> Void in

                    self.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo), completionHandler: { (buffer:CMSampleBuffer!, error:NSError!) -> Void in
                
                        if(buffer == nil){

                            mainImage = nil
                    
                        }else{
                    
                            var imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer?)
                
                            self.mainImage = UIImage(data: imageData)


                            self.takePictureButton.titleLabel!.text = "Use?"
                            self.cancelToggle = true
                            
                            self.captureSession.stopRunning()

                        }
                    })
                })
            
            
            }else{
                
                println("use? button pressed")
                
                // setting the label back //
                //self.takePictureButton.titleLabel?.text = "Take Pic"
                //sender.setTitle("Take Pic", forState: UIControlState.Normal)
                self.takePictureButton.titleLabel!.text = "Take Pic"
                

                // adding to the array of images //
                
                //if(flippedMainImage != nil){
                if(mainImage != nil){
                    //self.arrayOfPictures.append(flippedMainImage!)
                    self.arrayOfPictures.append(mainImage!)

                    //self.picture.image = flippedMainImage
                    self.picture.image = self.arrayOfPictures.last
                }
                
                
                self.takePictureButton.hidden = true
                self.cancelTakePictureButton.hidden = true
                self.changePictureButton.hidden = false

            }
        
        
            // cancel //
        }else if(sender.tag == 1){
            
            // decides to not take a picture after all //
            if(self.cancelToggle == false){
                
                println("cencelled from first cancel")
                
                // setting the default picture back //
                self.picture.image = UIImage(named: "default_center.png")
                
                println("cancelled photo")
                
                // stops the camera //
                captureSession.stopRunning()
                
                //
                self.preview?.removeFromSuperlayer()
                
                takePictureButton.hidden = true
                cancelTakePictureButton.hidden = true
                changePictureButton.hidden = false

                
                
                // cancel -- if the user decides to not keep the photo they just took //
            }else if (self.cancelToggle == true){
                
                println("cancel from second cancel")

                self.captureSession.startRunning()
                
                self.takePictureButton.titleLabel?.text = "Take Pic"
                
                self.cancelToggle = false
                
            }
        }
    }
}
