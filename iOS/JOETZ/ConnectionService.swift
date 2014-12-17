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

    
    func createFetchTask(imagePath: String, onFail: ((UIAlertController?, NSData?) -> Void)?, completionHandler: UIImage -> Void) -> NSURLSessionTask {
        return request("GET", appendage: "images/\(imagePath)", values: nil, payload: nil, onFail: onFail) {
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
        
        return request("PUT", appendage: "api/users/\(id)/password", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: {
            data in
                println("Fail")
                
            
            }) {
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
    
    func changeAccountDetails(id: String, token: String, street: String?, streetNumber: Int?, bus: String?, postalCode: String?, city: String?,
        firstName: String?, lastName: String?,
        gsm: String?, phone: String?, birthday: NSDate?,
        smn: String?, ssn: String?, completionHandler: String -> Void) -> NSURLSessionTask{
        
            var payloadDict: [String:AnyObject?] = ["street": street, "streetNumber": streetNumber, "bus": bus, "postalCode": postalCode, "city": city, "firstname": firstName, "lastname": lastName, "gsm": gsm, "phone": phone, "birthday": birthday, "socialMutualityNumber": smn, "socialSecurityNumber": ssn]
            
            var payload = JSON.toJSON(payloadDict)
            
            return request("PUT", appendage: "api/users/\(id)", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: nil) {
                data in
                completionHandler(token)
            }
    }
    
    func enroll(isReservation: Bool, tripId: String, contactPerson: (bus: String?, city: String?, email: String, firstname: String?, lastname: String?, gsm: String, phone: String?, postalCode: String?, socialMutualityNumber: String?, codeGerechtige: String?, socialSecurityNumber: String?, street: String?, streetNumber: Int?), extraSocialMutualityNumber: String?, payingUser: (bus: String?, city: String?, email: String, firstname: String, lastname: String, gsm: String, phone: String?, postalCode: String?, socialSecurityNumber: String?, street: String?, streetNumber: Int?), childId: String, emergencyContacts: [(email: String, firstname: String, lastname: String, gsm: String, phone: String)], extraInfo: String?, token: String) -> NSURLSessionTask {
        
        // Turning tuples into dictionaries here to avoid having to send them over in a Dictionary containing "Any" objects; somewhat unstable, causes random segfaults.
        var contactPersonDict: NSMutableDictionary = [:]
        contactPersonDict["bus"] = contactPerson.bus
        contactPersonDict["city"] = contactPerson.city
        contactPersonDict["email"] = contactPerson.email
        contactPersonDict["firstname"] = contactPerson.firstname
        contactPersonDict["lastname"] = contactPerson.lastname
        contactPersonDict["gsm"] = contactPerson.gsm
        contactPersonDict["phone"] = contactPerson.phone
        contactPersonDict["postalCode"] = contactPerson.postalCode
        contactPersonDict["socialMutualityNumber"] = contactPerson.socialMutualityNumber
        contactPersonDict["codeGerechtige"] = contactPerson.codeGerechtige
        contactPersonDict["socialSecurityNumber"] = contactPerson.socialSecurityNumber
        contactPersonDict["street"] = contactPerson.street
        contactPersonDict["streetNumber"] = contactPerson.streetNumber
        
        var payingUserDict: NSMutableDictionary = [:]
        payingUserDict["bus"] = payingUser.bus
        payingUserDict["city"] = payingUser.city
        payingUserDict["email"] = payingUser.email
        payingUserDict["firstname"] = payingUser.firstname
        payingUserDict["lastname"] = payingUser.lastname
        payingUserDict["gsm"] = payingUser.gsm
        payingUserDict["phone"] = payingUser.phone
        payingUserDict["postalCode"] = payingUser.postalCode
        payingUserDict["socialSecurityNumber"] = payingUser.socialSecurityNumber
        payingUserDict["street"] = payingUser.street
        payingUserDict["streetNumber"] = payingUser.streetNumber
        
        var childDict: NSMutableDictionary = [:]
        childDict["id"] = childId
        
        var emergencyContactDicts: [NSMutableDictionary] = []
        for emergencyContact in emergencyContacts {
            var emergencyContactDict: NSMutableDictionary = [:]
            emergencyContactDict["email"] = emergencyContact.email
            emergencyContactDict["firstname"] = emergencyContact.firstname
            emergencyContactDict["lastname"] = emergencyContact.lastname
            emergencyContactDict["gsm"] = emergencyContact.gsm
            emergencyContactDict["phone"] = emergencyContact.phone
            emergencyContactDicts.append(emergencyContactDict)
        }
        
        var payloadDict: [String:AnyObject?] = ["isReservation": isReservation, "tripId": tripId, "contactPerson": contactPersonDict, "extraSocialMutualityNumber": extraSocialMutualityNumber, "payingUser": payingUserDict, "child": childDict, "emergencyContacts": emergencyContactDicts, "extraInfo": extraInfo]
        
        var payload = JSON.toJSON(payloadDict)
        
        println(payload)
        
        return request("POST", appendage: "api/registrations", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: nil) {
            data in
        }
    }
    
    func changeChildDetails(id: String, token: String, childId: String, firstname: String, lastname: String, birthday: NSDate, ssn: String, street: String?, streetNumber: Int?, bus: String?, postalCode: String?, city: String?, completionHandler: String -> Void) -> NSURLSessionTask {
        
        var childDict: NSMutableDictionary = [:]
        childDict["id"] = childId
        childDict["birthday"] = birthday
        childDict["bus"] = bus
        childDict["city"] = city
        childDict["firstname"] = firstname
        childDict["lastname"] = lastname
        childDict["postalCode"] = postalCode
        childDict["socialSecurityNumber"] = ssn
        childDict["street"] = street
        childDict["streetNumber"] = streetNumber
        
        var payloadDict: [String:AnyObject?] = ["children":childDict]
        var payload = JSON.toJSON(payloadDict)
        
        return request("PUT", appendage: "api/users/\(id)", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: nil) {
            data in
            //do something
        }
    }
    
    func addChildToParent(id: String, token: String, firstname: String, lastname: String, birthday: NSDate, ssn: String, street: String?, streetNumber: Int?, bus: String?, postalCode: String?, city: String?,
        existingChildren: [(childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)],
        completionHandler: String -> Void) -> NSURLSessionTask {
        
        var children: [(childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)] = existingChildren
        
        var childDictArray: [NSMutableDictionary] = [[:]]
        
        for child in children {
            var childDict: NSMutableDictionary = [:]
            childDict["childId"] = child.childId
            childDict["birthday"] = child.birthday
            childDict["bus"] = child.bus
            childDict["city"] = child.city
            childDict["firstname"] = child.firstname
            childDict["lastname"] = child.lastname
            childDict["postalCode"] = child.zipcode
            childDict["socialSecurityNumber"] = child.socialSecurityNumber
            childDict["street"] = child.street
            childDict["streetNumber"] = child.streetNumber
            childDictArray.append(childDict)
        }
        
        var childDictTmp: NSMutableDictionary = [:]
        childDictTmp["birthday"] = birthday
        childDictTmp["bus"] = bus
        childDictTmp["city"] = city
        childDictTmp["firstname"] = firstname
        childDictTmp["lastname"] = lastname
        childDictTmp["postalCode"] = postalCode
        childDictTmp["socialSecurityNumber"] = ssn
        childDictTmp["street"] = street
        childDictTmp["streetNumber"] = streetNumber
        
        childDictArray.append(childDictTmp)
        
        println(children)
        println("-------------")
        println(childDictArray)
        
        var payloadDict: [String:AnyObject?] = ["children":childDictArray]
        var payload = JSON.toJSON(payloadDict)
        println("bkfbskbdsq   3")
        
        return request("PUT", appendage: "api/users/\(id)", values: ["Authorization":"Bearer \(token)"], payload: payload, onFail: nil) {
            data in
            completionHandler(token)
        }
    }
    
    private func request(httpMethod: String, appendage: String, values: [String: String]?, payload: String?, onFail: ((UIAlertController, NSData?) -> Void)?, completionHandler: NSData! -> Void) -> NSURLSessionTask {
        
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
                onFail?(self.createAlert("Netwerkfout", message: "Er kan geen verbinding gemaakt worden met de server."), nil)
            } else {
                let response = response as NSHTTPURLResponse
                println("\tRequest succeeded: \(response.statusCode)")
                //check other numbers...
                if response.statusCode >= 200 && response.statusCode < 300 {
                    dispatch_async(dispatch_get_main_queue()) { // dispatch naar main thread (main_queue is thread# van main thread van app)
                        completionHandler(data)
                    }
                } else {
                    var alert: UIAlertController
                    switch response.statusCode {
                    case 401:
                        alert = self.createAlert("Niet geautoriseerd", message: "U bent niet toegelaten om deze pagina te bekijken")
                    case 404:
                        alert = self.createAlert("Niet gevonden", message: "De app kan de gevraagde pagina niet ophalen")
                    default:
                        alert = self.createAlert("Fout", message: "Er is iets misgelopen op de server.")
                    }
                    onFail?(alert, data)
                }
            }
        }
    }
    
    private func createAlert(title: String, message: String) -> UIAlertController{
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        return alert
    }
}

let connectionService = ConnectionService()