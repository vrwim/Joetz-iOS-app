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
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = newsItem.title
        webView.loadHTMLString(newsItem.content, baseURL: nil)
    }
}