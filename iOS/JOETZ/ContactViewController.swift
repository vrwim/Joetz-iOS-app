//
//  ContactViewController.swift
//  JOETZ
//
//  Created by Mathan Hermans on 15/12/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//
import MessageUI

class ContactViewController: MenuSetupUIViewController, MFMailComposeViewControllerDelegate {
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        setupMenuButton()
    }
    
    @IBAction func launchCall(sender: UIButton) {
        var phoneNumber = "tel://"
        phoneNumber += ((sender as UIButton).currentTitle!.componentsSeparatedByString("Tel. ")[1]).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println(phoneNumber)
        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
    }
    
    @IBAction func launchWebsite(sender: UIButton) {
        var url = ""
        if ((sender as UIButton).currentTitle! == "Website Joetz"){
            url = "http://www.joetz.be/Pages/default.aspx"
        } else {
            url = "http://www.bondmoyson.be/ovl/Pages/default.aspx"
        }
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    @IBAction func launchJoetzEmail(sender: AnyObject) {
        var emailTitle = ""
        var messageBody = ""
        var toRecipents = [(sender as UIButton).currentTitle!]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)

        self.presentViewController(mc, animated: true, completion: nil)
    }

    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}