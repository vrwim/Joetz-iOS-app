//
//  InitViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 22/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

class InitViewController: ECSlidingViewController
{
    override func viewDidLoad() {
        
        //Waarschijnlijk overschakelen op NSUserDefaults --> veel gemakkelijk en veel beter voor app settings
        var viewType: String = ""
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            println("before count if")
            if fetchResults.count > 0
            {
                //check if viewType is parent view --> if not check if childView --> if not empty string
                viewType = fetchResults[0].viewType == "parentView" ? "ParentTripsSplitVC" : (fetchResults[0].viewType == "childView" ? "ChildTripsNavVC" : "")
                println(viewType)
            }
        }
        if viewType.isEmpty {
            viewType = "StartVC"
        }
        
        println(viewType)
        
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewType) as UIViewController
        super.viewDidLoad()
    }
    
}