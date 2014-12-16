//
//  UserService.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

class UserService {
    class func getEmailLoggedInUser() -> String {
        var globalSettings: GlobalSettings?
        var userEmail = ""
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                globalSettings = fetchResults[0]
                if let globalSettingsTmp = globalSettings {
                    
                    if let userEmailTmp = globalSettingsTmp.loggedInUser as String? {
                        userEmail = userEmailTmp
                    }
                    
                }
                
            }
        }
        
        return userEmail
    }
    
    class func getViewTypeLoggedInUser() -> String {
        var globalSettings: GlobalSettings?
        var viewType = ""
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "GlobalSettings")
        
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [GlobalSettings]
        {
            if fetchResults.count > 0
            {
                globalSettings = fetchResults[0]
                if let globalSettingsTmp = globalSettings {
                    
                    if let tmpViewType = globalSettingsTmp.viewType as String? {
                        viewType = tmpViewType
                    }
                    
                }
                
            }
        }
        
        return viewType
    }
    
    class func getDetailsLoggedInUser() -> [String:String] {
        let email = getEmailLoggedInUser()
        
        let (dictionary, error) = Locksmith.loadData(forKey: "details", inService: "Locksmith", forUserAccount: email)
        
        if let error = error {
            println("Error: \(error)")
        }
        
        if let dictionary = dictionary as? [String:String] {
            return dictionary
        }
        
        return ["":""]
    }
    
    class func getSBIdForViewType() -> String {
        let viewType = getViewTypeLoggedInUser()
        var storyboardId = ""
        
        if viewType == "childView" {
            storyboardId = "ChildTripsNavVC"
        }
        else {
            storyboardId = "ParentTripsSplitVC"
        }
        
        return storyboardId
    }
    
    class func changeViewType(viewType: String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let ent = NSEntityDescription.entityForName("GlobalSettings", inManagedObjectContext: context)
        
        var globalSettings = GlobalSettings(entity: ent!, insertIntoManagedObjectContext: context)
        globalSettings.viewType = viewType//"parentView"
        
        context.save(nil)
    }
}
