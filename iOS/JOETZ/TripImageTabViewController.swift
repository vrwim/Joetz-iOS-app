//
//  TripImageTabViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class TripImageTabViewController: MenuSetupUITableViewController
{
    
    var trip: Trip!
    var images: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentTripTabVC: ParentTripTabVC = self.parentViewController as ParentTripTabVC
        println(parentTripTabVC)
        trip = parentTripTabVC.trip
        self.parentViewController?.navigationItem.title = trip.title
        for imagePath in trip.pictures! {
            connectionService.createFetchTask(imagePath) {
                image in
                self.images[imagePath] = image
                self.tableView.reloadData()
                }.resume()
        }
        //Fix om table niet onder statusbar/navbar te laten beginnen
        let navBarHeight = self.navigationController?.navigationBar.bounds.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let inset: UIEdgeInsets = UIEdgeInsets(top: navBarHeight! + statusBarHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = inset
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // Afbeeldingen
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trip.pictures?.count ?? 0
        default:
            println("Error: Asking for #cells in section \(section)")
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "AFBEELDINGEN"
        default:
            println("Error: Asking for #cells in section \(section)")
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // images
            var cell: UITableViewCell
            
            if images[trip.pictures![indexPath.row]] == nil {
                cell = tableView.dequeueReusableCellWithIdentifier("imageLoadingCell") as UITableViewCell
                
                cell.textLabel.text = "Loading image..."
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as ImageCell
                
                (cell as ImageCell).pictureView.image = images[trip.pictures![indexPath.row]]
            }
            return cell
        default:
            println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            return super.tableView(tableView,cellForRowAtIndexPath: indexPath)
        }
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            var image = images[trip.pictures![indexPath.row]]
            
            if image != nil {
                var screenRect = UIScreen.mainScreen().bounds
                var screenWidth = screenRect.size.width
                
                var imageHeight = image!.size.height
                var imageWidth = image!.size.width
                
                return imageHeight/(imageWidth/screenWidth)
            }
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}


