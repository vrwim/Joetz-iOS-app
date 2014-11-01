//
//  JSON.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import Foundation

class JSON {
    class func readKampen(data: NSData) -> [Kamp] {
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        let jsonKampen = jsonData["kampen"] as NSArray
        
        var kampen: [Kamp] = []
        
        for jsonKamp in jsonKampen {
            
            let id = jsonKamp["_id"] as String
            let basicPrice = (jsonKamp["basicPrice"] as Float)/100
            let capacity = jsonKamp["capacity"] as Int
            let destination = jsonKamp["destination"] as String
            let beginDate = jsonKamp["startDate"] as String
            let endDate = jsonKamp["endDate"] as String
            let inclusives = jsonKamp["inclusives"] as [String]
            let location = jsonKamp["location"] as String
            let logos = jsonKamp["logos"] as [String]
            let minAge = jsonKamp["minAge"] as Int
            let maxAge = jsonKamp["maxAge"] as Int
            let period = jsonKamp["period"] as String
            let pictures = jsonKamp["pictures"] as [String]
            let promo = jsonKamp["promo"] as String
            let registration = jsonKamp["registration"] as [String]
            let remarks = jsonKamp["remarks"] as String
            let title = jsonKamp["title"] as String
            let transport = jsonKamp["transport"] as String
            let pricesDict = jsonKamp["prices"] as [NSDictionary]
            
            var prices: [(String, String, Float)] = []
            
            for price in pricesDict {
                prices.append(price["_id"] as String, price["info"] as String, (price["price"] as Float)/100)
            }
            
            kampen.append(Kamp(id: id, basicPrice: basicPrice, capacity: capacity, destination: destination, beginDate: beginDate, endDate: endDate, inclusives: inclusives, location: location, logos: logos, minAge: minAge, maxAge: maxAge, period: period, pictures: pictures, prices: prices, promo: promo, registration: registration, remarks: remarks, title: title, transport: transport))
        }
        kampen.sort{
            kamp1, kamp2 in
            return kamp1.title < kamp2.title
        }
        return kampen
    }
}