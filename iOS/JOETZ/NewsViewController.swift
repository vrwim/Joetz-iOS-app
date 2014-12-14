//
//  LoginViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/29/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class NewsViewController: MenuSetupUITableViewController {
    
    var news: [NewsItem] = []
    var task: NSURLSessionTask?
    var sidebar: UIPopoverController?
    var newsItemController: NewsItemViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        task = connectionService.createNewsFetchTask {
            newsItems in
            self.news = newsItems
            self.tableView.reloadData()
        }
        task!.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        newsItemController = (segue.destinationViewController as UINavigationController).topViewController as? NewsItemViewController
        let newsItem = news[tableView.indexPathForSelectedRow()!.row]
        newsItemController?.newsItem = newsItem
        newsItemController?.sidebar = sidebar
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        newsItemController?.sidebar = sidebar
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as NewsCell
        
        let newsItems = news[indexPath.row]
        cell.setContent(newsItems)
        
        return cell
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        let task = connectionService.createNewsFetchTask {
            newsItems in
            self.news = newsItems
            self.tableView.reloadData()
            sender.endRefreshing()
        }
        task.resume()
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}