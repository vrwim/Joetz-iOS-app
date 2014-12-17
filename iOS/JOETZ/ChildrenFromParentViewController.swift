//
//  ChildrenFromParentViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChildrenFromParentViewController: MenuSetupUITableViewController
{
    var children: [(childId: String, isMemberOfSocialMutuality: Bool?, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: String?, zipcode: String?, bus: String?, city: String?)] = []
    var task: NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        else {
            let user = UserService.getDetailsLoggedInUser()
            let token = user["token"]
            
            task = connectionService.getUserData(token!){
                user in
                self.children = user.children
            }
            task!.resume()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ChildFromParent") as UITableViewCell
        var child = children[indexPath.row]

        cell.textLabel?.text = "\(child.firstname) \(child.lastname)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let changeChildDetailsVC = segue.destinationViewController as? ChangeChildDetailsViewController {
            let selectedChild = children[tableView.indexPathForSelectedRow()!.row]
            changeChildDetailsVC.child = selectedChild
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        let user = UserService.getDetailsLoggedInUser()
        let token = user["token"]
        
        task = connectionService.getUserData(token!){
            user in
            self.children = user.children
            self.tableView.reloadData()
            sender.endRefreshing()
        }
        task!.resume()
    }
    
}