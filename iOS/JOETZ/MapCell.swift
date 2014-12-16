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
            var gp = GooglePlaces()
            gp.search(locationString.componentsSeparatedByString(", ")[0]) { (items, errorDescription) -> Void in
                if items != nil && items!.count > 0{
                    self.setMap(items![0])
                } else {
                    var geocoder:CLGeocoder = CLGeocoder()
                    geocoder.geocodeAddressString(self.locationString.componentsSeparatedByString(", ")[1]) {
                        placemarks, error in
                        if error != nil {
                            println("Error: \(error) (Probably no internet)")
                        } else if let placemark = placemarks?[0] as? CLPlacemark {
                            self.setMap(placemark)
                        }
                    }
                }
            }
        }
    }
    
    func setMap(pm : CLPlacemark){
        var coordinates:CLLocationCoordinate2D = pm.location.coordinate
        
        var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        // pointAnnotation.title = trip.destination
        
        mapView.mapType = MKMapType.Hybrid
        
        mapView.addAnnotation(pointAnnotation)
        mapView.centerCoordinate = coordinates
        mapView.selectAnnotation(pointAnnotation, animated: true)
        
        let mapCenter = coordinates
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1500)
        mapView.setCamera(mapCamera, animated: true)
    }
}
