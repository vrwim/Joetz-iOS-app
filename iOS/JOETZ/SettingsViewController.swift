//
//  SettingsViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: MenuSetupUITableViewController {
    
    @IBOutlet weak var childView: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("SettingsViewController did load")
        
        if getViewType() == "childView" {
            childView.setOn(true, animated: true)
        }
        else {
            childView.setOn(false, animated: true)
        }
        
    }
    
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
    
    @IBAction func switchView(sender: UISwitch) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                //check if viewType is parent view --> if not check if childView --> if not empty string
                println(childView.on)
        
                if childView.on {
                    fetchResults[0].viewType = "childView"
                    println("childView")
                }
                else {
                    fetchResults[0].viewType = "parentView"
                    println("parentView")
                }
            }
        }
        context.save(nil)
        
        println("View switched")
    }
    
    func getViewType() -> String {
        var viewType: String = ""
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                //check if viewType is parent view --> if not check if childView --> if not empty string
                viewType = fetchResults[0].viewType
            }
        }
        
        return viewType
    }
    
}