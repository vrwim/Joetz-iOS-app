//
//  ContentsViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {
    
    var kampen: [Kamp] = []
    @IBOutlet weak var contentTextView: UITextView! // TODO: weg
    
    override func viewDidLoad() {
        println("ContentsViewController did load")
        let task = connectionService.createFetchTask {
            kampen in
            self.kampen = kampen
            self.contentTextView.text = kampen[0].title
        }
        task.resume()
    }
}

