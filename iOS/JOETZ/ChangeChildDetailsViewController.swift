//
//  ChangeChildDetailsViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChangeChildDetailsViewController: FormViewController, FormViewControllerDelegate
{
    
    @IBAction func saveChildDetails(sender: UIBarButtonItem) {
    }
    
    
    @IBAction func cancelBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
