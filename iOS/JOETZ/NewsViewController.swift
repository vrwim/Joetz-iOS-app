//
//  LoginViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/29/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class NewsViewController: MenuSetupUITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var news = [NewsItem]()
    var filteredNews = [NewsItem]()
    var sidebar: UIPopoverController?
    var newsItemController: NewsItemViewController?
    
    override func viewDidLoad() {
        news = cacheService.normalizedNewsCache()
        tableView.reloadData()
        let queue = NSOperationQueue()
        queue.addOperationWithBlock(){
            self.news = cacheService.updateNews()
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                println(self.news)
                self.tableView.reloadData()
            }
        }
        tableView.setContentOffset(CGPointMake(0,44), animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        newsItemController = (segue.destinationViewController as UINavigationController).topViewController as? NewsItemViewController
        var newsItem: NewsItem
        if (sender as UITableViewCell).isDescendantOfView(self.searchDisplayController!.searchResultsTableView) {
            newsItem = filteredNews[self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!.row]
        } else {
            newsItem = news[self.tableView.indexPathForSelectedRow()!.row]
        }
        newsItemController?.newsItem = newsItem
        newsItemController?.sidebar = sidebar
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        newsItemController?.sidebar = sidebar
    }
    
    func filterContentForSearchText(searchText: String){
        self.filteredNews = self.news.filter({(newsItem: NewsItem) -> Bool in
            let stringMatch = newsItem.title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredNews.count
        } else {
            return news.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("newsCell") as NewsCell
        
        var newsItem: NewsItem
        if tableView == self.searchDisplayController!.searchResultsTableView {
            newsItem = filteredNews[indexPath.row]
        } else {
            newsItem = news[indexPath.row]
        }
        cell.setContent(newsItem)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 89
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        let queue = NSOperationQueue()
        queue.addOperationWithBlock(){
            self.news = cacheService.updateNews()
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                self.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
}