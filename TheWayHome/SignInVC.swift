//
//  SignInVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/24/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    var userItem = UserTableRowItem()
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var wrongCredentialAlert: UILabel!
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 5
            signInButton.layer.borderWidth = 1
            signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
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
        emailText.delegate = self
        passwordText.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        wrongCredentialAlert.hidden = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        switch identifier ?? "MISSING" {
        case Identifier.signInSegue:
            if let email = emailText.text, let password = passwordText.text {
                if email == "" || password == "" {
                    Alert.alert("Please fill in all fields")
                    return false
                } else {
                    submitActivityIndicator.hidden = false
                    submitActivityIndicator.startAnimating()
                    var query = PFQuery(className: "Users")
                    query.whereKey("email", equalTo: email.lowercaseString)
                    query.whereKey("passwordHash", equalTo: password.md5)
                    query.findObjectsInBackgroundWithBlock({
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            if let obj = objects as? [PFObject] where obj.count == 1 {
                                if let u = obj[0] as? UserTableRowItem {
                                    self.userItem = u
                                    self.performSegueWithIdentifier(Identifier.signInSegue, sender: nil)
                                }
                            } else {
                                Alert.alert("Wrong Email and password combination")
                                self.wrongCredentialAlert.hidden = false
                                self.emailText.text = ""
                                self.passwordText.text = ""
                            }
                            self.submitActivityIndicator.stopAnimating()
                            self.submitActivityIndicator.hidden = true
                        } else {
                            Alert.alert("Network error, please try again")
                        }
                    })
                    return false
                }
            }
        case Identifier.signUpSegue:
            return true
        default:
            return false
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifier.signInSegue:
            if let destVCNav = segue.destinationViewController as? UINavigationController,
                let destinationVC = destVCNav.topViewController as? ViewController {
                destinationVC.isLoggedIn = true
                destinationVC.user = userItem
            }
        case Identifier.signUpSegue:
            ()
        default:
            assertionFailure("UnKnown Segue Identifier")
        }        
    }
}
