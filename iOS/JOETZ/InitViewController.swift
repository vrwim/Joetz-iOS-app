//
//  InitViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 22/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class InitViewController: ECSlidingViewController
{
    override func viewDidLoad() {
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StartVC") as UIViewController
        super.viewDidLoad()
    }
    
}
