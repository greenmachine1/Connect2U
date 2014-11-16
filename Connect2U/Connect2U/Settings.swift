//
//  Settings.swift
//  Connect2U
//
//  Created by Cory Green on 11/16/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit

class Settings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // centering the background image itself //
        UIGraphicsBeginImageContext(self.view.frame.size)
        var backgroundImage = UIImage(named: "Color_strip.jpg")
        backgroundImage?.drawInRect(self.view.bounds)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)

        println("Settings")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
