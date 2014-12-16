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