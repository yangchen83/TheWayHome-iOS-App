//
//  Alert.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/25/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func alert(message: String) {
        UIAlertView(title: "Message", message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
}
