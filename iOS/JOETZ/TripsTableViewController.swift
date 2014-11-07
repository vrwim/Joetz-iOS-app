//
//  VacationCategoryTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class TripsController: UITableViewController
{
    var trips: [Trip] = []
    var task: NSURLSessionTask?
    
    override func viewDidLoad() {
        task = connectionService.createFetchTask {
            trips in
            self.trips = trips
            self.tableView.reloadData()
        }
        task!.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tripController = segue.destinationViewController as TripController
        let selectedTrip = trips[tableView.indexPathForSelectedRow()!.row]
        tripController.trip = selectedTrip
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell") as TripCell
        
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
}
