//
//  AppDelegate.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/15/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // set up Parse
        Parse.setApplicationId(Identifier.parseApplicationID, clientKey: Identifier.parseClinetKey)
        
        return true
    }

}

