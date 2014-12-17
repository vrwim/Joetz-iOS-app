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
    var children: [(childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)] = []
    var task: NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = UserService.getDetailsLoggedInUser()
        let token = user["token"]
        
        task = connectionService.getUserData(token!){
            user in
            self.children = user.children
            self.tableView.reloadData()
        }
        task!.resume()
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
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let childrenDetailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("childDetailsVC") as ChangeChildDetailsViewController
        childrenDetailsVC.child = children[indexPath.row]
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