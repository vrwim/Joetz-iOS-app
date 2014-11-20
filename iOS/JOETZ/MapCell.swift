//
//  MapCell.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/20/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationString: String! {
        didSet {
            println("didSet: \(locationString)")
            println("height: \(mapView.bounds.height)")
            println("width: \(mapView.bounds.width)")
            
            var geocoder:CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationString) {
                placemarks, error in
                if error != nil {
                    println("Error: \(error)")
                } else if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                    var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                    
                    var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = coordinates
                    // pointAnnotation.title = trip.destination
                    
                    self.mapView.addAnnotation(pointAnnotation)
                    self.mapView.centerCoordinate = coordinates
                    self.mapView.selectAnnotation(pointAnnotation, animated: true)
                    
                    let mapCenter = coordinates
                    var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1500)
                    self.mapView.setCamera(mapCamera, animated: true)
                }
            }
        }
    }
}
