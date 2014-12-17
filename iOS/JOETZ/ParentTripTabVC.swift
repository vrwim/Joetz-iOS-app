//
//  ParentTripTabVC.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class ParentTripTabVC: UITabBarController
{
    var trip: Trip!
    var sidebar: UIPopoverController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.translucent = false
        if trip != nil {
            sidebar?.dismissPopoverAnimated(true)
        }
        UITabBar.appearance().tintColor = UIColor.redColor()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        if trip != nil {
            sidebar?.dismissPopoverAnimated(false)//this should be without animation but strangly only works with animation
        }
    }
}