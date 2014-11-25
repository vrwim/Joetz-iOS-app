//
//  VacationCategoryTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ParentTripsController: MenuSetupUITableViewController
{
    var trips: [Trip] = []
    var task: NSURLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        task = connectionService.createFetchTask {
            trips in
            self.trips = trips
            self.tableView.reloadData()
        }
        task!.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let tripController = segue.destinationViewController as ParentTripController
        let parentTripTabVC = segue.destinationViewController as ParentTripTabVC
        let selectedTrip = trips[tableView.indexPathForSelectedRow()!.row]
        //tripController.trip = selectedTrip
        parentTripTabVC.trip = selectedTrip
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("parentTripCell") as ParentTripCell
        
        let trip = trips[indexPath.row]
        cell.setContent(trip)
        
        return cell
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        let task = connectionService.createFetchTask {
            trips in
            self.trips = trips
            self.tableView.reloadData()
            sender.endRefreshing()
        }
        task.resume()
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}
