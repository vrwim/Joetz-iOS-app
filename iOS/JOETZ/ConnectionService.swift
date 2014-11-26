//
//  ConnectionService.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import Foundation

class ConnectionService {
    
    let baseUrl = NSURL(string: "http://188.226.141.100:9000")!
    let session: NSURLSession
    
    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(#completionHandler: [Trip] -> Void) -> NSURLSessionTask {
        //check if internetconnection
        let url = baseUrl.URLByAppendingPathComponent("api/trips")
        let request = NSMutableURLRequest(URL: url)
        
        println("Executing image request: \(url)")
        
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("\tGET request failed: \(error!)")
            } else {
                let response = response as NSHTTPURLResponse
                println("\tGET request succeeded: \(response.statusCode)")
                //check other numbers...
                if response.statusCode == 200 {
                    let trips = JSON.readTrips(data)
                    dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                        completionHandler(trips)
                    }
                }
            }
        }
    }
    
    func createFetchTask(imagePath: String, completionHandler: UIImage -> Void) -> NSURLSessionTask {
        
        let url = baseUrl.URLByAppendingPathComponent("images/\(imagePath)")
        let request = NSMutableURLRequest(URL: url)
        
        println("Executing image request: \(url)")
        
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("\tGET request failed: \(error!)")
            } else {
                let response = response as NSHTTPURLResponse
                println("\tGET request succeeded: \(response.statusCode)")
                if response.statusCode == 200 {
                    let image = UIImage(data: data)
                    if image != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(image!)
                        }
                    }
                }
            }
        }
    }
    
    func authenticate(email: String, password: String, completionHandler: String -> Void) -> NSURLSessionTask {
        
        let url = baseUrl.URLByAppendingPathComponent("auth/local")
        let request = NSMutableURLRequest(URL: url)
        let payload = "{\"email\":\"\(email)\",\"password\":\"\(password)\"}"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(countElements(payload))", forHTTPHeaderField: "Content-Length")
        
        println("Executing POST request: \(url)")
        
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("\tPOST request failed: \(error!)")
            } else {
                let response = response as NSHTTPURLResponse
                // Check other numbers...
                println("\tPOST request succeeded: \(response.statusCode)")
                if response.statusCode == 200 {
                    let token = JSON.parseToken(data)
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(token)
                    }
                }
            }
        }
    }

    func createNewsFetchTask(#completionHandler: [NewsItem] -> Void) -> NSURLSessionTask {
        //check if internetconnection
        let request = NSMutableURLRequest(URL: baseUrl.URLByAppendingPathComponent("api/news"))
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println(error)
            } else {
                let response = response as NSHTTPURLResponse
                //check other numbers...
                if response.statusCode == 200 {
                    let news = JSON.readNews(data)
                    dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                        completionHandler(news)
                    }
                }
            }
        }
    }
    
    func getUserData(token: String, completionHandler: User -> Void) -> NSURLSessionTask {
        
        let url = baseUrl.URLByAppendingPathComponent("api/users/me")
        let request = NSMutableURLRequest(URL: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        println("Executing GET request: \(url)")
        
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("\tGET request failed: \(error!)")
            } else {
                println("\tGET request succeeded!")
                let response = response as NSHTTPURLResponse
                if response.statusCode == 200 {
                    let token = JSON.parseUser(data, token: token)
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(token)
                    }
                }
            }
        }
    }
}

let connectionService = ConnectionService()