//
//  MenuViewController.swift
//  JOETZ
//
//  Created by Jan Vanhulle on 22/11/14.
//  Copyright (c) 2014 Groep 3D07. All rights reserved.
//

import CoreData

class MenuViewController: UITableViewController
{
    var menuItems: [(storyBoardId: String, tI: (titel: String, image: String))] = [
        ("NewsSplitVC", ("Joetz Nieuws", "NewsIcon")),
        ("ParentTripsSplitVC", ("Reizen", "TripsIcon")),
        //("UserTripsSplitVC", ("Mijn Reizen", "UserTripsIcon")), //alleen bij ingelogde user
        ("LoginNavVC", ("Aanmelden", "AccountIcon")),
        ("SettingsNavVC", ("Instellingen", "SettingsIcon")),
        ("", ("", "")),
        ("ContactVC", ("Contact", "ContactIcon"))
    ]
    var loggedInUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slidingViewController().anchorRightRevealAmount = 200.0
        //self.edgesForExtendedLayout = UIRectEdge.None
        //self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let inset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = inset
        
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.tableView.separatorColor = UIColor(white: 0.15, alpha: 0.2)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Dirty fix (problem with UISplitViewControllers): hide and show the master view of the splitviewcontroller when we're going to show the menu
        //also make the master view 'static' (unhidable) for as long as the menu is visible
        if let svc = slidingViewController().topViewController as? UISplitViewController {
            svc.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
        
        var userEmail = UserService.getEmailLoggedInUser()
        var viewType = UserService.getViewTypeLoggedInUser()
                
        userEmail.isEmpty ? setUpMenu(false, pEmail: userEmail, viewType: viewType) : setUpMenu(true, pEmail: userEmail, viewType: viewType)
        
    }
    
    func setUpMenu(pLoggedInUser: Bool, pEmail: String, viewType: String) {
        var storyboardId = UserService.getSBIdForViewType()
        
        
        if pLoggedInUser {
            self.loggedInUser = true
            let userDetails = UserService.getDetailsLoggedInUser()
            let userRole = userDetails["role"]
            if userRole == "user" || userRole == "" || userRole == "admin" {
                menuItems = [
                    ("NewsSplitVC", ("Joetz Nieuws", "NewsIcon")),
                    (storyboardId, ("Reizen", "TripsIcon")),
                    //Gewoon de lijst van reizen aanpassen, al de rest blijft hetzelfde
                    (storyboardId, ("Mijn Reizen", "UserTripsIcon")), //alleen bij ingelogde user
                    ("AccountNavVC", ("Account", "AccountIcon")),
                    ("SettingsNavVC", ("Instellingen", "SettingsIcon")),
                    ("", ("", "")),
                    ("LogoutVC", ("Logout", "AccountIcon")),
                    ("ContactVC", ("Contact", "ContactIcon"))
                ]
            }
            else if userRole == "monitor" {
                menuItems = [
                    ("NewsSplitVC", ("Joetz Nieuws", "NewsIcon")),
                    (storyboardId, ("Reizen", "TripsIcon")),
                    //Gewoon de lijst van reizen aanpassen, al de rest blijft hetzelfde
                    //("ContactNavVC", ("Contact", "ContactIcon")),
                    //("PlanningNavVC", ("Planning", "TBD")),
                    ("MonitorsNavVC", ("Monitoren", "MonitorsIcon")),
                    ("AccountNavVC", ("Account", "AccountIcon")),
                    ("SettingsNavVC", ("Instellingen", "SettingsIcon")),
                    ("", ("", "")),
                    ("LogoutVC", ("Logout", "AccountIcon")),
                    ("ContactVC", ("Contact", "ContactIcon"))
                ]
            }
        }
        else {
            self.loggedInUser = false
            menuItems = [
                ("NewsSplitVC", ("Joetz Nieuws", "NewsIcon")),
                (storyboardId, ("Reizen", "TripsIcon")),
                ("LoginNavVC", ("Aanmelden", "AccountIcon")),
                //("AccountNavVC", ("Account", "AccountIcon")),
                ("SettingsNavVC", ("Instellingen", "SettingsIcon")),
                ("", ("", "")),
                ("ContactVC", ("Contact", "ContactIcon")),
            ]
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let svc = slidingViewController().topViewController as? UISplitViewController {
            svc.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //Let the system handle the display mode of the splitviewcontroller after the menu is hidden
        if let svc = slidingViewController().topViewController as? UISplitViewController {
            if (UIDevice.currentDevice().model as NSString).containsString("iPad") {
                if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
                    svc.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
                } else {
                    svc.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
                }
            }
        }
        self.view = nil
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var bottomItems = 2
        if loggedInUser {
            bottomItems += 1
        }
        if indexPath.row == menuItems.count - bottomItems {
            return CGFloat(Int(UIScreen.mainScreen().bounds.size.height) - 15 - (44 * menuItems.count))
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var bottomItems = 2
        if loggedInUser {
            bottomItems += 1
        }
        if indexPath.row != menuItems.count - bottomItems{
            return indexPath
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as UITableViewCell
        cell.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        
        var bottomItems = 2
        if loggedInUser {
            bottomItems += 1
        }
        if indexPath.row == menuItems.count - bottomItems{
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        
        //cell.textLabel.text = self.menu[indexPath.row]
        cell.textLabel!.text = self.menuItems[indexPath.row].tI.titel
        cell.textLabel!.textColor = UIColor(hue: CGFloat(359/360), saturation: 0.0, brightness: 0.85, alpha: 1.0)
        
        //Menu icon
        let imageName = self.menuItems[indexPath.row].tI.image
        cell.imageView!.image = UIImage(named: imageName)
        
        //Start menu icon scaling (tmp)
        let itemSize: CGSize = CGSizeMake(35, 35)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
        let imageRect: CGRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height)
        cell.imageView!.image?.drawInRect(imageRect)
        cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Background colour for selected cell
        let cellSelectedBackgroundView: UIImageView = UIImageView(frame: cell.frame)
        cellSelectedBackgroundView.backgroundColor = UIColor.darkGrayColor()
        cell.selectedBackgroundView = cellSelectedBackgroundView
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier: String = self.menuItems[indexPath.row].storyBoardId
        
        let newTopViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        
        //Switch to new view
        self.slidingViewController().topViewController = newTopViewController
        self.slidingViewController().anchorTopViewToRightAnimated(true)
        self.slidingViewController().resetTopViewAnimated(true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Section titles (to be removed)
        var sectionName = ""
        switch section
        {
        case 0: sectionName = "Menu"
        default: sectionName = "Menu"
            
        }
        return sectionName
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //Statusbar colour when menu is open
        return UIStatusBarStyle.LightContent
    }
    
    /*override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //Background of section colour
    view.tintColor = UIColor.darkGrayColor()
    
    //Section text colour
    let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
    header.textLabel.textColor = UIColor(hue: CGFloat(359/360), saturation: 0.0, brightness: 0.85, alpha: 1.0)
    
    }*/
    
    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var image: UIImage! = UIImage(named: "bond-moyson.png")
        
        image = scaleImage(tableView.bounds.width / 3, image: image)
        
        let imageView: UIImageView = UIImageView(image: image)
        //imageView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 0)
        //imageView.sizeToFit()
        //imageView.frame = CGRectMake(0.0, 0.0, tableView.bounds.size.width, 50)
        imageView.contentMode = UIViewContentMode.TopLeft
        
        return imageView
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func scaleImage(width: CGFloat, image: UIImage) -> UIImage {
        var scaledImage: UIImage = image
        if image.size.width != width {
            let height: CGFloat = floor(image.size.height * ((width - 15) / image.size.width))
            let size: CGSize = CGSizeMake(width, height)
            
            UIGraphicsBeginImageContext(size)
            image.drawInRect(CGRectMake(15.0, 0.0, size.width - 15, size.height))
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return scaledImage
    }*/
    
}
