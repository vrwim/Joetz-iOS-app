//
//  ConnectionService.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/1/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import Foundation

class ConnectionService {
    
    let baseUrl = NSURL(string: "http://188.226.141.100:9000/api/trips")!
    let session: NSURLSession
    
    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(#completionHandler: [Trip] -> Void) -> NSURLSessionTask {
        //check if internetconnection
        let request = NSMutableURLRequest(URL: baseUrl)
        return session.dataTaskWithRequest(request) {
            data, response, error in
            let response = response as NSHTTPURLResponse
            //check other numbers...
            if response.statusCode == 200 {
                let trips = JSON.readTrips(data)
                dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                    completionHandler(trips)
                }
            }
        }
    }
    /* Retrieve single kamp
    func createFetchTask(kamp: String, completionHandler: Kamp -> Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL: baseUrl.URLByAppendingPathComponent("example.json"))
        return session.dataTaskWithRequest(request) {
            data, response, error in
            let response = response as NSHTTPURLResponse
            if response.statusCode == 200 {
                let kamp = JSON.readKamp(kamp, data: data)
                dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                    completionHandler(kamp!)
                }
            }
        }
    }
    */
    
}

let connectionService = ConnectionService()