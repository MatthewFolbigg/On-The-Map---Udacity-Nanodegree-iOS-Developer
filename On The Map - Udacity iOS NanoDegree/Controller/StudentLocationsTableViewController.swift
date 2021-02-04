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
        updateStudentLocations()
        setupTableViewPullToRefresh()
    }
    
    //MARK: Network Requests
    func updateStudentLocations() {
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
        tableView.reloadData()
    }
}

//MARK: Table View
extension StudentLocationsTableViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Locations"}
        else { return nil }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationTableCell") as! StudentLocationTableCell
        setCellUI(cell: cell, studentLocation: studentLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationController = storyboard?.instantiateViewController(identifier: "moreDetailViewController") as! MoreDetailViewController
        destinationController.studentLocation = studentLocations[indexPath.row]
        destinationController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    //MARK: Cell UI
    func setCellUI(cell: StudentLocationTableCell, studentLocation: StudentLocation) {
        cell.nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.locationLabel.text = studentLocation.locationString
        cell.pinImageView.tintColor = interfaceColours.red
        cell.arrowImageView.tintColor = interfaceColours.blue
        cell.locationLabel.textColor = interfaceColours.blue
    }
    
    //MARK: Pull to Refresh
    func setupTableViewPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        updateStudentLocations()
        tableView.refreshControl?.endRefreshing()
    }

}

