//
//  Monitor.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

class Monitor {
    
    let name: String
    let gsm: String?
    let email: String
    
    init(name: String, gsm: String?, email: String) {
        self.name = name
        self.gsm = gsm
        self.email = email
    }
}
