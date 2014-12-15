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
        return request("GET", appendage: "api/trips", values: nil, payload: nil, onFail: nil) {
            data in
            let trips = JSON.readTrips(data)
            completionHandler(trips)
        }
    }
    
    func createFetchTask(imagePath: String, completionHandler: UIImage -> Void) -> NSURLSessionTask {
        return request("GET", appendage: "images/\(imagePath)", values: nil, payload: nil, onFail: nil) {
            data in
            let image = UIImage(data: data)
            completionHandler(image!)
        }
    }
    
    func authenticate(email: String, password: String, completionHandler: String -> Void) -> NSURLSessionTask {
        let payload = "{\"email\":\"\(email)\",\"password\":\"\(password)\"}"
        return request("POST", appendage: "auth/local", values: nil, payload: payload, onFail: nil) {
            data in
            let token = JSON.parseToken(data)
            completionHandler(token)
        }
    }
    
    func authenticate(token: String, completionHandler: String -> Void) -> NSURLSessionTask {
        let payload = "{\"FBtoken\":\"\(token)\"}"
        return request("POST", appendage: "auth/local", values: nil, payload: payload, onFail: nil) {
            data in
            let token = JSON.parseToken(data)
            completionHandler(token)
        }
    }
    
    func createNewsFetchTask(completionHandler: [NewsItem] -> Void) -> NSURLSessionTask {
        return request("GET", appendage: "api/news", values: nil, payload: nil, onFail: nil) {
            data in
            let news = JSON.readNews(data)
            completionHandler(news)
        }
    }
    
    func getUserData(token: String, completionHandler: User -> Void) -> NSURLSessionTask {
        return request("GET", appendage: "api/users/me", values: ["Authorization":"Bearer \(token)"], payload: nil, onFail: nil) {
            data in
            let user = JSON.parseUser(data, token: token)
            completionHandler(user)
        }
    }
    
    func register(street: String?, streetNumber: Int?, bus: String?, postalCode: String?, city: String?,
        firstName: String?, lastName: String?,
        gsm: String?, phone: String?, birthday: NSDate?,
        smn: String?, ssn: String?,
        email: String, password: String, role: String?, completionHandler: String -> Void) -> NSURLSessionTask {
            
            var payloadDict: [String:AnyObject?] = ["street": street, "streetNumber": streetNumber, "bus": bus, "postalCode": postalCode, "city": city, "firstname": firstName, "lastname": lastName, "gsm": gsm, "phone": phone, "birthday": birthday, "socialMutualityNumber": smn, "socialSecurityNumber": ssn, "email": email, "password": password, "role": role]
            
            var payload = JSON.toJSON(payloadDict)
            
            return request("POST", appendage: "api/users", values: nil, payload: payload, onFail: nil) {
                data in
                self.authenticate(email, password: password, completionHandler: completionHandler).resume()
            }
    }
    
    func changePassword(id: String, email: String, oldPassword: String, newPassword: String, token: String) -> NSURLSessionTask {
        
        var payloadDict: [String:AnyObject?] = ["email": email, "oldPassword": oldPassword, "newPassword": newPassword]
        
        var payload = JSON.toJSON(payloadDict)
        
        return request("PUT", appendage: "api/users/\(id)/password", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: nil) {
                data in
            }
    }
    
    func getMonitors(token: String, completionHandler: [Monitor] -> Void) -> NSURLSessionTask {
        return request("GET", appendage: "api/users/monitors", values: ["Authorization": "Bearer \(token)"], payload: nil, onFail: nil) {
            data in
            let monitors = JSON.parseMonitors(data)
            completionHandler(monitors)
        }
    }
    
    private func request(httpMethod: String, appendage: String, values: [String: String]?, payload: String?, onFail: (NSData! -> Void)?, completionHandler: NSData! -> Void) -> NSURLSessionTask {
        
        // TODO check if internetconnection
        let url = baseUrl.URLByAppendingPathComponent(appendage)
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = httpMethod
        
        if let payload = payload {
            request.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            request.setValue("\(countElements(payload))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                } else {
                    onFail?(data)
                }
            }
        }
    }
}

let connectionService = ConnectionService()