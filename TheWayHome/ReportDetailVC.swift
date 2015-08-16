//
//  ReportDetailVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/25/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit
import MapKit

class ReportDetailVC: UIViewController {
    var report: ReportTableRowItem?
    var image: UIImage?
    
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.layer.cornerRadius = 5
            contactButton.layer.borderWidth = 1
            contactButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }

    @IBOutlet weak var reportTimeLabel: UILabel! {
        didSet {
            if let date = report?.createdAt {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var dateString = dateFormatter.stringFromDate(date)
                reportTimeLabel?.text = "Reported on \(dateString)"
            }
        }
    }
        
    @IBAction func contactReporterButton(sender: AnyObject) {
        let email = (report?["userEmail"] as? String)!
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    @IBOutlet weak var picButton: UIButton! {
        didSet{
            picButton.setImage(image, forState: .Normal)

        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let l = report?["location"] as! PFGeoPoint
            let location = CLLocation(latitude: l.latitude, longitude: l.longitude)
            MapUtil.centerMapOnLocation(mapView, location: location!)
        }
    }
    
    @IBOutlet weak var detailTextView: UITextView! {
        didSet {
            detailTextView?.text = report?.objectForKey("detail") as! String
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifier.showPhotoSegue {
            if let destVC = segue.destinationViewController as? PhotoVC {
                destVC.image = image
            }
        } else {
            assertionFailure("Unknown Segue")
        }
    }
}
