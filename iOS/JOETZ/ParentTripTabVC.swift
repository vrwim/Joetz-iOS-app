//
//  TmpTabVC.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class ParentTripTabVC: UITabBarController
{
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.translucent = false
    }
}