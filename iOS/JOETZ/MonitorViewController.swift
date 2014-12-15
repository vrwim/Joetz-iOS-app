//
//  MonitorViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData

class MonitorViewController: UITableViewController {
    
    var monitors: [Monitor] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var token: String = ""
        
        var globalSettings: GlobalSettings?
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                globalSettings = fetchResults[0]
                println(globalSettings)
                if let globalSettingsTmp = globalSettings {
                    if let userEmail = globalSettingsTmp.loggedInUser as String? {
                        let (dict, error) = Locksmith.loadData(forKey: "details", inService: "Locksmith", forUserAccount: userEmail)
                        token = dict!["token"] as String
                    }
                }
            }
        }
        
        connectionService.getMonitors(token) {
            monitors in
            self.monitors = monitors
            self.tableView.reloadData()
            }.resume()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monitors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("monitorCell") as MonitorCell
        
        cell.monitor = monitors[indexPath.row]
        return cell
    }
    
}
