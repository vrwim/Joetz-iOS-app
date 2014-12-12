//
//  TripTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import MapKit

class ParentTripController: MenuSetupUITableViewController
{
    
    var trip: Trip!
    var images: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentTripTabVC: ParentTripTabVC = self.parentViewController as ParentTripTabVC
        trip = parentTripTabVC.trip
        //self.parentViewController?.navigationItem.title = trip.title todo vanaf titelbalk in orde is

        //Fix om table niet onder statusbar/navbar te laten beginnen
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        var inset: UIEdgeInsets
        if self.navigationController != nil {
            let navBarHeight = self.navigationController?.navigationBar.bounds.height
            inset = UIEdgeInsets(top: navBarHeight! + statusBarHeight, left: 0, bottom: 0, right: 0)
        } else {
            inset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        }
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = inset
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")){
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if trip == nil {
            return 0
        }
        return 4 // Basic Info, Inclusives, Prijzen, Kaart
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trip.promo == nil ? 7 : 8
        case 1:
            return trip.inclusives?.count ?? 0
        case 2:
            return trip.prices?.count ?? 0
        case 3:
            return 1
        default:
            println("Error: Asking for #cells in section \(section)")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "INFO"
        case 1:
            return "INCLUSIVES"
        case 2:
            return "PRIJZEN"
        case 3:
            return "KAART"
        default:
            println("Error: Asking for #cells in section \(section)")
            return ""
        }
    }
    
    /*override func tableView(derp: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { //todo fix mapcell resizing
        switch indexPath.section {
        case 0,1: return 44
        case 2: return 54
        case 3: return 320.5
        default: return 44
        }
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // basic info
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell") as UITableViewCell
            
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = "Van \(trip.beginDate!)"
            case 1:
                cell.textLabel!.text = "Tot \(trip.endDate!)"
            case 2:
                cell.textLabel!.text = trip.location
            case 3:
                cell.textLabel!.text = "Van \(trip.minAge!) tot \(trip.maxAge!) jaar"
            case 4:
                cell.textLabel!.text = "Prijs: €\(trip.basicPrice!)"
            case 5:
                cell.textLabel!.text = "Capaciteit: \(trip.capacity!)"
            case 6:
                cell.textLabel!.text = "Transport: \(trip.transport!)"
            case 7:
                cell.textLabel!.text = trip.promo
                cell.textLabel!.lineBreakMode = .ByWordWrapping
                cell.textLabel!.numberOfLines = 0
            default:
                println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            }
            return cell
        case 1:
            // inclusives
            let inclusive = trip.inclusives![indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell") as UITableViewCell
            
            cell.textLabel!.text = inclusive
            cell.textLabel!.lineBreakMode = .ByWordWrapping
            cell.textLabel!.numberOfLines = 0
            
            return cell
        case 2:
            // prices
            let price = trip.prices![indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("subtitleCell") as UITableViewCell
            
            cell.textLabel!.text = price.0
            cell.detailTextLabel?.text = "€\(price.1)"
            cell.textLabel!.lineBreakMode = .ByWordWrapping
            cell.textLabel!.numberOfLines = 0
            
            return cell
        case 3:
            // map
            let cell = tableView.dequeueReusableCellWithIdentifier("mapCell") as MapCell
            cell.locationString = trip.location
            
            return cell
        default:
            println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            return super.tableView(tableView,cellForRowAtIndexPath: indexPath)
        }
        
    }
}

