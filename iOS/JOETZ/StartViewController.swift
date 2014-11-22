//
//  StartViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/20/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        println("StartViewController did load")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // checken op "kind" of "ouder" segue; "login" niets doen, laten overgaan
    }
    
    @IBAction func childButton(sender: UIButton) {
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChildTripsNavVC") as UIViewController
        self.slidingViewController().topViewController = newTopViewController
        
    }
    
    @IBAction func parentButton(sender: UIButton) {
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentTripsNavVC") as UIViewController
        self.slidingViewController().topViewController = newTopViewController
    }
    
    @IBAction func loginButton(sender: UIButton) {
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavVC") as UIViewController
        /*newTopViewController.view.frame = self.slidingViewController().view.bounds
        newTopViewController.view.alpha = 0
        
        self.slidingViewController().view.addSubview(newTopViewController.view)
        
        UIView.animateWithDuration(0.5, animations: {newTopViewController.view.alpha = 1}, completion: {
            finished in
            newTopViewController.view.removeFromSuperview()
            
            self.slidingViewController().topViewController = newTopViewController
        })*/
        
        self.slidingViewController().topViewController = newTopViewController
        
    }
}

