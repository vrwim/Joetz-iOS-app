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
            let date1 = self.stringToDate(trip1.beginDate!)
            let date2 = self.stringToDate(trip2.beginDate!)
            //return trip1.beginDate < trip2.beginDate
            return date1.compare(date2) == NSComparisonResult.OrderedAscending
        }
        return trips
    }
    
    class func readNews(data: NSData) -> [NewsItem] {
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        
        var news: [NewsItem] = []
        
        for jsonNewsItem in jsonData {
            
            let id = jsonNewsItem["_id"] as String
            let title = jsonNewsItem["title"] as String
            var date = jsonNewsItem["date"] as String
            let thumbnail = jsonNewsItem["thumbnail"] as String
            let content = jsonNewsItem["content"] as String
            
            var tmpDate: NSDate = NSDate()
            
            date = isoDateParser(date)
            
            news.append(NewsItem(id: id, title: title, date: date, thumbnail: thumbnail, content: content))
        }
        news.sort{
            newsItem1, newsItem2 in
            let date1 = self.stringToDate(newsItem1.date)
            let date2 = self.stringToDate(newsItem2.date)
            return date1.compare(date2) == NSComparisonResult.OrderedAscending
        }
        return news
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
    
    class func stringToDate(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let tmpDate = dateFormatter.dateFromString(date)!
        
        return tmpDate
    }
    
    class func parseToken(data: NSData) -> String{
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        
        return jsonData["token"] as String
    }
    
    class func parseUser(data: NSData, token: String) -> User{
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        
        let id = jsonData["_id"] as String
        let provider = jsonData["provider"] as String
        let name = jsonData["name"] as String
        let email = jsonData["email"] as String
        let role = jsonData["role"] as String
        
        return User(id: id, provider: provider, name: name, email: email, role: role, token: token)
    }
    
    class func toJSON(dict: [String: AnyObject]) -> String { // currently only Int, NSDate and String supported
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let lastKey = dict.keys.last!
        let lastValue: AnyObject = dict.values.last!
        
        var json = "{"
        
        for kvPair in dict {
            
            json += "\t\"\(kvPair.0)\": "
            
            if let val = kvPair.1 as? String {
                json += "\"\(val)\""
            } else if let val = kvPair.1 as? NSDate {
                json += "\"\(dateFormatter.stringFromDate(val))\""
            } else if let val = kvPair.1 as? Int {
                json += "\(val)"
            } else {
                println("Unknown type in parsing JSON: \(kvPair.1), skipping")
            }
            
            if kvPair.0 != lastKey {
                json+=",\n"
            }
        }
        
        json += "}"
        
        return json
    }
}