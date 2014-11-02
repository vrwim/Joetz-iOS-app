//
//  Trip.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class Trip {
    
    let id: String
    let basicPrice: Float?
    let capacity: Int?
    let destination: String?
    let beginDate: String?
    let endDate: String?
    let inclusives: [String]?
    let location: String?
    let logos: [String]? // ??
    let minAge: Int?
    let maxAge: Int?
    let period: String?
    let pictures: [String]?
    let prices: [(String, Float)]? // info, price
    let promo: String?
    let registration: [String]?
    let remarks: String?
    let title: String?
    let transport: String?
    
    init(id: String, basicPrice: Float?, capacity: Int?, destination: String?, beginDate: String?, endDate: String?, inclusives: [String]?, location: String?, logos: [String]?, minAge: Int?, maxAge: Int?, period: String?, pictures: [String]?, prices: [(String, Float)]?, promo: String?, registration: [String]?, remarks: String?, title: String?, transport: String?) {
        println("new Trip created: " + (title ?? "no name"))
            self.id = id
            self.basicPrice = basicPrice
            self.capacity = capacity
            self.destination = destination
            self.beginDate = beginDate
            self.endDate = endDate
            self.inclusives = inclusives
            self.location = location
            self.logos = logos
            self.minAge = minAge
            self.maxAge = maxAge
            self.period = period
            self.pictures = pictures
            self.prices = prices
            self.promo = promo
            self.registration = registration
            self.remarks = remarks
            self.title = title
            self.transport = transport
    }
    
}