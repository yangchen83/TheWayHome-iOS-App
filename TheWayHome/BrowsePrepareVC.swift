//
//  BrowsePrepareVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/30/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit
import MapKit

class BrowsePrepareVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, SSRadioButtonControllerDelegate {
    var user: UserTableRowItem?
    var manager: CLLocationManager!
    var isChild: Bool?
    var isLost: Bool?
    var reports = [ReportTableRowItem]()
    var myReports = [ReportTableRowItem]()
    
    var location: CLLocation? {
        didSet {
            MapUtil.centerMapOnLocation(mapView, location: location!)
        }
    }
    
    var lostFoundRadioButtonController: SSRadioButtonsController?
    var childSeniorRadioButtonController: SSRadioButtonsController?

    @IBOutlet weak var myReportsButton: UIButton! {
        didSet {
            myReportsButton.layer.cornerRadius = 5
            myReportsButton.layer.borderWidth = 1
            myReportsButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myReportsActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func currentLocationButton(sender: AnyObject) {
        locationActivityIndicator.hidden = false
        locationActivityIndicator.startAnimating()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lostRadioButton: SSRadioButton!
    
    @IBOutlet weak var foundRadioButton: SSRadioButton!
    
    @IBOutlet weak var childrenRadioButton: SSRadioButton!
    
    @IBOutlet weak var seniorsRadioButton: SSRadioButton!
    
    @IBOutlet weak var browseButton: UIButton! {
        didSet {
            browseButton.layer.cornerRadius = 5
            browseButton.layer.borderWidth = 1
            browseButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    @IBOutlet weak var browseActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Search"
        
        if let u = user {
            myReportsButton.hidden = false
        } else {
            myReportsButton.hidden = true
        }
        
        locationActivityIndicator.hidden = true
        browseActivityIndicator.hidden = true
        myReportsActivityIndicator.hidden = true
        
        lostFoundRadioButtonController = SSRadioButtonsController(buttons: lostRadioButton, foundRadioButton)
        lostFoundRadioButtonController!.delegate = self
        lostFoundRadioButtonController!.shouldLetDeSelect = true
        
        childSeniorRadioButtonController = SSRadioButtonsController(buttons: childrenRadioButton, seniorsRadioButton)
        childSeniorRadioButtonController!.delegate = self
        childSeniorRadioButtonController!.shouldLetDeSelect = true
        
        locationTextField.delegate = self
    }
    
    // MARK: - Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as? CLLocation
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:{
            [unowned self]
            (placemarks, e) -> Void in
            if let error = e {
                Alert.alert("Error getting location name")
            } else {
                manager.stopUpdatingLocation()
                let placemark = placemarks.last as! CLPlacemark
                self.locationTextField.text = "\(placemark.locality), \(placemark.administrativeArea)"
                self.locationActivityIndicator.stopAnimating()
                self.locationActivityIndicator.hidden = true
            }
            })
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        locationActivityIndicator.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var addressString = textField.text
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    Alert.alert("Can't find the address please type again")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    self.location = placemark.location
                }
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        switch identifier ?? "MISSING" {
        case Identifier.goToBrowseViewSegue:
            if let isChildButton = childSeniorRadioButtonController?.selectedButton(),
                let isLostButton = lostFoundRadioButtonController?.selectedButton() {
                    isChild = (isChildButton == childrenRadioButton)
                    isLost = (isLostButton == lostRadioButton)
                    if let l = location {
                        let point = PFGeoPoint(location: l)
                        let query = PFQuery(className: "Reports")
                        query.whereKey("isChild", equalTo: isChild!)
                        query.whereKey("isLost", equalTo: isLost!)
                        query.whereKey("location", nearGeoPoint: point)
                        browseActivityIndicator.hidden = false
                        browseActivityIndicator.startAnimating()
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            if error == nil {
                                if let o = objects as? [ReportTableRowItem] {
                                    self.reports = o
                                    self.performSegueWithIdentifier(Identifier.goToBrowseViewSegue, sender: nil)
                                    self.browseActivityIndicator.hidden = true
                                    self.browseActivityIndicator.stopAnimating()
                                }
                            } else {
                                Alert.alert("Network error, please try again")
                            }
                        })
                        return false
                    } else {
                        Alert.alert("You need to specify a location")
                        return false
                    }
            } else {
                Alert.alert("You need to specify the category")
                return false
            }
            
        case Identifier.goToMyReportsSegue:
            if let u = user, let email = u["email"] as? String {
                let query = PFQuery(className: "Reports")
                query.whereKey("userEmail", equalTo: email)
                myReportsActivityIndicator.hidden = false
                myReportsActivityIndicator.startAnimating()
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if error == nil {
                        if let o = objects as? [ReportTableRowItem] {
                            self.myReports = o
                            self.performSegueWithIdentifier(Identifier.goToMyReportsSegue, sender: nil)
                            self.myReportsActivityIndicator.hidden = true
                            self.myReportsActivityIndicator.stopAnimating()
                        }
                    } else {
                        Alert.alert("Network error, please try again")
                    }
                })
            }
            return false
        default:
            assertionFailure("UnKnown Segue")
            return false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifier.goToBrowseViewSegue:
            if let destVC = segue.destinationViewController as? BrowseViewController {
                destVC.isLost = isLost
                destVC.isChild = isChild
                destVC.location = location
                destVC.reports = reports
            }
        
        case Identifier.goToMyReportsSegue:
            if let destVC = segue.destinationViewController as? ReportsTableVC {
                destVC.reports = myReports
            }
        
        default:
            assertionFailure("Unknown Segue")
        }
    }
}
