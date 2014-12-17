//
//  AddChildToParentViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class AddChildToParentViewController: FormViewController, FormViewControllerDelegate
{
    
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
        
        // Numbers
        
        let sectionNumbers = FormSectionDescriptor()
        sectionNumbers.headerTitle = "Sociale nummers"
        
        row = FormRowDescriptor(tag: "ssn", rowType: .Text, title: "Rijksregisternummer")
        sectionNumbers.addRow(row)
        
        form.sections = [sectionPersonalia, sectionAddress, sectionNumbers]
        
        self.form = form
    }
    
    @IBAction func saveChild(sender: UIBarButtonItem) {
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        else {
            let fv = form.formValues() as [String:AnyObject]
            
            // nonoptionals
            let firstName = fv["firstName"] as? String
            let lastName = fv["lastName"] as? String
            let birthday = fv["birthday"] as? NSDate
            let ssn = fv["ssn"] as? String
            
            var error: [String] = []
            
            if firstName == nil || firstName!.isEmpty {
                error.append("Voornaam is leeg")
            }
            if lastName == nil || lastName!.isEmpty {
                error.append("Familienaam is leeg")
            }
            if birthday == nil {
                error.append("Geboortedatum is leeg")
            }
            if ssn == nil || ssn!.isEmpty {
                error.append("Rijksregisternummer is leeg")
            }
            
            if error.count == 0 {
                
                // optionals
                let street = fv["street"] as? String
                let streetNumber = (fv["streetNumber"] as? String)?.toInt()
                let bus = fv["bus"] as? String
                let postalCode = fv["postalCode"] as? String
                let city = fv["city"] as? String
                
                let user = UserService.getDetailsLoggedInUser()
                let id = user["id"]
                let token = user["token"]
                
                connectionService.getUserData(token!) {
                    user in
                    
                    connectionService.addChildToParent(id!, token: token!, firstname: firstName!, lastname: lastName!, birthday: birthday!, ssn: ssn!, street: street, streetNumber: streetNumber, bus: bus, postalCode: postalCode, city: city, existingChildren: user.children /*, onFail: {
                        data in
                        if data == nil {
                        // alrt(geen intrnet)
                        } else {
                        // switch op foutcode;
                        }
                        }*/) {
                            token in
                            println("numero unos")
                            let newTopViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccountNavVC") as UIViewController
                            self.slidingViewController().topViewController = newTopViewController
                            println("blablabkaalbdkbdsivndsvndisqbvnioqsbvoisqdbv")
                        }.resume()
                    }.resume()
            } else {
                showAlert("\n".join(error))
            }
        }
    }
    
    
    @IBAction func cancenBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlert(message: String) {
        var alert = UIAlertController(title: "Foute ingave", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
