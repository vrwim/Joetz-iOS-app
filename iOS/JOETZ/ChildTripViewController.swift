//
//  ChildTripViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import Foundation

class ChildTripViewController: UIViewController {
    
    var trip: Trip?
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set labels/textViews/buttons/... here
        testLabel.text = trip?.title
        
    }
    
}