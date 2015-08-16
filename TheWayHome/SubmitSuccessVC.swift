//
//  SubmitSuccessVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/27/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class SubmitSuccessVC: UIViewController {
    var isLost: Bool?
    var user: UserTableRowItem?

    @IBOutlet weak var forFoundLabel: UILabel! {
        didSet {
            if isLost! {
                forFoundLabel.hidden = true
            }
        }
    }
    
    @IBOutlet weak var forLostLabel: UILabel! {
        didSet {
            if !isLost! {
                forLostLabel.hidden = true
            }
        }
    }
    
    @IBOutlet weak var backToHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backToHomeButton.layer.cornerRadius = 5
        backToHomeButton.layer.borderWidth = 1
        backToHomeButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifier.backToHomeSegue {
            if let destVCNav = segue.destinationViewController as? UINavigationController,
                let destVC = destVCNav.topViewController as? ViewController,
                let u = user {
                    destVC.user = u
                    destVC.isLoggedIn = true
            }
        } else {
            assertionFailure("Unkown Segue")
        }
    }
}
