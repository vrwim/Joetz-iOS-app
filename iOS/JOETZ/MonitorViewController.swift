//
//  MonitorViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class MonitorViewController: MenuSetupUITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var monitors = [Monitor]()
    var filteredMonis = [Monitor]()
    var token = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            monitors = cacheService.normalizedMonisCache()
            tableView.reloadData()
            let queue = NSOperationQueue()
            queue.addOperationWithBlock(){
                self.monitors = cacheService.updateMonis(self.token)
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.tableView.reloadData()
                }
            }
            tableView.setContentOffset(CGPointMake(0,44), animated: true)
        }
    }
    
    func filterContentForSearchText(searchText: String){
        self.filteredMonis = self.monitors.filter({(moni: Monitor) -> Bool in
            let nameMatch = moni.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            let gsmMatch = moni.gsm?.lowercaseString.rangeOfString(searchText.lowercaseString)
            let emailMatch = moni.email?.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (nameMatch != nil || gsmMatch != nil || emailMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredMonis.count
        } else {
            return monitors.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("monitorCell") as MonitorCell
        
        var monitor: Monitor
        if tableView == self.searchDisplayController!.searchResultsTableView {
            monitor = filteredMonis[indexPath.row]
        } else {
            monitor = monitors[indexPath.row]
        }

        cell.monitor = monitor
        cell.table = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        if token != "" {
            let queue = NSOperationQueue()
            queue.addOperationWithBlock(){
                self.monitors = cacheService.updateMonis(self.token)
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
            }
        }
    }
    
    @IBAction func onClickMenuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
