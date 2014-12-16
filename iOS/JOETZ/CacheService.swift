//
//  CacheService.swift
//  JOETZ
//
//  Created by Mathan Hermans on 16/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

let cacheService = CacheService()

class CacheService {
    let managedContext: NSManagedObjectContext!
    
    init(){
        managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    }
    
    func updateNews() -> [NewsItem] {
        var news:[NewsItem]?
        let task = connectionService.createNewsFetchTask {
            newsItems in
            if newsItems.count > 0{
                self.clearCache("NewsItem")
                self.cacheNews(newsItems)
                news = newsItems
            }
        }
        task.resume()
        var counter = 0
        while(task.state == NSURLSessionTaskState.Running && counter < 20){
            sleep(1)
            counter += 1
        }
        task.cancel()
        if news != nil {
            return news!
        } else {
            return normalizedNewsCache()
        }
    }
    
    private func cacheNews(news: [NewsItem]){
        for newsItem in news{
            let entity =  NSEntityDescription.entityForName("NewsItem",
                inManagedObjectContext:
                managedContext)
            
            let news = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            news.setValue(newsItem.id, forKey: "id")
            news.setValue(newsItem.title, forKey: "title")
            news.setValue(newsItem.date, forKey: "date")
            news.setValue(newsItem.thumbnail, forKey: "thumbnail")
            news.setValue(newsItem.content, forKey: "content")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    func normalizedNewsCache() -> [NewsItem]{
        var cache = getCache("NewsItem")
        var normalData = [NewsItem]()
        for item in cache{
            normalData.append(NewsItem(id: item.valueForKeyPath("id") as String, title: item.valueForKeyPath("title") as String, date: item.valueForKeyPath("date") as String, thumbnail: item.valueForKeyPath("thumbnail") as String, content: item.valueForKeyPath("content") as String))
        }
        return normalData
    }
    
    func updateTrips() -> [Trip] {
        var tripsList:[Trip]?
        let task = connectionService.createFetchTask {
            trips in
            if trips.count > 0{
                self.clearCache("Trip")
                self.cacheTrips(trips)
                tripsList = trips
            }
        }
        task.resume()
        var counter = 0
        while(task.state == NSURLSessionTaskState.Running && counter < 20){
            sleep(1)
            counter += 1
        }
        task.cancel()
        if tripsList != nil {
            return tripsList!
        } else {
            return normalizedTripsCache()
        }
    }
    
    private func cacheTrips(trips: [Trip]){
        for trip in trips{
            let entity =  NSEntityDescription.entityForName("Trip",
                inManagedObjectContext:
                managedContext)
            
            let trips = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            trips.setValue(trip.id, forKey: "id")
            trips.setValue(trip.title, forKey: "title")
            trips.setValue(trip.basicPrice, forKey: "basicPrice")
            trips.setValue(trip.capacity, forKey: "capacity")
            trips.setValue(trip.destination, forKey: "destination")
            trips.setValue(trip.beginDate, forKey: "beginDate")
            trips.setValue(trip.endDate, forKey: "endDate")
            trips.setValue(trip.location, forKey: "location")
            trips.setValue(trip.minAge, forKey: "minAge")
            trips.setValue(trip.maxAge, forKey: "maxAge")
            trips.setValue(trip.period, forKey: "period")
            trips.setValue(trip.promo, forKey: "promo")
            trips.setValue(trip.remarks, forKey: "remarks")
            trips.setValue(trip.transport, forKey: "transport")
            trips.setValue(trip.inclusives! as [NSString] as NSArray, forKey: "inclusives")
            trips.setValue(trip.logos! as [NSString] as NSArray, forKey: "logos")
            trips.setValue(trip.pictures! as [NSString] as NSArray, forKey: "pictures")
            trips.setValue(trip.registration! as [NSString] as NSArray, forKey: "registration")
            var priceNames = NSMutableArray()
            var priceValues = NSMutableArray()
            for item in trip.prices! {
                priceNames.addObject(item.0)
                priceValues.addObject(item.1)
            }
            trips.setValue(priceNames, forKey: "priceNames")
            trips.setValue(priceValues, forKey: "priceValues")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    func normalizedTripsCache() -> [Trip]{
        var cache = getCache("Trip")
        var normalData = [Trip]()
        for item in cache{
            var priceNames: [String] = item.valueForKey("priceNames") as [String]
            var priceValues: [Float] = item.valueForKey("priceValues") as [Float]
            var prices = [(String, Float)]()
            for var i = 0; i < priceNames.count; i += 1 {
                prices.append((priceNames[i] as String, priceValues[i] as Float))
            }
            var trip = Trip(id: item.valueForKey("id") as String,
                basicPrice: item.valueForKey("basicPrice") as? Float,
                capacity: item.valueForKey("capacity") as? Int,
                destination: item.valueForKey("destination") as? String,
                beginDate: item.valueForKey("beginDate") as? String,
                endDate: item.valueForKey("endDate") as? String,
                inclusives: item.valueForKey("inclusives") as? [String],
                location: item.valueForKey("location") as? String,
                logos: item.valueForKey("logos") as? [String],
                minAge: item.valueForKey("minAge") as? Int,
                maxAge: item.valueForKey("maxAge") as? Int,
                period: item.valueForKey("period") as? String,
                pictures: item.valueForKey("pictures") as? [String],
                prices: prices,
                promo: item.valueForKey("promo") as? String,
                registration: item.valueForKey("registration") as? [String],
                remarks: item.valueForKey("remarks") as? String,
                title: item.valueForKey("title") as? String,
                transport: item.valueForKey("transport") as? String
            )
            normalData.append(trip)
        }
        return normalData
    }
    
    private func clearCache(type: String){
        var results = getCache(type)
        var error: NSError?
        for item in results{
            managedContext.deleteObject(item)
        }
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    private func getCache(type: String) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest(entityName:type)
        var error: NSError?
        var fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if let results = fetchedResults {
            return results
        } else {
            println("could not fetch \(error), \(error!.userInfo)")
        }
        return [NSManagedObject]()
    }
}