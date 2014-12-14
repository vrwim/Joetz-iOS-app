//
//  NewsItemViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class NewsItemViewController : UIViewController {
    
    var newsItem: NewsItem!
    var sidebar: UIPopoverController?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if newsItem != nil {
            sidebar?.dismissPopoverAnimated(true)
            navigationItem.title = newsItem.title
            webView.loadHTMLString(newsItem.content, baseURL: nil)
        }
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        if newsItem != nil {
            sidebar?.dismissPopoverAnimated(true)//this should be without animation but strangly only works with animation
        }
    }
}