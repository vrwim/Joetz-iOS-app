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
    
    @IBAction func onClickEnroll(sender: UIBarButtonItem) {
        var u = UserService.getDetailsLoggedInUser()
        let token = u["token"]
        if token == nil {
            var alert = UIAlertController(title: "Niet ingelogd", message: "U dient ingelogd te zijn om in te schrijven", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            connectionService.getUserData(token!) {
                user in
                let enrollViewController = self.storyboard?.instantiateViewControllerWithIdentifier("enrollVC") as EnrollViewController
                println(user)
                println(self.trip)
                enrollViewController.user = user
                enrollViewController.trip = self.trip
                enrollViewController.setupForm()
                let newTopViewController = UINavigationController(rootViewController: enrollViewController)
                self.slidingViewController().topViewController = newTopViewController
                }.resume()
        }
    }
}