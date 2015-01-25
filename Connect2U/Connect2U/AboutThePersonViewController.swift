//
//  AboutThePersonViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/18/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class AboutThePersonViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var personName:String?
    var personsPic:String?
    var image:UIImage?
    var personAge:Int?
    var personInterests:Array<String>?
    var personGender:String?
    
    var userPassedIn:PFUser?
    var personPassedInNotPFUser:AnyObject?
    var cameFromMainUser:Bool?
    
    var toggleBoolean:Bool?
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
        var cornerRadiusOfPicture = CGFloat(picture.frame.height / 2)
        
        println(picture.frame.height)
        println(picture.frame.width)
        
        picture.layer.cornerRadius = cornerRadiusOfPicture
        picture.clipsToBounds = true
        picture.layer.borderColor = UIColor.blackColor().CGColor
        picture.layer.borderWidth = 3.0
        
        nameTextField.hidden = true
        genderEditText.hidden = true
        ageEditText.hidden = true
        
        toggleBoolean = true
        changePictureButton.hidden = true
        
        mainTableView.delegate = self
        
        if(userPassedIn != nil){
            
            personName = userPassedIn?.username
            nameLabel.text = personName
            
            personAge = userPassedIn?.objectForKey("age") as? Int
            
            var tempAgeString = "\(personAge!)"
            ageLabel.text = tempAgeString
            
            
            
            personInterests = userPassedIn?.objectForKey("interests") as? Array
            
            
            
            //var tempInterestString = "\(personInterests!)"
            //interestsLabel.text = tempInterestString
            
            personGender = userPassedIn?.objectForKey("gender") as? String
            genderLabel.text = personGender
        }
        
        if(personPassedInNotPFUser != nil){
            
            var userInfoLevel:AnyObject? = personPassedInNotPFUser?.objectForKey("userInfo")
            if(userInfoLevel != nil){
                
                personName = userInfoLevel!.objectForKey("username") as? String
                nameLabel.text = personName
                
                personAge = userInfoLevel!.objectForKey("age") as? Int
                
                var tempAgeString = "\(personAge!)"
                ageLabel.text = tempAgeString
                
                
                
                
                personInterests = userInfoLevel!.objectForKey("interests") as? Array
                
                
                
                //var tempInterestString = "\(personInterests!)"
                //interestsLabel.text = tempInterestString
                
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
        }
    }

    
    
    
    @IBAction func changePicOnClick(sender: UIButton) {
        
        println("change selected")
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
        //ageLabel.backgroundColor = colorPalette.greenColor
        //ageLabel.textAlignment = .Center
        
        genderLabel.textColor = colorPalette.whiteColor
        //genderLabel.backgroundColor = colorPalette.greenColor
        //genderLabel.textAlignment = .Center
        
        //interestsLabel.textColor = colorPalette.whiteColor
        //interestsLabel.backgroundColor = colorPalette.greenColor
        //interestsLabel.textAlignment = .Center
        
        changePictureButton.backgroundColor = colorPalette.whiteColor
        changePictureButton.layer.cornerRadius = 5.0
        changePictureButton.clipsToBounds = true
        changePictureButton.layer.borderWidth = 2.0
        changePictureButton.layer.borderColor = UIColor.blackColor().CGColor
        changePictureButton.alpha = 1.0
        
        
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
}
