//
//  LoginViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/29/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class LoginViewController: MenuSetupUIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var userAccount = ""
    let service = "Locksmith"
    let key = "details"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("LoginViewController did load")
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
    
    @IBAction func loginButtonPress(sender: UIButton) {        
        connectionService.authenticate(email.text, password: password.text) {
            token in
            println("Token: \(token)")
            
            connectionService.getUserData(token) {
                user in
                // insert CoreData here
                self.userAccount = user.email
                self.save(user.name, provider: user.provider, role: user.role, token: user.token)
            }.resume()
        }.resume()
    }
    
    //save the userdetails in keychain
    func save(name: String, provider: String, role: String, token: String) {
        let dict: [String: String] = ["name":name, "provider": provider, "role":role, "token":token]
        let error = Locksmith.saveData(dict, forKey: self.key, inService: service, forUserAccount: userAccount)
        //if there is an error, userAccount already exists --> update instead
        if error != nil {
            update(name, provider: provider, role: role, token: token)
        }
    }
    
    //update existing userdata in keychain
    func update(name: String, provider: String, role: String, token: String) {
        let dict: [String: String] = ["name":name, "provider": provider, "role":role, "token":token]
        let error = Locksmith.updateData(dict, forKey: key, inService: service, forUserAccount: userAccount)
    }
}