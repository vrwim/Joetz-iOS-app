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
    @IBOutlet weak var vanLabel: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var regioLabel: UILabel!
    @IBOutlet weak var vanTotLabel: UILabel!
    @IBOutlet weak var prijsLabel: UILabel!
    @IBOutlet weak var beschrijvingLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var beschrijvingCell: UITableViewCell!
    @IBOutlet weak var capaciteitLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    
    var trip: Trip!
    
    override func viewDidLoad() {
        navigationItem.title = trip.title!
        
        vanLabel.text = "Van \(trip.beginDate!)"
        totLabel.text = "Tot \(trip.endDate!)"
        regioLabel.text = "Regio \(trip.location!)"
        vanTotLabel.text = "Van \(trip.minAge!) tot \(trip.maxAge!) jaar"
        prijsLabel.text = "Prijs: €\(trip.basicPrice!)"
        capaciteitLabel.text = "Capaciteit: \(trip.capacity!)"
        transportLabel.text = "Transport: \(trip.transport!)"
        beschrijvingLabel.text = trip.promo?
        
        let location = trip.destination
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) {
            placemarks, error in
            if error != nil {
                
                println("Error", error)
            } else if let placemark = placemarks?[0] as? CLPlacemark {
                
                var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                // pointAnnotation.title = trip.destination
                
                self.map.addAnnotation(pointAnnotation)
                self.map.centerCoordinate = coordinates
                self.map.selectAnnotation(pointAnnotation, animated: true)
                
                let mapCenter = coordinates
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1500)
                self.map.setCamera(mapCamera, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trip.promo == nil ? 7 : super.tableView(tableView, numberOfRowsInSection: section)
        case 1:
            return trip.inclusives?.count ?? 0
        case 3:
            return trip.prices?.count ?? 0
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let inclusive = trip.inclusives![indexPath.row]
            
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            
            cell.textLabel.text = inclusive
            cell.textLabel.lineBreakMode = .ByWordWrapping
            cell.textLabel.numberOfLines = 0
            
            return cell
        case 3:
            let price = trip.prices![indexPath.row]
            
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            
            cell.textLabel.text = price.0
            cell.detailTextLabel?.text = "\(price.1)"
            cell.textLabel.lineBreakMode = .ByWordWrapping
            cell.textLabel.numberOfLines = 0
            
            return cell
        default:
            return super.tableView(tableView,cellForRowAtIndexPath: indexPath)
        }
        
    }
}

