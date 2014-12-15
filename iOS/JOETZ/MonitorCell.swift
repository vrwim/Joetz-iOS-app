//
//  MonitorCell.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class MonitorCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gsmLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var monitor: Monitor! {
        didSet {
            nameLabel.text = monitor.name
            gsmLabel.text = monitor.gsm ?? "Privé"
            emailLabel.text = monitor.email
        }
    }
}
