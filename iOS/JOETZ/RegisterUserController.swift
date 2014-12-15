//
//  RegisterUserController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/14/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class RegisterUserController: FormViewController, FormViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        println("RegisterUserController did load")
    }
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("1")
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
        
        row = FormRowDescriptor(tag: "password", rowType: .Password, title: "Wachtwoord")
        sectionLogin.addRow(row)
        
        row = FormRowDescriptor(tag: "password2", rowType: .Password, title: "Herhaal wachtwoord")
        sectionLogin.addRow(row)
        
        form.sections = [sectionPersonalia, sectionAddress, sectionPhone, sectionNumbers, sectionLogin]
        
        self.form = form
    }
    
    @IBAction func OnClickDone(sender: UIBarButtonItem) {
        
        let fv = form.formValues() as [String:AnyObject]
        
        println(fv.debugDescription)
        
        for pair in fv {
            print(pair.0 + "\t")
            println(pair.1.debugDescription)
        }
        
        let street = fv["street"] as String
        let streetNumber = (fv["streetNumber"] as String).toInt()!
        let bus = fv["bus"] as String
        let postalCode = fv["postalCode"] as String
        let city = fv["city"] as String
        let firstName = fv["firstName"] as String
        let lastName = fv["lastName"] as String
        let gsm = fv["gsm"] as String
        let phone = fv["phone"] as String
        let birthday = fv["birthday"] as NSDate
        let smn = fv["smn"] as String
        let ssn = fv["ssn"] as String
        let email = fv["email"] as String
        let password = fv["password"] as String
        
        connectionService.register(street, streetNumber: streetNumber, bus: bus, postalCode: postalCode, city: city, firstName: firstName, lastName: lastName, gsm: gsm, phone: phone, birthday: birthday, smn: smn, ssn: ssn, email: email, password: password) {
            token in
            connectionService.getUserData(token) {
                user in
                // do something with user
                }.resume()
            }.resume()
        
    }
}
