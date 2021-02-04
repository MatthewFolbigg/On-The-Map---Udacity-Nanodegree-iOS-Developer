//
//  StudentLocationMapViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let annotations = createMapPins()
        addToMap(annotations: annotations)
    }
    
    func addToMap(annotations: [MKPointAnnotation]) {
        for annotaion in annotations {
            mapView.addAnnotation(annotaion)
        }
    }
    
    func createMapPins() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        
        guard let currentLocations = ParseApiClient.currentLocations else {
            return annotations
        }
        
        for location in currentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = location.latitude
            annotation.coordinate.longitude = location.longitude
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.locationString
            
            annotations.append(annotation)
        }
        return annotations
    }
    
}

extension StudentLocationMapViewController: MKMapViewDelegate {
    
    
}
