//
//  ViewController.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/15/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isLoggedIn: Bool = false
    var user: UserTableRowItem?
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var browseReportButton: UIButton!
    
    @IBOutlet weak var notLoggedInLabel: UILabel!{
        didSet {
            notLoggedInLabel.hidden = isLoggedIn
        }
    }
    
    @IBOutlet weak var signInButton: UIButton!{
        didSet {
            signInButton.hidden = isLoggedIn
            signInButton.layer.cornerRadius = 5
            signInButton.layer.borderWidth = 1
            signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    @IBOutlet weak var signOutButton: UIButton!{
        didSet {
            signOutButton.hidden = !isLoggedIn
            signOutButton.layer.cornerRadius = 5
            signOutButton.layer.borderWidth = 1
            signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    
    @IBOutlet weak var userEmailLabel: UILabel!{
        didSet {
            userEmailLabel.hidden = !isLoggedIn
            if let u = user {
                userEmailLabel.text = u.userEmail
            }
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        isLoggedIn = false
        notLoggedInLabel.hidden = isLoggedIn
        signInButton.hidden = isLoggedIn
        signOutButton.hidden = !isLoggedIn
        userEmailLabel.hidden = !isLoggedIn        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor =  UIColor(red:0.2, green:0.6, blue:0.8, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        reportButton.layer.cornerRadius = 5
        reportButton.layer.borderWidth = 1
        reportButton.layer.borderColor = UIColor.whiteColor().CGColor
        browseReportButton.layer.cornerRadius = 5
        browseReportButton.layer.borderWidth = 1
        browseReportButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        switch identifier ?? "MISSING" {
        case Identifier.goToReportSegue:
            if isLoggedIn {
                return true
            } else {
                Alert.alert("Please log in first")
                return false
            }
        case Identifier.goToBrowsePrepareSegue:
            return true
        case Identifier.goToSignInViewSegue:
            return true
        default:
            assertionFailure("Unknown segue")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifier.goToReportSegue:
            if let destVC = segue.destinationViewController as? ReportVC {
                destVC.user = user
            }
        case Identifier.goToBrowsePrepareSegue:
            if let destVC = segue.destinationViewController as? BrowsePrepareVC, let u = user {
                destVC.user = u 
            }
        case Identifier.goToSignInViewSegue:
            ()
        default:
            assertionFailure("Unknown segue")
        }
    }

}

