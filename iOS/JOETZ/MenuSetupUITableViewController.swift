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
        self.navigationController?.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
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
        let slidingViewController = self.slidingViewController()
        
        //Menu button toggle
        if slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPosition.AnchoredRight {
            slidingViewController.resetTopViewAnimated(true)
        }
        else {
            slidingViewController.anchorTopViewToRightAnimated(true)
        }
    }
}
