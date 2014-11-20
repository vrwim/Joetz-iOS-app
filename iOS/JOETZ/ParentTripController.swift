//
//  TripTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import MapKit

class ParentTripController: UITableViewController
{
    
    var trip: Trip!
    var images: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        navigationItem.title = trip.title!
        for imagePath in trip.pictures! {
            connectionService.createFetchTask(imagePath) {
                image in
                self.images[imagePath] = image
                self.tableView.reloadData()
                }.resume()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5 // Basic Info, Inclusives, Afbeeldingen, Prijzen, Kaart
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trip.promo == nil ? 7 : 8
        case 1:
            return trip.inclusives?.count ?? 0
        case 2:
            return images.count
        case 3:
            return trip.prices?.count ?? 0
        case 4:
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
            return "AFBEELDINGEN"
        case 3:
            return "PRIJZEN"
        case 4:
            return "KAART"
        default:
            println("Error: Asking for #cells in section \(section)")
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // basic info
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell") as UITableViewCell
            
            switch indexPath.row {
            case 0:
                cell.textLabel.text = "Van \(trip.beginDate!)"
            case 1:
                cell.textLabel.text = "Tot \(trip.endDate!)"
            case 2:
                cell.textLabel.text = "Regio \(trip.location!)"
            case 3:
                cell.textLabel.text = "Van \(trip.minAge!) tot \(trip.maxAge!) jaar"
            case 4:
                cell.textLabel.text = "Prijs: €\(trip.basicPrice!)"
            case 5:
                cell.textLabel.text = "Capaciteit: \(trip.capacity!)"
            case 6:
                cell.textLabel.text = "Transport: \(trip.transport!)"
            case 7:
                cell.textLabel.text = trip.promo
                cell.textLabel.lineBreakMode = .ByWordWrapping
                cell.textLabel.numberOfLines = 0
            default:
                println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            }
            return cell
        case 1:
            // inclusives
            let inclusive = trip.inclusives![indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("basicCell") as UITableViewCell
            
            cell.textLabel.text = inclusive
            cell.textLabel.lineBreakMode = .ByWordWrapping
            cell.textLabel.numberOfLines = 0
            
            return cell
        case 2:
            // images
            // Maybe while trip.pictures.count > images.count { add(loadingMoreImages) } ?
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as ImageCell
            
            cell.pictureView.image = images[trip.pictures![indexPath.row]]
            
            return cell
        case 3:
            // prices
            let price = trip.prices![indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("subtitleCell") as UITableViewCell
            
            cell.textLabel.text = price.0
            cell.detailTextLabel?.text = "€\(price.1)"
            cell.textLabel.lineBreakMode = .ByWordWrapping
            cell.textLabel.numberOfLines = 0
            
            return cell
        case 4:
            // map
            let cell = tableView.dequeueReusableCellWithIdentifier("mapCell") as MapCell
            
            cell.locationString = trip.destination
            
            return cell
        default:
            println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            return super.tableView(tableView,cellForRowAtIndexPath: indexPath)
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 2:
            var image = images[trip.pictures![indexPath.row]]
            
            if image != nil {
                var screenRect = UIScreen.mainScreen().bounds
                var screenWidth = screenRect.size.width
                
                var imageHeight = image!.size.height
                var imageWidth = image!.size.width
                
                return imageHeight/(imageWidth/screenWidth)
            }
            return 0
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}

