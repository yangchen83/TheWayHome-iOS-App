//
//  SignUpVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/24/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {    
    var userItem = UserTableRowItem()

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 5
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }

    
    @IBOutlet weak var submitActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitActivityIndicator.hidden = true
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        switch identifier ?? "MISSING" {
        case Identifier.signUpConfirmSegue:
            if let email = emailText.text, let password = passwordText.text, let passwordConfirm = passwordConfirmText.text {
                if email == "" || password == "" || passwordConfirm == "" {
                    Alert.alert("Please fill in all fields")
                    return false
                } else if password != passwordConfirm {
                    Alert.alert("Password does not match the confirm password")
                    passwordText.text = ""
                    passwordConfirmText.text = ""
                    return false
                } else if !isValidEmail(email){
                    Alert.alert("Please enter a valid email address")
                    emailText.text = ""
                    return false
                } else {
                    submitActivityIndicator.hidden = false
                    submitActivityIndicator.startAnimating()
                    userItem["email"] = email.lowercaseString
                    userItem["passwordHash"] = password.md5
                    userItem["reportNumber"] = 0
                    var query = PFQuery(className: "Users")
                    query.whereKey("email", equalTo: email)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            if let o = objects as? [PFObject] where o.count == 0 {
                                self.userItem.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                                    if succeeded {
                                        self.performSegueWithIdentifier(Identifier.signUpConfirmSegue, sender: nil)
                                    } else {
                                        Alert.alert("Error signing up, please try again")
                                    }
                                })
                            } else {
                                Alert.alert("The Email has signed up already")
                            }
                        } else {
                            Alert.alert("Network error, please try again")
                        }
                        self.submitActivityIndicator.stopAnimating()
                        self.submitActivityIndicator.hidden = true
                    }
                }
                return false
            }
        default:
            assertionFailure("Unknown Segue Identifier")
            return false
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifier.signUpConfirmSegue:
            if let destVCNav = segue.destinationViewController as? UINavigationController,
                let destinationVC = destVCNav.topViewController as? ViewController {
                    destinationVC.isLoggedIn = true
                    destinationVC.user = userItem
            }
        default:
            assertionFailure("UnKnown Segue Identifier")
        }
    }
}
