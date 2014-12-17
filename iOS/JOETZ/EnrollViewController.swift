//
//  InschrijvenViewController.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/17/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class EnrollViewController: FormViewController, FormViewControllerDelegate {
    
    var trip: Trip!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        println("EnrollViewController did load")
    }
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupForm() {
        
        let form = FormDescriptor()
        
        form.title = "Inschrijven"
        
        // Contact person
        
        let sectionContactPerson = FormSectionDescriptor()
        sectionContactPerson.headerTitle = "Contactpersoon"
        var row = FormRowDescriptor(tag: "CPfirstname", rowType: .Name, title: "Voornaam")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPlastname", rowType: .Name, title: "Familienaam")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPstreet", rowType: .Name, title: "Straat")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPstreetNumber", rowType: .Number, title: "Nummer")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPbus", rowType: .Name, title: "Bus")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPpostalCode", rowType: .Name, title: "Postcode")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPcity", rowType: .Name, title: "Stad")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPemail", rowType: .Name, title: "e-mail")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPgsm", rowType: .Name, title: "GSM")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPphone", rowType: .Name, title: "Telefoon")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPsocialMutualityNumber", rowType: .Name, title: "Nummer van de mutualiteit")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPcodeGerechtigde", rowType: .Name, title: "Code gerechtigde")
        sectionContactPerson.addRow(row)
        row = FormRowDescriptor(tag: "CPsocialSecurityNumber", rowType: .Name, title: "Rijksregisternummer")
        sectionContactPerson.addRow(row)
        
        // Paying User
        
        let sectionPayingUser = FormSectionDescriptor()
        sectionPayingUser.headerTitle = "Betalende persoon"
        row = FormRowDescriptor(tag: "PUfirstname", rowType: .Name, title: "Voornaam")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUlastname", rowType: .Name, title: "Familienaam")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUstreet", rowType: .Name, title: "Straat")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUstreetNumber", rowType: .Name, title: "Nr")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUbus", rowType: .Name, title: "Bus")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUpostalCode", rowType: .Name, title: "Postcode")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUcity", rowType: .Name, title: "Stad")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUemail", rowType: .Name, title: "e-mail")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUgsm", rowType: .Name, title: "GSM")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUphone", rowType: .Name, title: "Telefoonnummer")
        sectionPayingUser.addRow(row)
        row = FormRowDescriptor(tag: "PUsocialSecurityNumber", rowType: .Name, title: "Rijksregisternummer")
        sectionPayingUser.addRow(row)
        
        // Child
        
        let sectionChild = FormSectionDescriptor()
        sectionChild.headerTitle = "Kind"
        
        row = FormRowDescriptor(tag: "childId", rowType: .Picker, title: "Kind")
        
        var childrenDict: [String:String] = [:]
        
        for child in user.children {
            childrenDict[child.childId] = child.firstname + " " + child.lastname
        }
        
        row.options = childrenDict.keys.array
        
        row.titleFormatter = {
            value in
            return childrenDict[value as String]
        }
        
        sectionChild.addRow(row)
        
        // Emergency Contact
        
        let sectionEmergencyContact = FormSectionDescriptor()
        sectionEmergencyContact.headerTitle = "Contactpersoon in geval van nood"
        
        row = FormRowDescriptor(tag: "ECfirstname", rowType: .Name, title: "Voornaam")
        sectionEmergencyContact.addRow(row)
        row = FormRowDescriptor(tag: "EClastname", rowType: .Name, title: "Familienaam")
        sectionEmergencyContact.addRow(row)
        row = FormRowDescriptor(tag: "ECemail", rowType: .Name, title: "e-mail")
        sectionEmergencyContact.addRow(row)
        row = FormRowDescriptor(tag: "ECgsm", rowType: .Name, title: "GSM")
        sectionEmergencyContact.addRow(row)
        row = FormRowDescriptor(tag: "ECphone", rowType: .Name, title: "Telefoonnummer")
        sectionEmergencyContact.addRow(row)
        
        // extraSocialMutualityNumber, extraInfo
        
        let sectionOther = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: "extraSocialMutualityNumber", rowType: .Name, title: "Extra mutualiteitsnummer")
        sectionEmergencyContact.addRow(row)
        row = FormRowDescriptor(tag: "extraInfo", rowType: .Name, title: "Extra info")
        sectionEmergencyContact.addRow(row)
        
        form.sections = [sectionContactPerson, sectionPayingUser, sectionChild, sectionEmergencyContact, sectionOther]
        
        self.form = form
    }
    
    @IBAction func onClickDone(sender: UIBarButtonItem) {
        
        var fv = form.formValues()
        
        connectionService.enroll(true, tripId: trip.id, contactPerson: (bus: fv["CPbus"] as String?, city: fv["CPcity"] as String?, email: fv["CPemail"] as String, firstname: fv["CPfirstname"] as String?, lastname: fv["CPlastname"] as String?, gsm: fv["CPgsm"] as String, phone: fv["CPphone"] as String?, postalCode: fv["CPpostalCode"] as String?, socialMutualityNumber: fv["CPsocialMutualityNumber"] as String?, codeGerechtige: fv["CPcodeGerechtigde"] as String?, socialSecurityNumber: fv["CPsocialSecurityNumber"] as String?, street: fv["CPstreet"] as String?, streetNumber: fv["CPstreetNumber"] as Int?), extraSocialMutualityNumber: fv["extraSocialMutualityNumber"] as String?, payingUser: (bus: fv["PUbus"] as String?, city: fv["PUcity"] as String?, email: fv["PUemail"] as String, firstname: fv["PUfirstname"] as String, lastname: fv["PUlastname"] as String, gsm: fv["PUgsm"] as String, phone: fv["PUphone"] as String?, postalCode: fv["PUpostalCode"] as String?, socialSecurityNumber: fv["PUsocialSecurityNumber"] as String?, street: fv["PUstreet"] as String?, streetNumber: fv["PUstreetNumber"] as Int?), childId: fv["childId"] as String, emergencyContacts: [(email: fv["ECemail"] as String, firstname: fv["ECfirstname"] as String, lastname: fv["EClastname"] as String, gsm: fv["ECgsm"] as String, phone: fv["ECphone"] as String)], extraInfo: fv["extraInfo"] as String?, token: user.token!)
    }
}