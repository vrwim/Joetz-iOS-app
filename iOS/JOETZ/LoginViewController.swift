//
//  LoginViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 10/29/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: MenuSetupUIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
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
                var streetNumber = ""
                if let streetNumberTmp = user.streetNumber {
                    streetNumber = String(streetNumberTmp)
                }

                LocksmithLogin.save(user.name ?? "", provider: user.provider ?? "", role: user.role ?? "", token: user.token ?? "", userAccount: user.email, id: user.id, birthday: user.birthday ?? "", bus: user.bus ?? "", city: user.city ?? "", firstname: user.firstname ?? "", lastname: user.lastname ?? "", gsm: user.gsm ?? "", phone: user.phone ?? "", postalCode: user.postalCode ?? "", socialMutualityNumber: user.socialMutualityNumber ?? "", socialSecurityNumber: user.socialSecurityNumber ?? "", street: user.street ?? "", streetNumber: streetNumber)
                LocksmithLogin.changeLoggedInUser(user.email)
                
                let newTopViewController = self.storyboard?.instantiateViewControllerWithIdentifier(UserService.getSBIdForViewType()) as UIViewController
                self.slidingViewController().topViewController = newTopViewController
            }.resume()
        }.resume()
    }
}