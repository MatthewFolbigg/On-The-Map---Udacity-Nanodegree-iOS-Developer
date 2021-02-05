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
    @IBOutlet var layerView: UIView!
 
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: Set UI
    func setUI() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        view.backgroundColor = .white
        layerView.backgroundColor = .white
        pinImageView.tintColor = InterfaceColours.red
        //titleLabel.textColor =
        
        submitButton.layer.cornerRadius = 10
        submitButton.backgroundColor = InterfaceColours.blue
        submitButton.setTitleColor(.white, for: .normal)
        
    }
    
    
    //MARK: Create Student Location from Entered Text
    func getStudentLocationFromTextFields(completion: @escaping () -> Void) {
        var mapItem: MKMapItem?
        let search = createLocationSearch()
        search.start { (response, error ) in
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
        guard let mapItem = location else { return nil }
        guard let user = UdacityApiClient.currentUserData else { return nil }
        guard let login = UdacityApiClient.currentLogin?.account else { return nil }
        guard let userUrl = URL(string: self.mediaLinkTextField.text ?? "") else { return nil }
       
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
    
    func post(studentLocation: StudentLocation, completion: @escaping () -> Void) {
        ParseApiClient.postStudentLocation(studentLocation: studentLocation) { (error) in
            print("ADD COMPLETE")
            completion()
        }
    }
    
    //MARK: Button Actions
    @IBAction func submitButtonDidTapped() {
        getStudentLocationFromTextFields() { () in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
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
