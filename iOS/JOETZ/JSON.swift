//
//  JSON.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import Foundation

class JSON {
    class func readTrips(data: NSData) -> [Trip] {
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        
        var trips: [Trip] = []
        
        for jsonTrip in jsonData {
            
            let id = jsonTrip["_id"] as String
            var basicPrice = jsonTrip["basicPrice"] as Float?
            let capacity = jsonTrip["capacity"] as Int?
            let destination = jsonTrip["destination"] as String?
            var beginDate = jsonTrip["startDate"] as String?
            var endDate = jsonTrip["endDate"] as String?
            let inclusives = jsonTrip["inclusives"] as [String]?
            let location = jsonTrip["location"] as String?
            let logos = jsonTrip["logos"] as [String]?
            let minAge = jsonTrip["minAge"] as Int?
            let maxAge = jsonTrip["maxAge"] as Int?
            let period = jsonTrip["period"] as String?
            let pictures = jsonTrip["pictures"] as [String]?
            let promo = jsonTrip["promo"] as String?
            let registration = jsonTrip["registration"] as [String]?
            let remarks = jsonTrip["remarks"] as String?
            let title = jsonTrip["title"] as String?
            let transport = jsonTrip["transport"] as String?
            let pricesDict = jsonTrip["prices"] as [NSDictionary]?
            
            basicPrice = basicPrice == nil ? nil : basicPrice!/100
            
            var prices: [(String, Float)] = []
            
            if pricesDict != nil {
                for price in pricesDict! {
                    prices.append(price["info"] as String, (price["price"] as Float)/100)
                }
            }
            
            beginDate = isoDateParser(beginDate!)
            endDate = isoDateParser(endDate!)
            
            trips.append(Trip(id: id, basicPrice: basicPrice, capacity: capacity, destination: destination, beginDate: beginDate, endDate: endDate, inclusives: inclusives, location: location, logos: logos, minAge: minAge, maxAge: maxAge, period: period, pictures: pictures, prices: prices, promo: promo, registration: registration, remarks: remarks, title: title, transport: transport))
        }
        trips.sort{
            trip1, trip2 in
            return trip1.title < trip2.title
        }
        return trips
    }
    
    class func isoDateParser(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        //original isoDate format to convert to NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let tmpDate = dateFormatter.dateFromString(date)!
        //New dateformat to more readable date
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //return date back as a string
        return dateFormatter.stringFromDate(tmpDate)
    }

}