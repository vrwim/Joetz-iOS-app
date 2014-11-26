//
//  NewsCell.swift
//  JOETZ
//
//  Created by Mathan Hermans on 25/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    var newsItem: NewsItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    func setContent(newsItem: NewsItem) {
        self.newsItem = newsItem
        titleLabel.text = newsItem.title
        dateLabel.text = newsItem.date
        
        connectionService.createFetchTask(newsItem.thumbnail) {
            image in
            self.thumbnail.image = image
            }.resume()
    }
}