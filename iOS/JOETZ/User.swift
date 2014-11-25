//
//  User.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 11/25/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class User {
    
    let id: String
    let provider: String
    let name: String
    let email: String
    let role: String
    let token: String
    
    init(id: String, provider: String, name: String, email: String, role: String, token: String) {
        self.id = id
        self.provider = provider
        self.name = name
        self.email = email
        self.role = role
        self.token = token
    }
}
