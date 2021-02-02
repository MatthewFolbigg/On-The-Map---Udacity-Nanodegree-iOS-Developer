//
//  StudentLocationsTableViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation
import UIKit

class StudentLocationsTableViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    var studentLocations: [StudentLocation] = []
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = interfaceColours.paleGreen
        tableView.backgroundColor = interfaceColours.paleGreen
        ParseApiClient.getStudentLocations(completion: handleGetStudentLocations(locationsArray:error:))
    }
    
    //MARK: Network Completeion Handelers
    func handleGetStudentLocations(locationsArray: [StudentLocation]?, error: Error?) -> Void {
        guard let locations = locationsArray else {
            //TODO: Handle this properly with passed error
            print("error")
            return
        }
        self.studentLocations = locations
        self.tableView.reloadData()
    }
    
}

//MARK: Table View
extension StudentLocationsTableViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = studentLocations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationTableCell") as! StudentLocationTableCell
        cell.nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.locationLabel.text = studentLocation.locationString
        cell.pinImageView.tintColor = interfaceColours.red
        cell.backgroundColor = interfaceColours.paleGreen
        cell.locationLabel.textColor = interfaceColours.blue
        return cell
    }
        
    
}
