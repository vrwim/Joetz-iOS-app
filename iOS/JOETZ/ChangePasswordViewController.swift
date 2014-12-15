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
        
        var row = FormRowDescriptor(tag: "oldPass", rowType: .Password, title: "Huidig wachtwoord")
        sectionPassword.addRow(row)
        
        row = FormRowDescriptor(tag: "newPass", rowType: .Password, title: "Nieuw wachtwoord")
        sectionPassword.addRow(row)
        
        row = FormRowDescriptor(tag: "newPass2", rowType: .Password, title: "Herhaal wachtwoord")
        sectionPassword.addRow(row)
        
        form.sections = [sectionPassword]
        
        self.form = form
    }
    
    @IBAction func savePassword(sender: UIBarButtonItem) {
        
        let fv = form.formValues() as [String:AnyObject]
        
        println(fv.debugDescription)
        
        for pair in fv {
            print(pair.0 + "\t")
            println(pair.1.debugDescription)
        }

        let password = fv["password"] as String
        
        //ToDo: send to server
        
    }
    
}
