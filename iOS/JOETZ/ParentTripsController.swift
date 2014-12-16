//
//  VacationCategoryTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ParentTripsController: MenuSetupUITableViewController, UISearchBarDelegate, UISearchDisplayDelegate
{
    var trips = [Trip]()
    var filteredTrips = [Trip]()
    var task: NSURLSessionTask?
    var sidebar: UIPopoverController?
    var parentTripTabVC: ParentTripTabVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        task = connectionService.createFetchTask({
            alert, data in
            self.presentViewController(alert, animated: true, completion: nil)
            }) {
            trips in
            self.trips = trips
            self.tableView.reloadData()
        }
        task!.resume()
        tableView.setContentOffset(CGPointMake(0,44), animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        parentTripTabVC?.sidebar = sidebar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        parentTripTabVC = (segue.destinationViewController as UINavigationController).topViewController as? ParentTripTabVC
        var selectedTrip: Trip
        if (sender as UITableViewCell).isDescendantOfView(self.searchDisplayController!.searchResultsTableView) {
            selectedTrip = filteredTrips[self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!.row]
        } else {
            selectedTrip = trips[self.tableView.indexPathForSelectedRow()!.row]
        }
        parentTripTabVC?.trip = selectedTrip
        parentTripTabVC?.sidebar = sidebar
    }
    
    func filterContentForSearchText(searchText: String){
        self.filteredTrips = self.trips.filter({(trip: Trip) -> Bool in
            let stringMatch = trip.title!.lowercaseString.rangeOfString(searchText.lowercaseString)
            let locMatch = trip.location!.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (stringMatch != nil || locMatch != nil)
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
            return filteredTrips.count
        } else {
            return trips.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("parentTripCell") as ParentTripCell
        
        var trip: Trip
        if tableView == self.searchDisplayController!.searchResultsTableView {
            trip = filteredTrips[indexPath.row]
        } else {
            trip = trips[indexPath.row]
        }
        cell.setContent(trip)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }

    @IBAction func refresh(sender: UIRefreshControl) {
        let task = connectionService.createFetchTask({
            alert, data in
            self.presentViewController(alert, animated: true, completion: nil)
            sender.endRefreshing()
            }) {
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
