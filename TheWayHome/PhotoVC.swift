//
//  PhotoVC.swift
//  TheWayHome
//
//  Created by Yang Chen on 7/31/15.
//  Copyright (c) 2015 Yang Chen. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UIScrollViewDelegate {
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 6.0
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
}
