//
//  AddPinViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 05/02/2021.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    //MARK: IB Outlets
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mediaLinkTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var pinImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var postActivityController: UIActivityIndicatorView!
 
    //MARK: Variables
    
    //MARK: Errors
    enum Errors {
        
        case missingInput
        case geocodeFailed
        case networkError
        case generic
        
        var nsError: NSError {
            switch self {
            case .missingInput : return NSError(domain: "Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Make sure to enter a location and website"])
            case .geocodeFailed : return NSError(domain: "Location Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to find a location from the eneterd text"])
            case .networkError : return NSError(domain: "Network Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to post your location. Check your network connection"])
            case .generic : return NSError(domain: "Unknown Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Something is missing, please sign in again and try again"])
            }
            
        }
    }
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: Set UI
    func setUI() {
        setTransparentNavigationBar()
        postActivityController.alpha = 0
        pinImageView.tintColor = InterfaceColours.red
        
        submitButton.layer.cornerRadius = 10
        submitButton.backgroundColor = InterfaceColours.blue
        submitButton.setTitleColor(.white, for: .normal)
        
    }
    
    func setTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    //MARK: Create Student Location from Entered Text
    func getStudentLocationFromTextFields(completion: @escaping () -> Void) {
        activiyIndicatorIs(active: true)
        var mapItem: MKMapItem?
        let search = createLocationSearch()
        search.start { (response, error ) in
            if let error = error as NSError? {
                if error.domain .contains("MK") {
                    let mapError = Errors.geocodeFailed.nsError
                    self.handelPostError(error: mapError)
                } else {
                    let networkError = Errors.networkError.nsError
                    self.handelPostError(error: networkError)
                }
                return
            }
            guard let response = response else { return }
            mapItem = response.mapItems[0]
            guard let studentLocation = self.createStudentLocation(location: mapItem) else { return }
            self.post(studentLocation: studentLocation) {() in
                completion()
            }
        }
    }
    
    func createLocationSearch() -> MKLocalSearch {
        let userLocationString = locationTextField.text ?? ""
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = userLocationString
        let search = MKLocalSearch(request: searchRequest)
        return search
    }

    func createStudentLocation(location: MKMapItem?) -> StudentLocation? {
        guard let mapItem = location,
              let user = UdacityApiClient.currentUserData,
              let login = UdacityApiClient.currentLogin?.account,
              let userUrl = URL(string: self.mediaLinkTextField.text ?? "")
        else {
            let error = Errors.generic.nsError
            handelPostError(error: error)
            activiyIndicatorIs(active: false)
            return nil
        }
       
        let studentLocation = StudentLocation(
            firstName: user.firstName,
            lastName: user.lastName,
            longitude: mapItem.placemark.coordinate.longitude,
            latitude: mapItem.placemark.coordinate.latitude,
            locationString: mapItem.name!,
            url: userUrl.absoluteString,
            identifierKey: login.key,
            objectID: "",
            createdAt: "",
            updatedAt: "")
        
        return studentLocation
    }
    
    //MARK: POST Request
    func post(studentLocation: StudentLocation, completion: @escaping () -> Void) {
        print("Post Started")
        ParseApiClient.postStudentLocation(studentLocation: studentLocation) { (error) in
            print("ADD COMPLETE")
            if let error = error {
                self.handelPostError(error: error)
                return
            } else {
                completion()
            }
            self.activiyIndicatorIs(active: true)
        }
    }
    
    //MARK: Errors
    func handelPostError(error: Error) {
        activiyIndicatorIs(active: false)
        alertUserTo(error: error as NSError)
    }
    
    func alertUserTo(error: NSError) {
        let alertController = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkForUserInput() -> Bool{
        let locationString = locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let websiteString  = mediaLinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if locationString == "" || websiteString == "" {
            return false
        } else {
            return true
        }
    }
    
    func handelMissingInput() {
        let error = Errors.missingInput.nsError
        handelPostError(error: error)
    }
    
    
    //MARK: Button Actions
    @IBAction func submitButtonDidTapped() {
        resignAllTextFields()
        if !checkForUserInput() { handelMissingInput() }
        getStudentLocationFromTextFields() { () in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Activity Indicator
    func activiyIndicatorIs(active: Bool) {
        //Animated Changes
        UIView.animate(withDuration: 0.2) {
            if active {
                self.postActivityController.alpha = 1
            } else {
                self.postActivityController.alpha = 0
            }
        }
        //Non Animated Changes
        if active {
            self.postActivityController.startAnimating()
        } else {
            self.postActivityController.stopAnimating()
        }
    }
}
//MARK: TextFields
extension AddPinViewController: UITextFieldDelegate {
    
    func resignAllTextFields() {
        locationTextField.resignFirstResponder()
        mediaLinkTextField.resignFirstResponder()
    }
    
    func clearAllTextFields() {
        locationTextField.text = nil
        mediaLinkTextField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
