//
//  LocksmithLogin.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

class LocksmithLogin {
    
    //save the userdetails in keychain
    class func save(name: String, provider: String, role: String, token: String, userAccount: String) {
        let dict: [String: String] = ["name":name, "provider": provider, "role":role, "token":token]
        let error = Locksmith.saveData(dict, forKey: "details", inService: "Locksmith", forUserAccount: userAccount)
        //if there is an error, userAccount already exists --> update instead
        if error != nil {
            update(name, provider: provider, role: role, token: token, userAccount: userAccount)
        }
    }
    
    //update existing userdata in keychain
    class func update(name: String, provider: String, role: String, token: String, userAccount: String) {
        let dict: [String: String] = ["name":name, "provider": provider, "role":role, "token":token]
        let error = Locksmith.updateData(dict, forKey: "details", inService: "Locksmith", forUserAccount: userAccount)
    }
    
    //change logged in used in CoreData
    class func changeLoggedInUser(pEmail: String) {
        var globalSettings: GlobalSettings?
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                globalSettings = fetchResults[0]
                
                if let globalSettingsTmp = globalSettings {
                    globalSettings!.loggedInUser = pEmail
                }
                
                context.save(nil)
            }
        }
    }
}