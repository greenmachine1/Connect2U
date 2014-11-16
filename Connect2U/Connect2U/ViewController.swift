//
//  ViewController.swift
//  Connect2U
//
//  Created by Cory Green on 11/11/14.
//  Copyright (c) 2014 com.Cory. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // centering the background image itself //
        UIGraphicsBeginImageContext(self.view.frame.size)
        var backgroundImage = UIImage(named: "Color_strip.jpg")
        backgroundImage?.drawInRect(self.view.bounds)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

