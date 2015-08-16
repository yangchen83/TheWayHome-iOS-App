//
//  BrowseViewController.swift
//  Chen-Yang-Prob1-StoryBoard
//
//  Created by Yang Chen on 7/22/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var isChild: Bool?
    var isLost: Bool?
    var location: CLLocation?
    var reports = [ReportTableRowItem]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = ""
        if isLost! {
            title += "Lost"
        } else {
            title += "Found"
        }
        if isChild!{
            title += " Children"
        } else {
            title += " Seniors"
        }
        self.navigationItem.title = title
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        photoCollectionView!.delegate = self
        photoCollectionView!.dataSource = self
        photoCollectionView!.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0)
    }
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reports.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let imageFile = reports[indexPath.row]["image"] as! PFFile
        cell.setImage(imageFile)
        let myPoint = PFGeoPoint(location: location!)
        let reportPoint = reports[indexPath.row]["location"] as! PFGeoPoint
        let distance = myPoint.distanceInMilesTo(reportPoint)
        let formatDistance = NSString(format: "%.1f", distance)
        cell.distanceLabel!.text = "\(formatDistance) miles"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let flexSize = sqrt(Double(screenWidth * screenHeight) / (Double(33)))
            return CGSize(width: flexSize , height: flexSize)
        }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
           return CGFloat(0)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
         return CGFloat(0)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Identifier.showDetailReportSegue {
            if let destVC = segue.destinationViewController as? ReportDetailVC,
            let cell = sender as? CollectionViewCell,
            let indexPath = photoCollectionView.indexPathForCell(cell) {
                destVC.report = reports[indexPath.row] as ReportTableRowItem
                destVC.image = cell.cellPic.image
            }
        }
    }
}
