//
//  AccountViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
    
    @IBAction func logoutButtonDidTapped() {
        print("Logging Out ID: \(UdacityApiClient.currentLogin?.account.key ?? "ERROR: NO ID LOGGED IN")")
        UdacityApiClient.currentLogin = nil
        self.navigationController?.popToRootViewController(animated: true)
        print(UdacityApiClient.currentLogin ?? "User Logged Out")
    }
    
}
