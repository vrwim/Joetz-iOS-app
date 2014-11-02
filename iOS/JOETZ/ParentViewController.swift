//
//  ContentsViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    var trips: [Trip] = []
    @IBOutlet weak var contentTextView: UITextView! // TODO: weg
    
    override func viewDidLoad() {
        println("ContentsViewController did load")
        let task = connectionService.createFetchTask {
            trips in
            self.trips = trips
            // Dummy code to check link & JSON
            var text = ""
            for trip in trips {
                text = text + trip.title! + "\n"
            }
            self.contentTextView.text = text
        }
        task.resume()
    }
}

