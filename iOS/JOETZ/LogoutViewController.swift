//
//  LogoutViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

class LogoutViewController: MenuSetupUIViewController {
    
    @IBAction func logout(sender: UIButton) {
        var tempMail: String?
        var viewType: String?
        
        var globalSettings: GlobalSettings?
        let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                globalSettings = fetchResults[0]
                
                if let globalSettingsTmp = globalSettings {
                    tempMail = globalSettings!.loggedInUser
                    globalSettings!.loggedInUser = nil
                    viewType = fetchResults[0].viewType == "parentView" ? "ParentTripsSplitVC" : (fetchResults[0].viewType == "childView" ? "ChildTripsNavVC" : "")
                }
                
                context.save(nil)
            }
        }
        Locksmith.deleteData(forKey: "details", inService: "Locksmith", forUserAccount: tempMail!)
        
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewType!) as UIViewController
        println(newTopViewController)
        //Switch to new view
        self.slidingViewController().topViewController = newTopViewController
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}