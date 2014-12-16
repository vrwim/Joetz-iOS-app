//
//  AccountDetailsViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChangeAccountDetailsViewController: FormViewController, FormViewControllerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let svc = self.slidingViewController().underLeftViewController as? MenuViewController {
            //do nothing
        }
        else {
            self.slidingViewController().underLeftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as UIViewController
        }
        
        //Tmp fix for gesture + scrolling in Table view
        self.navigationController?.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        self.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //When going back from other view in navigationcontroller setup
        //self.navigationController?.view.addGestureRecognizer(self.slidingViewController().panGesture)
        
        //if there is a navigationcontroller apply shadow to it instead of this view
        if self.navigationController != nil {
            self.applyMenuShadowOnView(self.navigationController!.view)
        }
        else {
            self.applyMenuShadowOnView(self.view)
        }
    }
    
    func applyMenuShadowOnView(view: UIView) {
        view.layer.shadowOpacity = 0.75
        view.layer.shadowRadius = 10.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
    }
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupForm()
    }
    
    private func setupForm() {
        
        let user = UserService.getDetailsLoggedInUser()
        
        let form = FormDescriptor()
        
        form.title = "Registreer"
        
        // Personalia
        
        let sectionPersonalia = FormSectionDescriptor()
        sectionPersonalia.headerTitle = "Personalia"
        
        let firstname = user["firstname"] ?? ""
        var row = FormRowDescriptor(tag: "firstName", rowType: .Name, title: "Voornaam")
        row.value = firstname
        sectionPersonalia.addRow(row)
        
        let lastname = user["lastname"] ?? ""
        row = FormRowDescriptor(tag: "lastName", rowType: .Name, title: "Familienaam")
        row.value = lastname
        sectionPersonalia.addRow(row)
        
        var birthday = user["birthday"] ?? ""
        let birthdayDate = dateConverter(birthday)
        row = FormRowDescriptor(tag: "birthday", rowType: .Date, title: "Geboortedatum")
        row.value = birthdayDate
        sectionPersonalia.addRow(row)
        
        // Address
        
        let sectionAddress = FormSectionDescriptor()
        sectionAddress.headerTitle = "Adres"
        
        let street = user["street"] ?? ""
        row = FormRowDescriptor(tag: "street", rowType: .Name, title: "Straat")
        row.value = street
        sectionAddress.addRow(row)
        
        let streetNumber = user["streetNumber"] ?? ""
        row = FormRowDescriptor(tag: "streetNumber", rowType: .Number, title: "Nummer")
        row.value = streetNumber
        sectionAddress.addRow(row)
        
        let bus = user["bus"] ?? ""
        row = FormRowDescriptor(tag: "bus", rowType: .Name, title: "Bus")
        row.value = bus
        sectionAddress.addRow(row)
        
        let postalCode = user["postalCode"] ?? ""
        row = FormRowDescriptor(tag: "postalCode", rowType: .Number, title: "Postcode")
        row.value = postalCode
        sectionAddress.addRow(row)
        
        let city = user["city"] ?? ""
        row = FormRowDescriptor(tag: "city", rowType: .Name, title: "Stad")
        row.value = city
        sectionAddress.addRow(row)
        
        // Phones
        
        let sectionPhone = FormSectionDescriptor()
        sectionPhone.headerTitle = "Telefoonnummers"
        
        let gsm = user["gsm"] ?? ""
        row = FormRowDescriptor(tag: "gsm", rowType: .Phone, title: "GSM-nummer")
        row.value = gsm
        sectionPhone.addRow(row)
        
        let phone = user["phone"] ?? ""
        row = FormRowDescriptor(tag: "phone", rowType: .Phone, title: "Telefoonnummer")
        row.value = phone
        sectionPhone.addRow(row)
        
        // Numbers
        
        let sectionNumbers = FormSectionDescriptor()
        sectionNumbers.headerTitle = "Sociale nummers"
        
        let socialMutualityNumber = user["socialMutualityNumber"] ?? ""
        row = FormRowDescriptor(tag: "smn", rowType: .Text, title: "Nummer van de mutualiteit")
        row.value = socialMutualityNumber
        sectionNumbers.addRow(row)
        
        let socialSecurityNumber = user["socialSecurityNumber"] ?? ""
        row = FormRowDescriptor(tag: "ssn", rowType: .Text, title: "Rijksregisternummer")
        row.value = socialSecurityNumber
        sectionNumbers.addRow(row)
        
        form.sections = [sectionPersonalia, sectionAddress, sectionPhone, sectionNumbers]
        
        self.form = form
    }
    
    
    @IBAction func saveAccountDetails(sender: UIBarButtonItem) {
        
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        else{
            let fv = form.formValues() as [String:AnyObject]
        
            // nonoptionals
            let firstName = fv["firstName"] as? String
            let lastName = fv["lastName"] as? String
        
            var error: [String] = []
        
            if firstName == nil || firstName!.isEmpty {
                error.append("Voornaam is leeg")
            }
            if lastName == nil || lastName!.isEmpty {
                error.append("Familienaam is leeg")
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
                let user = UserService.getDetailsLoggedInUser()
                let id = user["id"]
                let token = user["token"]
            
                connectionService.changeAccountDetails(id!, token: token!, street: street, streetNumber: streetNumber, bus: bus, postalCode: postalCode, city: city, firstName: firstName, lastName: lastName, gsm: gsm, phone: phone, birthday: birthday, smn: smn, ssn: ssn /*, onFail: {
                    data in
                    if data == nil {
                        // alrt(geen intrnet)
                    } else {
                        // switch op foutcode;
                    }
                    }*/) {
                        token in
                        connectionService.getUserData(token) {
                            user in
                            var streetNumber = ""
                            if let streetNumberTmp = user.streetNumber {
                                streetNumber = String(streetNumberTmp)
                            }
                            LocksmithLogin.save(user.name ?? "", provider: user.provider ?? "", role: user.role ?? "", token: user.token ?? "", userAccount: user.email, id: user.id, birthday: user.birthday ?? "", bus: user.bus ?? "", city: user.city ?? "", firstname: user.firstname ?? "", lastname: user.lastname ?? "", gsm: user.gsm ?? "", phone: user.phone ?? "", postalCode: user.postalCode ?? "", socialMutualityNumber: user.socialMutualityNumber ?? "", socialSecurityNumber: user.socialSecurityNumber ?? "", street: user.street ?? "", streetNumber: streetNumber)
                            LocksmithLogin.changeLoggedInUser(user.email)
                    
                            let newTopViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AccountNavVC") as UIViewController
                            self.slidingViewController().topViewController = newTopViewController
                            }.resume()
                    }.resume()
            } else {
                showAlert("\n".join(error))
            }
        }
    }
    
    func showAlert(message: String) {
        var alert = UIAlertController(title: "Foute ingave", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    @IBAction func cancelBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
