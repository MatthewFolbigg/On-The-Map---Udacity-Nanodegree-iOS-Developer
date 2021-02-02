//
//  LoginViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 01/02/2021.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseApiClient.getStudentLocations { (locations, error) in
            if let locations = locations {
                for item in locations {
                    print(item)
                }
            } else {
                print("error unwrapping locations array")
            }
        }
    }
    
}
