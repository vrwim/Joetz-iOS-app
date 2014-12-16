//
//  ChangePasswordViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit

class ChangePasswordViewController: FormViewController, FormViewControllerDelegate
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
        
        let form = FormDescriptor()
        
        form.title = "Wachtwoord wijzigen"
        
        let sectionPassword = FormSectionDescriptor()
        sectionPassword.headerTitle = "Wachtwoord wijzigen"
        
        var row = FormRowDescriptor(tag: "oldPass", rowType: .Text, title: "Huidig wachtwoord")
        sectionPassword.addRow(row)
        
        row = FormRowDescriptor(tag: "newPass", rowType: .Text, title: "Nieuw wachtwoord")
        sectionPassword.addRow(row)
        
        row = FormRowDescriptor(tag: "newPass2", rowType: .Text, title: "Herhaal wachtwoord")
        sectionPassword.addRow(row)
        
        form.sections = [sectionPassword]
        
        self.form = form
    }
    
    @IBAction func savePassword(sender: UIBarButtonItem) {
        
        if !Reachability.isConnectedToNetwork() {
            let noInternetAlert = Reachability.giveNoInternetAlert()
            presentViewController(noInternetAlert, animated: true, completion: nil)
        }
        else {
            let fv = form.formValues() as [String:AnyObject]
            
            let oldPass = fv["oldPass"] as? String
            let newPass = fv["newPass"] as? String
            let newPass2 = fv["newPass2"] as? String
        
            var error: [String] = []
            
            if oldPass == nil || oldPass!.isEmpty {
                error.append("Huidig wachtwoord is leeg")
            }
            if newPass == nil || newPass!.isEmpty {
                error.append("Nieuw wachtwoord is leeg")
            }
            if newPass2 == nil || newPass2!.isEmpty {
                error.append("Herhaling wachtwoord is leeg")
            }
            if newPass != newPass2 {
                error.append("Wachtwoorden komen niet overeen")
            }
            
            if error.count != 0 {
                let alert = UIAlertController(title: "Ongeldig ingave", message: "\n".join(error), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
            else {
        
                let userDetails = UserService.getDetailsLoggedInUser()
                let id = userDetails["id"]
                let email = UserService.getEmailLoggedInUser()
                let token = userDetails["token"]
            
                connectionService.changePassword(id!, email: email, oldPassword: oldPass!, newPassword: newPass!, token: token!).resume()
            }
        }
        
        
    }
    
    
    @IBAction func cancelBtn(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
