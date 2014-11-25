//
//  SettingsViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class SettingsViewController: MenuSetupUITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("SettingsViewController did load")
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}