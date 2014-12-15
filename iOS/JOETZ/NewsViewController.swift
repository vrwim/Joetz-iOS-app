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
            let stringMatch = newsItem.title.rangeOfString(searchText)
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