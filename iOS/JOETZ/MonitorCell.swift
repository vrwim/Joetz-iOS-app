//
//  MonitorCell.swift
//  JOETZ
//
//  Created by Wim Van Renterghem on 12/15/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import UIKit
import MessageUI

class MonitorCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gsmLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var moniPic: UIImageView!
    
    var table: MonitorViewController!
    var monitor: Monitor! {
        didSet {
            nameLabel.text = monitor.name
            gsmLabel.text = monitor.gsm ?? "Privé"
            emailLabel.text = monitor.email
            moniPic.image = UIImage(named: "test.jpg")
        }
    }
    
    @IBAction func mail(sender: UIButton) {
        if monitor.email != nil {
            var emailTitle = ""
            var messageBody = ""
            var toRecipents = [monitor.email!]
            var mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = table
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            table.presentViewController(mc, animated: true, completion: nil)
        }
    }
    
    @IBAction func message(sender: UIButton) {
        if monitor.gsm! != "Privé" && monitor.gsm != nil{
            if MFMessageComposeViewController.canSendText() {
                let messageVC = MFMessageComposeViewController()
                messageVC.messageComposeDelegate = table
                messageVC.recipients = [monitor.gsm!]
                messageVC.body = ""
                table.presentViewController(messageVC, animated: true, completion: nil)
            }
            else {
                println("User hasn't setup Messages.app")
            }
        }
    }
    
    @IBAction func call(sender: UIButton) {
        if monitor.gsm! != "Privé"  && monitor.gsm != nil{
            var phoneNumber = "tel://"
            phoneNumber += monitor.gsm!
            UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
        }
    }
}
