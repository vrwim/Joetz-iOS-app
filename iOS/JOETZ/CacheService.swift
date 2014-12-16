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
        while(task.state == NSURLSessionTaskState.Running){
            sleep(1)
        }
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
    
    private func normalizedNewsCache() -> [NewsItem]{
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
        while(task.state == NSURLSessionTaskState.Running){
            sleep(1)
        }
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
            /*var test = trip.prices! as NSArray
            var temp = NSMutableArray()
            for item in trip.prices!{
                temp.addObject(item[0] as NSString, item[1] as Float)
            }*/
            
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
            //trips.setValue(trip.prices! as NSArray, forKey: "prices")
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    private func normalizedTripsCache() -> [Trip]{
        var cache = getCache("Trip")
        var normalData = [Trip]()
        for item in cache{
            //normalData.append(NewsItem(id: item.valueForKeyPath("id") as String, title: item.valueForKeyPath("title") as String, date: item.valueForKeyPath("date") as String, thumbnail: item.valueForKeyPath("thumbnail") as String, content: item.valueForKeyPath("content") as String))
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