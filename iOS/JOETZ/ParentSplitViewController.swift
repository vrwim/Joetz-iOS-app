//
//  ParentSplitViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 11/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class ParentSplitViewController: UISplitViewController, UISplitViewControllerDelegate
{
    override func viewDidLoad() {
        self.delegate = self
        orientationCheck()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        orientationCheck()
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        orientationCheck()
    }
    
    func splitViewController(svc: UISplitViewController, popoverController pc: UIPopoverController, willPresentViewController aViewController: UIViewController) {
        (svc.viewControllers[0].topViewController as ParentTripsController).sidebar = pc
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
    func orientationCheck(){
        if UIDevice.currentDevice().model == "iPad" {
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                self.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
            } else {
                self.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            }
        }
    }
}