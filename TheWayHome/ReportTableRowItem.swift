//
//  ReportTableRowItem.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/31/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import Foundation

class ReportTableRowItem : PFObject, PFSubclassing {
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Reports"
    }
}