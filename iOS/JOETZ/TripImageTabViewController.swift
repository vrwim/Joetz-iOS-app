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
    var images: [String : AnyObject] = [:]
    let loadingImagePlaceholder = "Loading image..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentTripTabVC: ParentTripTabVC = self.parentViewController as ParentTripTabVC
        trip = parentTripTabVC.trip
        if trip != nil {
            self.parentViewController?.navigationItem.title = trip.title
            for imagePath in trip.pictures! {
                connectionService.createFetchTask(imagePath, {
                    alert, data in
                    self.presentViewController(alert!, animated: true, completion: nil)
                    self.images[imagePath] = "Netwerkfout"
                    self.tableView.reloadData()
                    }) {
                        image in
                        self.images[imagePath] = image
                        self.tableView.reloadData()
                    }.resume()
            }
        }
        //Fix om table niet onder statusbar/navbar te laten beginnen
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        var inset: UIEdgeInsets
        if self.navigationController != nil {
            let navBarHeight = self.navigationController?.navigationBar.bounds.height
            inset = UIEdgeInsets(top: navBarHeight! + statusBarHeight, left: 0, bottom: 0, right: 0)
        } else {
            inset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        }
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = inset
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")){
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // Afbeeldingen
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trip?.pictures?.count ?? 0
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
            
            if let image = images[trip.pictures![indexPath.row]] as? UIImage {
                cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as ImageCell
                
                (cell as ImageCell).pictureView.image = image
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("imageLoadingCell") as UITableViewCell
                
                cell.textLabel!.text = images[trip.pictures![indexPath.row]] as? String ?? loadingImagePlaceholder
            }
            return cell
        default:
            println("Error: Asking for content of cell \(indexPath.row) in section \(indexPath.section)")
            return super.tableView(tableView,cellForRowAtIndexPath: indexPath)
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        self.parentViewController?.navigationItem.title = trip.title
        for imagePath in trip.pictures! {
            connectionService.createFetchTask(imagePath, {
                alert, data in
                self.presentViewController(alert!, animated: true, completion: nil)
                self.images[imagePath] = "Netwerkfout"
                self.tableView.reloadData()
                sender.endRefreshing()
                }) {
                    image in
                    self.images[imagePath] = image
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }.resume()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            
            if let image = images[trip.pictures![indexPath.row]] as? UIImage {
                var screenRect = UIScreen.mainScreen().bounds
                var screenWidth: CGFloat
                if (UIDevice.currentDevice().model as NSString).containsString("iPad") && UIApplication.sharedApplication().statusBarOrientation.isLandscape {
                    screenWidth = screenRect.size.width * 0.7
                } else {
                    screenWidth = screenRect.size.width
                }
                
                var imageHeight = image.size.height
                var imageWidth = image.size.width
                
                return imageHeight/(imageWidth/screenWidth)
            }
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}


