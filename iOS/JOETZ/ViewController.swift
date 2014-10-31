//
//  ViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/20/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // checken op "kind" of "ouder" segue; "login" niets doen, laten overgaan
    }
}

