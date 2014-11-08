//
//  TripCell.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/7/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ParentTripCell: UITableViewCell {
    
    var trip: Trip!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vanLabel: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var regioLabel: UILabel!
    @IBOutlet weak var vanLeeftijdLabel: UILabel!
    @IBOutlet weak var totLeeftijdLabel: UILabel!
    
    func setContent(trip: Trip) {
        self.trip = trip
        titleLabel.text = trip.title!
        vanLabel.text = "Van \(trip.beginDate!)"
        totLabel.text = "Tot \(trip.endDate!)"
        regioLabel.text = "Regio \(trip.location!)"
        vanLeeftijdLabel.text = "Van \(trip.minAge!) jaar"
        totLeeftijdLabel.text = "Tot \(trip.maxAge!) jaar"
        
    }
}
