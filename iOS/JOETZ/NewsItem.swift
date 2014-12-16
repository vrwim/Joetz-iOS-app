//
//  Trip.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class NewsItem{
    
    let id: String
    let title: String
    let date: String
    let thumbnail: String
    let content: String
    
    init(id: String, title: String, date: String, thumbnail: String, content: String){
        self.id = id
        self.title = title
        self.date = date
        self.thumbnail = thumbnail
        self.content = content
    }
}