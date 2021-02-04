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
    
    //MARK: Outlets & UI Elements
    @IBOutlet var mapView: MKMapView!
    var accountButton: UIBarButtonItem!
    var addPinButton: UIBarButtonItem!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
        mapView.mapType = .standard
        askToLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let annotations = createMapPins()
        addToMap(annotations: annotations)
        setButtonsForLoginStatus()
    }
    
    //MARK: Ask to Login on Initial load
    func askToLogin() {
        let destination = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        DispatchQueue.main.async {
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    //MARK: Bar Buttons
    func getAddPinButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "mappin.and.ellipse")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addPinButtonDidTapped))
        return button
    }
    
    func getAccountButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "person")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(accountButtonDidTapped))
        return button
    }
    
    func setUpBarButtons() {
        accountButton = getAccountButton()
        self.navigationItem.leftBarButtonItem = accountButton
        addPinButton = getAddPinButton()
        self.navigationItem.rightBarButtonItem = addPinButton
        setButtonsForLoginStatus()
    }

    func setButtonsForLoginStatus() {
        //Disables adding pins if user skipped log in
        if UdacityApiClient.currentLogin == nil {
            addPinButton.isEnabled = false
        } else {
            addPinButton.isEnabled = true
        }
    }
    
    //MARK: Bar Button Actions
    @objc func accountButtonDidTapped() {
        if UdacityApiClient.currentLogin == nil {
            let destination = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.present(destination, animated: true, completion: nil)
        } else {
            let destination = storyboard?.instantiateViewController(identifier: "AccountViewController") as! AccountViewController
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    @objc func addPinButtonDidTapped() {
        print("Add Pin Tapped")
        //TODO: Move to new VC for adding a Map Pin
        guard let user = UdacityApiClient.currentUserData else { return }
        guard let login = UdacityApiClient.currentLogin?.account else { return }
        let testLocation = StudentLocation(firstName: user.firstName, lastName: user.lastName, longitude: 74.2, latitude: 7.42, locationString: "United Kingdom", url: "www.apple.com", identifierKey: login.key, objectID: "Test", createdAt: "Test", updatedAt: "Test")
        ParseApiClient.postStudentLocation(studentLocation: testLocation) { (error) in
            print("ADD COMPLETE")
        }
    }
    
    //MARK: Map View
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
