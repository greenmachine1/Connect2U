//
//  ChatViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/19/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var mainInputField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setColors()
        
        self.mainInputField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShow"), name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    
    func keyboardShow(){
        
        var getMainInputFieldLocation:CGPoint = CGPoint(x: mainInputField.layer.frame.origin.x, y: mainInputField.layer.frame.origin.y)
        
        mainInputField.frame.origin.x = 300
        
        
        println("\(getMainInputFieldLocation)")
    }
    
    
    // the return key //
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        mainInputField.resignFirstResponder()
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // what will be in each row //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        if((indexPath.row % 2) == 0){

            let cell = tableView.dequeueReusableCellWithIdentifier("cellLeft", forIndexPath: indexPath) as ChatLeftCell
            
            cell.backgroundColor = greenColor
            cell.layer.cornerRadius = 3.0
            //scell.layer.borderWidth = 1.0
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.leftLabel.text = "Cory @ 18:10pm"
            cell.leftLabel.textColor = darkGreenColor
            cell.leftLabel.backgroundColor = greenColor
            cell.leftLabel.layer.cornerRadius = 3.0
            cell.leftLabel.clipsToBounds = true
            cell.dataLabel.textColor = darkGreenColor
            cell.dataLabel.backgroundColor = greenColor
            cell.dataLabel.text = "Hey, hows it going?"
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            //cell.dataLabel.layer.borderWidth = 1.0
            //cell.dataLabel.layer.borderColor = UIColor.blackColor().CGColor
            
        
            return cell
        }else{
            
            //let cell = tableView.dequeueReusableCellWithIdentifier("cellRight") as RightChatCell
            let cell = tableView.dequeueReusableCellWithIdentifier("cellRight", forIndexPath: indexPath) as RightChatCell
            
            
            cell.backgroundColor = darkGreenColor
            cell.layer.cornerRadius = 3.0
            //cell.layer.borderWidth = 1.0
            //cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.rightLabel.text = "Kevin @ 18:11pm"
            cell.rightLabel.textColor = whiteColor
            cell.rightLabel.backgroundColor = darkGreenColor
            cell.rightLabel.layer.cornerRadius = 3.0
            cell.rightLabel.clipsToBounds = true
            cell.dataLabel.textColor = whiteColor
            cell.dataLabel.backgroundColor = darkGreenColor
            cell.dataLabel.text = "Im pretty good, how are you?"
            cell.dataLabel.layer.cornerRadius = 3.0
            cell.dataLabel.clipsToBounds = true
            //cell.dataLabel.layer.borderWidth = 1.0
            //cell.dataLabel.layer.borderColor = UIColor.blackColor().CGColor
            
            
            return cell
        }
    }
    
    
    // number of rows //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    
    
    // setting colors for the view //
    func setColors(){
        
        var whiteColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var lightBlueColor:UIColor = UIColor(red: 0.431, green: 0.808, blue: 0.933, alpha: 1.0)
        var greenColor:UIColor = UIColor(red: 0.192, green: 0.733, blue: 0.855, alpha: 1.0)
        var darkGreenColor:UIColor = UIColor(red: 0.075, green: 0.467, blue: 0.557, alpha: 1.0)
        
        self.view.backgroundColor = lightBlueColor
        mainTableView.backgroundColor = lightBlueColor
        
    }


}
