//
//  ChangeChildDetailsViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChangeChildDetailsViewController: FormViewController, FormViewControllerDelegate
{
    var child: (childId: String, firstname: String, lastname: String, socialSecurityNumber: String, birthday: String, street: String?, streetNumber: Int?, zipcode: String?, bus: String?, city: String?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupForm()
    }
    
    private func setupForm() {
        
        let form = FormDescriptor()
        
        form.title = "Gegevens kind"
        
        // Personalia
        
        let sectionPersonalia = FormSectionDescriptor()
        sectionPersonalia.headerTitle = "Personalia"
        
        let firstname = child!.firstname ?? ""
        var row = FormRowDescriptor(tag: "firstName", rowType: .Name, title: "Voornaam")
        row.value = firstname
        sectionPersonalia.addRow(row)
        
        let lastname = child!.lastname ?? ""
        row = FormRowDescriptor(tag: "lastName", rowType: .Name, title: "Familienaam")
        row.value = lastname
        sectionPersonalia.addRow(row)
        
        var birthday = child!.birthday ?? ""
        let birthdayDate = dateConverter(birthday)
        row = FormRowDescriptor(tag: "birthday", rowType: .Date, title: "Geboortedatum")
        row.value = birthdayDate
        sectionPersonalia.addRow(row)
        
        // Address
        
        let sectionAddress = FormSectionDescriptor()
        sectionAddress.headerTitle = "Adres"
        
        let street = child!.street ?? ""
        row = FormRowDescriptor(tag: "street", rowType: .Name, title: "Straat")
        row.value = street
        sectionAddress.addRow(row)
        
        let streetNumber = "\(child!.streetNumber)" ?? ""
        row = FormRowDescriptor(tag: "streetNumber", rowType: .Number, title: "Nummer")
        row.value = streetNumber
        sectionAddress.addRow(row)
        
        let bus = child!.bus ?? ""
        row = FormRowDescriptor(tag: "bus", rowType: .Name, title: "Bus")
        row.value = bus
        sectionAddress.addRow(row)
        
        let postalCode = child!.zipcode ?? ""
        row = FormRowDescriptor(tag: "postalCode", rowType: .Number, title: "Postcode")
        row.value = postalCode
        sectionAddress.addRow(row)
        
        let city = child!.city ?? ""
        row = FormRowDescriptor(tag: "city", rowType: .Name, title: "Stad")
        row.value = city
        sectionAddress.addRow(row)
        
        // Numbers
        
        let sectionNumbers = FormSectionDescriptor()
        sectionNumbers.headerTitle = "Sociale nummers"
        
        let socialSecurityNumber = child!.socialSecurityNumber ?? ""
        row = FormRowDescriptor(tag: "ssn", rowType: .Text, title: "Rijksregisternummer")
        row.value = socialSecurityNumber
        sectionNumbers.addRow(row)
        
        form.sections = [sectionPersonalia, sectionAddress, sectionNumbers]
        
        self.form = form
    }
    
    @IBAction func saveChildDetails(sender: UIBarButtonItem) {
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        else {
            
        }
    }
    
    
    @IBAction func cancelBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func dateConverter(date: String) -> NSDate? {
        var birthday = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let tmpDate = dateFormatter.dateFromString(date)!
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        birthday = dateFormatter.stringFromDate(tmpDate)
        
        var birthdayDate = dateFormatter.dateFromString(birthday)
        
        return birthdayDate
    }
}
