//
//  AccountViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 14/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class AccountViewController: MenuSetupUITableViewController {
    
    let tableItems = [("AccountGegevens wijzigen")]
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
    }
    
}