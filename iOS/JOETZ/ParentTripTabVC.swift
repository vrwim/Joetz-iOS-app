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
        dismissSidebar()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        dismissSidebar()
    }
    
    func dismissSidebar() {
        println(trip)
        println(sidebar)
        if trip != nil {
            println("deleting")
            println(sidebar?.popoverVisible)
            sidebar?.dismissPopoverAnimated(true)
            println(sidebar?.popoverVisible)
                        println("should be gone now")
        }
    }
}