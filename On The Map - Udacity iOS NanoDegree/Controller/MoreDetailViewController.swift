//
//  MoreDetailViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit

class MoreDetailViewController: UIViewController {

    //MARK: Outlets
    //loc lat long link update
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var longLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var lastUpdateLabel: UILabel!
    
    //MARK: Variables
    var studentLocation: StudentLocation?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: UI
    func setUI() {
        guard let studentLocation = self.studentLocation else {
            print("No Location passed by table view")
            return
        }
        self.navigationItem.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        latLabel.text = String(studentLocation.latitude)
        longLabel.text = String(studentLocation.longitude)
        locationLabel.text = studentLocation.createdAt
        urlLabel.text = studentLocation.url
        lastUpdateLabel.text = studentLocation.updatedAt
    }
    
}
