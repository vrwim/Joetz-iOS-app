//
//  StartViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/20/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("StartViewController did load")
    }
    
    @IBAction func childButton(sender: UIButton) {
        
        UserService.changeViewType("childView")
        
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChildTripsNavVC") as UIViewController
        self.slidingViewController().topViewController = newTopViewController
        
    }
    
    @IBAction func parentButton(sender: UIButton) {
        UserService.changeViewType("parentView")
        
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentTripsSplitVC") as UIViewController
        self.slidingViewController().topViewController = newTopViewController
    }
    
    @IBAction func loginButton(sender: UIButton) {
        UserService.changeViewType("parentView")
        
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavVC") as UIViewController
        self.slidingViewController().topViewController = newTopViewController
        
    }
}

