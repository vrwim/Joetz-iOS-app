//
//  User.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/25/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class User {
    
    let id: String
    let provider: String?
    let name: String?
    let email: String
    let role: String?
    let token: String?
    let children: [(childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)]
    let tripsHistory: [(childId: String, tripId: String)]
    let reservations: [( childId: String, tripId: String, registrationId: String)]
    let birthday: String?
    let bus: String?
    let city: String?
    let firstname: String?
    let lastname: String?
    let gsm: String?
    let phone: String?
    let postalCode: String?
    let socialMutualityNumber: String?
    let socialSecurityNumber: String?
    let street: String?
    let streetNumber: Int?
    
    
    init(id: String, provider: String?, name: String?, email: String, role: String?, token: String?, children: [(childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)], tripsHistory: [(childId: String, tripId: String)], reservations: [( childId: String, tripId: String, registrationId: String)], birthday: String?, bus: String?, city: String?, firstname: String?, lastname: String?, gsm: String?, phone: String?, postalCode: String?, socialMutualityNumber: String?, socialSecurityNumber: String?, street: String?, streetNumber: Int?) {
        self.id = id
        self.provider = provider
        self.name = name
        self.email = email
        self.role = role
        self.token = token
        self.children = children
        self.tripsHistory = tripsHistory
        self.reservations = reservations
        self.birthday = birthday
        self.bus = bus
        self.city = city
        self.firstname = firstname
        self.lastname = lastname
        self.gsm = gsm
        self.phone = phone
        self.postalCode = postalCode
        self.socialMutualityNumber = socialMutualityNumber
        self.socialSecurityNumber = socialSecurityNumber
        self.street = street
        self.streetNumber = streetNumber
    }
}
