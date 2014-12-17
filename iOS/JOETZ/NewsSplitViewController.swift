//
//  NewsSplitViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 14/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

//SplitViewController for newsviews, except for the difference noted in the code, it is exactly the same as ParentSplitViewController
class NewsSplitViewController: UISplitViewController, UISplitViewControllerDelegate
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
    
    //as NewsViewController instead of as ParentTripsController
    func splitViewController(svc: UISplitViewController, popoverController pc: UIPopoverController, willPresentViewController aViewController: UIViewController) {
        (svc.viewControllers[0].topViewController as NewsViewController).sidebar = pc
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
    func orientationCheck(){
        if (UIDevice.currentDevice().model as NSString).containsString("iPad") {
            if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                if self.view.frame.origin.x == 0 {
                    self.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
                }
            } else {
                self.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay//no clue why, but without this the masterview might show up as a gray field
                self.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            }
        }
    }
    
    /*
    //Keeping this just in case ...
    func hideMaster(pHideMaster: Bool) {
    self.hideMaster = pHideMaster
    
    self.view.setNeedsLayout()
    self.delegate = nil
    self.delegate = self
    
    self.willRotateToInterfaceOrientation(UIApplication.sharedApplication().statusBarOrientation, duration: 0)
    self.view.setNeedsDisplay()
    }*/
}