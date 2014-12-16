//
//  MonitorViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData

class MonitorViewController: MenuSetupUITableViewController {
    
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
                        token = dict?["token"] as String
                    }
                }
            }
        }
        if token != "" {
            connectionService.getMonitors(token) {
                monitors in
                self.monitors = monitors
                self.tableView.reloadData()
                }.resume()
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let monitor = monitors[indexPath.row]
        
        /*
        It is pretty difficult to add UIActivities
        
        var activityItems = ["mailto://\(monitor.email)"]
        if let gsm = monitor.gsm {
        activityItems.append("tel://\(gsm)")
        }
        
        var activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated:true, completion: nil)
        */
        
        var alert = UIAlertController(title: "Contacteer", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        if let gsm = monitor.gsm {
            alert.addAction(UIAlertAction(title: "SMS", style: .Default) {
                _ in
                var url = NSURL(string: "sms:\(gsm)")
                UIApplication.sharedApplication().openURL(url!)
                })
            alert.addAction(UIAlertAction(title: "Bellen", style: .Default) {
                _ in
                var url = NSURL(string: "tel://\(gsm)")
                UIApplication.sharedApplication().openURL(url!)
                })
        }
        alert.addAction(UIAlertAction(title: "e-mail", style: .Default) {
            _ in
            var url = NSURL(string: "mailto:\(monitor.email)")
            UIApplication.sharedApplication().openURL(url!)
            })
        alert.addAction(UIAlertAction(title: "Annuleer", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickMenuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}
