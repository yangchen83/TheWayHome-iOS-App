//
//  ReportVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/24/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices
import MapKit

class ReportVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SSRadioButtonControllerDelegate, UITextViewDelegate {
    var user: UserTableRowItem?
    var report: ReportTableRowItem = ReportTableRowItem()
    var location: CLLocation? {
        didSet {
            MapUtil.centerMapOnLocation(mapView, location: location!)
        }
    }
    var detail: String?
    var photo: UIImage?
    var lostFoundRadioButtonController: SSRadioButtonsController?
    var childSeniorRadioButtonController: SSRadioButtonsController?

    let picker = UIImagePickerController()
    var manager:CLLocationManager!
    
    let mediaTypes = [kUTTypeImage]

    @IBOutlet weak var uploadPhotoButton: UIButton!
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    @IBOutlet weak var submitReportButton: UIButton! {
        didSet {
            submitReportButton.layer.cornerRadius = 5
            submitReportButton.layer.borderWidth = 1
            submitReportButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var submitActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailText: UITextView!
    
    @IBOutlet weak var lostRadioButton: SSRadioButton!
    
    @IBOutlet weak var foundRadioButton: SSRadioButton!
    
    @IBOutlet weak var childRadioButton: SSRadioButton!
    
    @IBOutlet weak var seniorRadioButton: SSRadioButton!
    
    @IBAction func useCurrentLocationButton(sender: AnyObject) {
        locationActivityIndicator.hidden = false
        locationActivityIndicator.startAnimating()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .Camera
        picker.cameraCaptureMode = .Photo
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func chooseFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailText.delegate = self
        
        locationActivityIndicator.hidden = true
        submitActivityIndicator.hidden = true
        
        lostFoundRadioButtonController = SSRadioButtonsController(buttons: lostRadioButton, foundRadioButton)
        lostFoundRadioButtonController!.delegate = self
        lostFoundRadioButtonController!.shouldLetDeSelect = true
        
        childSeniorRadioButtonController = SSRadioButtonsController(buttons: childRadioButton, seniorRadioButton)
        childSeniorRadioButtonController!.delegate = self
        childSeniorRadioButtonController!.shouldLetDeSelect = true
        
        
        locationText.delegate = self
        picker.delegate = self
        
        let dev = UIDevice.currentDevice()
        if dev.model == "iPhone Simulator" {
            uploadPhotoButton.enabled = false
            uploadPhotoButton.setTitle("No camera on simulator", forState: .Disabled)
            uploadPhotoButton.sizeToFit()
        }
    }
    
    
    // MARK: - Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as? CLLocation
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:{
            [unowned self]
            (placemarks, e) -> Void in
                        if let error = e {
                            Alert.alert("Error getting city name")
                        } else {
                            manager.stopUpdatingLocation()
                            let placemark = placemarks.last as! CLPlacemark
                            self.locationText.text = "\(placemark.locality), \(placemark.administrativeArea)"
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
    
    // MARK: - TextView Delegate
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 150)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        animateViewMoving(false, moveValue: 150)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    // MARK: - ImagePicker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            photo = image
            if picker.sourceType == .Camera {
                UIImageWriteToSavedPhotosAlbum(image, self, "verifySaved:didFinishSavingWithError:contextInfo:", nil)
            }
        }
        else {
            Alert.alert("No image was picked somehow!")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func verifySaved(image: UIImage, didFinishSavingWithError: NSError, contextInfo: UnsafeMutablePointer<Void>) {
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        switch identifier ?? "MISSING" {
        case Identifier.submitReportSegue:
                if let u = user {
                    if let l = location {
                        if let p = photo {
                            if let isChildButton = childSeniorRadioButtonController?.selectedButton(),
                                let isLostButton = lostFoundRadioButtonController?.selectedButton() {
                                    report["userEmail"] = u.userEmail
                                    report["isChild"] = (isChildButton == childRadioButton)
                                    report["isLost"] = (isLostButton == lostRadioButton)
                                    report["location"] = PFGeoPoint(location: l)
                                    let imageData = UIImageJPEGRepresentation(p, 0.5)
                                    let imageFile = PFFile(data: imageData)
                                    report["image"] = imageFile
                                    report["detail"] = detailText.text
                                    submitActivityIndicator.hidden = false
                                    submitActivityIndicator.startAnimating()
                                    report.saveInBackgroundWithBlock(){
                                        (succeeded: Bool, error: NSError?) -> Void in
                                        self.submitActivityIndicator.stopAnimating()
                                        self.submitActivityIndicator.hidden = true
                                        if succeeded {
                                            self.performSegueWithIdentifier(Identifier.submitReportSegue, sender: self.submitReportButton)
                                        } else {
                                            Alert.alert("Submission error. Please try again")
                                        }
                                    }
                                    return false
                                } else {
                                    Alert.alert("Please apecify a category")
                                    return false
                                }
                            } else {
                                Alert.alert("Please choose a photo")
                                return false
                            }
                        } else {
                            Alert.alert("Please specify a location")
                            return false
                        }
                    } else {
                        assertionFailure("user not signed in")
                        return false
                    }
        default:
            assertionFailure("Unknown Segue Identifier")
            return false
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifier.submitReportSegue:
            if let destVC = segue.destinationViewController as? SubmitSuccessVC {
                destVC.isLost = report["isLost"] as? Bool
                destVC.user = user
            }
        default:
            assertionFailure("Unknown Segue")
        }
    }

}
