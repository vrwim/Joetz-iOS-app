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
    
    var trip: Trip!
    
    override func viewDidLoad() {
        navigationItem.title = trip.title!
        
        vanLabel.text = "Van \(trip.beginDate!)"
        totLabel.text = "Tot \(trip.endDate!)"
        regioLabel.text = "Regio \(trip.location!)"
        vanTotLabel.text = "Van \(trip.minAge!) tot \(trip.maxAge!) jaar"
        prijsLabel.text = "Prijs: €\(trip.basicPrice!)"
        beschrijvingLabel.text = trip.promo?
        
        let location = trip.destination
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if ((error) != nil) {
                
                println("Error", error)
            } else if let placemark = placemarks?[0] as? CLPlacemark {
                
                var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                //pointAnnotation.title = "Apple HQ"
                
                self.map.addAnnotation(pointAnnotation)
                self.map.centerCoordinate = coordinates
                self.map.selectAnnotation(pointAnnotation, animated: true)
                
                println("Center map on user location.")
                let mapCenter = coordinates
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1500)
                self.map.setCamera(mapCamera, animated: true)
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trip.promo == nil ? 5 : super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
}
