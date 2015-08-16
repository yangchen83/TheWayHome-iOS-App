//
//  CollectionViewCell.swift
//  Chen-Yang-Prob1-StoryBoard
//
//  Created by Yang Chen on 7/22/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellPic: UIImageView!
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setImage(imageFile: PFFile) {
        imageActivityIndicator.hidden = false
        imageActivityIndicator.startAnimating()
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil {
                if let d = data {
                    self.cellPic.image = UIImage(data: d)
                    self.imageActivityIndicator.hidden = true
                    self.imageActivityIndicator.stopAnimating()
                }
            } else {
                Alert.alert("Error getting image, please try again")
            }
        }
    }

}
