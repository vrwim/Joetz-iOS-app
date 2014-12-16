//
//  ChildrenFromParentViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChildrenFromParentViewController: MenuSetupUITableViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
    }
}