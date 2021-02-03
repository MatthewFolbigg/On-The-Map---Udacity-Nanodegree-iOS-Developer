//
//  MainTabBarController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarButtons()
    }
    
    func setNavigationBarButtons() {
        self.navigationItem.hidesBackButton = true
        let logoutButton = getLogoutButton()
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    func getLogoutButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "arrow.uturn.backward.circle")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(logoutButtonDidTapped))
        return button
    }
    
    @objc func logoutButtonDidTapped() {
        print("Log OUT")
        UdacityApiClient.currentLogin = nil
        self.navigationController?.popViewController(animated: true)
    }
    
}
