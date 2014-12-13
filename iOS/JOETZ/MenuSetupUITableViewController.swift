//
//  SideMenuSetup.swift
//  ECSlidingViewControllerTest
//
//  Created by Jan Vanhulle on 14/11/14.
//  Copyright (c) 2014 Jan Vanhulle. All rights reserved.
//

class MenuSetupUITableViewController: UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let svc = self.slidingViewController().underLeftViewController as? MenuViewController {
            //do nothing
        }
        else {
            self.slidingViewController().underLeftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as UIViewController
        }
        
        //Tmp fix for gesture + scrolling in Table view
        self.navigationController?.view.addGestureRecognizer(self.slidingViewController().panGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //When going back from other view in navigationcontroller setup
        //self.navigationController?.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        //if there is a navigationcontroller apply shadow to it instead of this view
        if self.navigationController != nil {
            self.applyMenuShadowOnView(self.navigationController!.view)
        }
        else {
            self.applyMenuShadowOnView(self.view)
        }
    }
    
    func applyMenuShadowOnView(view: UIView) {
        view.layer.shadowOpacity = 0.75
        view.layer.shadowRadius = 10.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
    }
    
    func setupMenuButton() {
        var slidingViewController = self.slidingViewController()
        
        //if there is a splitviewcontroller than take the slidingviewcontroller from that instead
        if self.splitViewController != nil {
            slidingViewController = self.splitViewController?.slidingViewController()
        }
        
        //Menu toggle
        //if: the menu is shown --> hide the menu
        if slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPosition.AnchoredRight {
            slidingViewController.resetTopViewAnimated(true)
        }
        //else: show the menu
        else {
            slidingViewController.anchorTopViewToRightAnimated(true)
        }
        
        //will probably be removed but just in case leaving it here for now
        /*if self.splitViewController != nil {
            println("Trying to hide the masterview")
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            //let svc = self.splitViewController as ParentSplitViewController
            //svc.hideMaster(true)
            //svc.hideMaster(false)
        }*/
    }
}
