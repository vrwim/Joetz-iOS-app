//
//  RegisterViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/14/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class RegisterViewController: FormViewController, FormViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        println("RegisterUserController did load")
    }
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupForm()
    }
    
    private func setupForm() {
        
        let form = FormDescriptor()
        
        form.title = "Registreer"
        
        // Personalia
        
        let sectionPersonalia = FormSectionDescriptor()
        sectionPersonalia.headerTitle = "Personalia"
        
        var row = FormRowDescriptor(tag: "firstName", rowType: .Name, title: "Voornaam")
        sectionPersonalia.addRow(row)
        
        row = FormRowDescriptor(tag: "lastName", rowType: .Name, title: "Familienaam")
        sectionPersonalia.addRow(row)
        
        row = FormRowDescriptor(tag: "birthday", rowType: .Date, title: "Geboortedatum")
        sectionPersonalia.addRow(row)
        
        row = FormRowDescriptor(tag: "role", rowType: .Picker , title: "Rol")
        row.options = ["user", "monitor"]
        row.titleFormatter = {
            value in
            switch(value) {
            case "user":
                return "Ouder"
            case "monitor":
                return "Monitor"
            default:
                return nil
            }
        }
        sectionPersonalia.addRow(row)
        
        // Address
        
        let sectionAddress = FormSectionDescriptor()
        sectionAddress.headerTitle = "Adres"
        
        row = FormRowDescriptor(tag: "street", rowType: .Name, title: "Straat")
        sectionAddress.addRow(row)
        
        row = FormRowDescriptor(tag: "streetNumber", rowType: .Number, title: "Nummer")
        sectionAddress.addRow(row)
        
        row = FormRowDescriptor(tag: "bus", rowType: .Name, title: "Bus")
        sectionAddress.addRow(row)
        
        row = FormRowDescriptor(tag: "postalCode", rowType: .Number, title: "Postcode")
        sectionAddress.addRow(row)
        
        row = FormRowDescriptor(tag: "city", rowType: .Name, title: "Stad")
        sectionAddress.addRow(row)
        
        // Phones
        
        let sectionPhone = FormSectionDescriptor()
        sectionPhone.headerTitle = "Telefoonnummers"
        
        row = FormRowDescriptor(tag: "gsm", rowType: .Phone, title: "GSM-nummer")
        sectionPhone.addRow(row)
        
        row = FormRowDescriptor(tag: "phone", rowType: .Phone, title: "Telefoonnummer")
        sectionPhone.addRow(row)
        
        // Numbers
        
        let sectionNumbers = FormSectionDescriptor()
        sectionNumbers.headerTitle = "Sociale nummers"
        
        row = FormRowDescriptor(tag: "smn", rowType: .Text, title: "Nummer van de mutualiteit")
        sectionNumbers.addRow(row)
        
        row = FormRowDescriptor(tag: "ssn", rowType: .Text, title: "Rijksregisternummer")
        sectionNumbers.addRow(row)
        
        // Login
        
        let sectionLogin = FormSectionDescriptor()
        sectionLogin.headerTitle = "Account"
        
        row = FormRowDescriptor(tag: "email", rowType: .Email, title: "E-mail")
        sectionLogin.addRow(row)
        
        // Currently using .Text, but should be .Password; this because of a bug in the framework we are using
        // bugreport in https://github.com/ortuman/SwiftForms/issues/12
        row = FormRowDescriptor(tag: "password", rowType: .Text, title: "Wachtwoord")
        sectionLogin.addRow(row)
        
        row = FormRowDescriptor(tag: "password2", rowType: .Text, title: "Herhaal wachtwoord")
        sectionLogin.addRow(row)
        
        form.sections = [sectionPersonalia, sectionAddress, sectionPhone, sectionNumbers, sectionLogin]
        
        self.form = form
    }
    
    @IBAction func OnClickDone(sender: UIBarButtonItem) {
        
        let fv = form.formValues() as [String:AnyObject]
        
        // nonoptionals
        let email = fv["email"] as? String
        let password = fv["password"] as? String
        let password2 = fv["password2"] as? String
        let firstName = fv["firstName"] as? String
        let lastName = fv["lastName"] as? String
        
        var error: [String] = []
        
        if email == nil || email!.isEmpty {
            error.append("Email is leeg")
        }
        if firstName == nil || firstName!.isEmpty {
            error.append("Voornaam is leeg")
        }
        if lastName == nil || lastName!.isEmpty {
            error.append("Familienaam is leeg")
        }
        if !validateEmail(email!) {
            error.append("Email is niet geldig")
        }
        if password == nil || password!.isEmpty {
            error.append("Wachtwoord is leeg")
        }
        if password2 == nil || password2!.isEmpty {
            error.append("Herhaling wachtwoord is leeg")
        }
        if password != password2 {
            error.append("Wachtwoorden komen niet overeen")
        }
        
        if error.count == 0 {
            
            // optionals
            let street = fv["street"] as? String
            let streetNumber = (fv["streetNumber"] as? String)?.toInt()
            let bus = fv["bus"] as? String
            let postalCode = fv["postalCode"] as? String
            let city = fv["city"] as? String
            let gsm = fv["gsm"] as? String
            let phone = fv["phone"] as? String
            let birthday = fv["birthday"] as? NSDate
            let smn = fv["smn"] as? String
            let ssn = fv["ssn"] as? String
            let role = fv["role"] as? String
            
            connectionService.register(street, streetNumber: streetNumber, bus: bus, postalCode: postalCode, city: city, firstName: firstName, lastName: lastName, gsm: gsm, phone: phone, birthday: birthday, smn: smn, ssn: ssn, email: email!, password: password!, role: role) {
                token in
                connectionService.getUserData(token) {
                    user in
                    LocksmithLogin.save(user.name, provider: user.provider, role: user.role, token: user.token, userAccount: user.email, id: user.id)
                    LocksmithLogin.changeLoggedInUser(user.email)
                    
                    let newTopViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ParentTripsSplitVC") as UIViewController
                    self.slidingViewController().topViewController = newTopViewController
                    }.resume()
                }.resume()
        } else {
            showAlert("\n".join(error))
        }
        
    }
    
    func showAlert(message: String) {
        var alert = UIAlertController(title: "Oeps", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)!.evaluateWithObject(candidate)
    }
}
