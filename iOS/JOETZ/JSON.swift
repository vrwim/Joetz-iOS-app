//
//  JSON.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

/**
 * Performs everything involving JSON files. Usually called by ConnectionService.
 */
class JSON {
    
    /**
     * Returns all trips in the JSON data.
     * Parameters: 
     * data: the data containing the JSON.
     */
    class func readTrips(data: NSData) -> [Trip] {
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        
        var trips: [Trip] = []
        
        for jsonTrip in jsonData {
            
            let id = jsonTrip["_id"] as String
            let basicPrice = (jsonTrip["basicPrice"] as String?)?.floatValue
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
            
            var prices: [(String, Float)] = []
            
            if pricesDict != nil {
                for price in pricesDict! {
                    prices.append(price["info"] as String, (price["price"]! as String).floatValue)
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
    
    /**
     * Returns all newsitems in the JSON data.
     * Parameters:
     * data: the data containing the JSON.
     */
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
    
    /**
     * Helping method: Parses an ISO date to a user-readable format
     */
    private class func isoDateParser(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        //original isoDate format to convert to NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let tmpDate = dateFormatter.dateFromString(date)!
        //New dateformat to more readable date
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //return date back as a string
        return dateFormatter.stringFromDate(tmpDate)
    }
    
    /**
     * Helping method: Returns an NSDate from this ISO date
     */
    private class func stringToDate(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let tmpDate = dateFormatter.dateFromString(date)!
        
        return tmpDate
    }
    
    /**
     * Parses a token from this JSON data
     */
    class func parseToken(data: NSData) -> String{
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        
        return jsonData["token"] as String
    }
    
    /**
     * Returns a user from this JSON data
     * Parameters:
     * data: The JSON data containing the server response.
     * token: The token used to authenticate further requests.
     */
    class func parseUser(data: NSData, token: String) -> User{
        
        let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        
        debugPrint(jsonData)
        
        let id = jsonData["_id"] as String
        let provider = jsonData["provider"] as String
        let name = (jsonData["firstname"] as String? ?? "")  + " " + (jsonData["lastname"] as String? ?? "")
        let email = jsonData["email"] as String
        let role = jsonData["role"] as String
        var birthday = jsonData["birthday"] as String?
        let bus = jsonData["bus"] as String?
        let city = jsonData["city"] as String?
        let firstname = jsonData["firstname"] as String?
        let lastname = jsonData["lastname"] as String?
        let gsm = jsonData["gsm"] as String?
        let phone = jsonData["phone"] as String?
        let postalCode = jsonData["postalCode"] as String?
        let socialMutualityNumber = jsonData["socialMutualityNumber"] as String?
        let socialSecurityNumber = jsonData["socialSecurityNumber"] as String?
        let street = jsonData["street"] as String?
        let streetNumber = jsonData["streetNumber"] as Int?
        
        var children: [(isMemberOfSocialMutuality: Bool, firstname: String, lastname: String, socialSecurityNumber: String, birthday: NSDate, street: String, streetNumber: String, zipcode: String, bus: String, city: String)] = []
        var tripsHistory: [(childId: String, tripId: String)] = []
        var reservations: [( childId: String, tripId: String, registrationId: String)] = []
        
        let jsonChildren = jsonData["children"] as NSArray?
        if let jsonChildren = jsonChildren {
            for jsonChild in jsonChildren {
                children.append(isMemberOfSocialMutuality: jsonData["isMemberOfSocialMutuality"] as Bool, firstname: jsonData["firstname"] as String, lastname: jsonData["lastname"] as String, socialSecurityNumber: jsonData["socialSecurityNumber"] as String, birthday: jsonData["birthday"] as NSDate, street: jsonData["street"] as String, streetNumber: jsonData["streetNumber"] as String, zipcode: jsonData["zipcode"] as String, bus: jsonData["bus"] as String, city: jsonData["city"] as String)
            }
        }
        
        let jsonTrips = jsonData["tripsHistory"] as NSArray?
        if let jsonTrips = jsonTrips {
            for jsonTrip in jsonTrips {
                tripsHistory.append(childId: jsonData["childId"] as String, tripId: jsonData["tripId"] as String)
            }
        }
        
        let jsonReservations = jsonData["reservations"] as NSArray?
        if let jsonReservations = jsonReservations {
            for jsonReservation in jsonReservations {
                reservations.append(childId: jsonData["childId"] as String, tripId: jsonData["tripId"] as String, registrationId: jsonData["registrationId"] as String)
            }
        }
        
        if let birthdayTmp = birthday {
            birthday = isoDateParser(birthday!)
        }
        
        return User(id: id, provider: provider, name: name, email: email, role: role, token: token, children: children, tripsHistory: tripsHistory, reservations: reservations, birthday: birthday, bus: bus, city: city, firstname: firstname, lastname: lastname, gsm: gsm, phone: phone, postalCode: postalCode, socialMutualityNumber: socialMutualityNumber, socialSecurityNumber: socialSecurityNumber, street: street, streetNumber: streetNumber)
    }
    
    /**
     * Returns a JSON String containing all data in this dictionary.
     * Skips entries with nil as value
     * Can only parse Int, String and NSDate, skips others.
     * Parameters:
     * dict: the dictionary containing all the data
     */
    class func toJSON(dict: [String: AnyObject?]) -> String {
        
        var elements: [String] = []
        
        for kvPair in dict {
            if let value: AnyObject = kvPair.1 {
                elements.append("\"" + kvPair.0 + "\":" + format(value))
            }
        }
        
        return "{" + ", ".join(elements) + "}"
    }
    
    /**
     * Helping method that formats AnyObjects to Strings, to be used in a JSON String.
     * Skips entries with nil as value
     * Can only parse Int, String and NSDate, skips others.
     * Parameters:
     * input: AnyObject (only Int, String and NSDate supported) to be converted into String
     */
    private class func format(input: AnyObject) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let val = input as? String {
            return "\"\(val)\""
        } else if let val = input as? NSDate {
            return "\"\(dateFormatter.stringFromDate(val))\""
        } else if let val = input as? Int {
            return "\(val)"
        } else {
            println("Nil or unknown type in parsing JSON: \(input.debugDescription), skipping")
            return "\"\""
        }
    }
    
    class func parseMonitors(data: NSData) -> [Monitor] {
        let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        
        var monitors: [Monitor] = []
        
        for jsonMonitor in jsonDict {
            if let jsonMonitor = jsonMonitor as? NSDictionary {
                let name = (jsonMonitor["firstname"] as String) + " " + (jsonMonitor["lastname"] as String)
                let gsm = jsonMonitor["gsm"] as String?
                let email = jsonMonitor["email"] as String
                
                monitors.append(Monitor(name: name, gsm: gsm, email: email))
            }
        }
        
        return monitors
    }
}

/**
 * String extension so that the NSString .floatValue van be used on Swift Strings.
 */
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}