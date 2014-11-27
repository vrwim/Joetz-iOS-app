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
        return request(false, appendage: "api/trips", values: nil, payload: nil) {
            data in
            let trips = JSON.readTrips(data)
            completionHandler(trips)
        }
    }
    
    func createFetchTask(imagePath: String, completionHandler: UIImage -> Void) -> NSURLSessionTask {
        return request(false, appendage: "images/\(imagePath)", values: nil, payload: nil) {
            data in
            let image = UIImage(data: data)
            completionHandler(image!)
        }
    }
    
    func authenticate(email: String, password: String, completionHandler: String -> Void) -> NSURLSessionTask {
        let payload = "{\"email\":\"\(email)\",\"password\":\"\(password)\"}"
        return request(true, appendage: "auth/local", values: ["Content-Type":"application/json", "Content-Length":"\(countElements(payload))"], payload: payload) {
            data in
            let token = JSON.parseToken(data)
            completionHandler(token)
        }
    }
    
    func createNewsFetchTask(completionHandler: [NewsItem] -> Void) -> NSURLSessionTask {
        return request(false, appendage: "api/news", values: nil, payload: nil) {
            data in
            let news = JSON.readNews(data)
            completionHandler(news)
        }
    }
    
    func getUserData(token: String, completionHandler: User -> Void) -> NSURLSessionTask {
        return request(false, appendage: "api/users/me", values: ["Authorization":"Bearer \(token)"], payload: nil) {
            data in
            let user = JSON.parseUser(data, token: token)
            completionHandler(user)
        }
    }
    
    private func request(post: Bool, appendage: String, values: [String: String]?, payload: String?, completionHandler: NSData! -> Void) -> NSURLSessionTask {
        
        // TODO check if internetconnection
        let url = baseUrl.URLByAppendingPathComponent(appendage)
        let request = NSMutableURLRequest(URL: url)
        
        if post {
            request.HTTPMethod = "POST"
        }
        
        if payload != nil {
            request.HTTPBody = payload!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        if values != nil {
            for value in values! {
                request.setValue(value.1, forHTTPHeaderField: value.0)
            }
        }
        
        println("Executing request: \(url)")
        
        return session.dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                println("\tRequest failed: \(error!)")
            } else {
                let response = response as NSHTTPURLResponse
                println("\tRequest succeeded: \(response.statusCode)")
                //check other numbers...
                if response.statusCode == 200 {
                    dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                        completionHandler(data)
                    }
                }
            }
        }
    }
}

let connectionService = ConnectionService()