//
//  TripTableViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 5/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import MapKit

class TripController: UITableViewController
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
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trip.promo == nil ? 5 : super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
}
