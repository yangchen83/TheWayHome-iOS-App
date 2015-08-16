//
//  MapUtil.swift
//  
//
//  Created by Yang Chen on 8/3/15.
//
//

import Foundation
import MapKit

class MapUtil {
    static func centerMapOnLocation(mapView: MKMapView, location: CLLocation) {
        mapView.removeAnnotations(mapView.annotations)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            Identifier.mapRegionRadius * 2.0, Identifier.mapRegionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = location.coordinate
        mapView.addAnnotation(objectAnnotation)
    }

}

