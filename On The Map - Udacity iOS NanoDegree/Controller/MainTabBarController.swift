//
//  MainTabBarController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    var accountButton: UIBarButtonItem!
    var addPinButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtonsForLoginStatus()
        navigationItem.titleView?.isHidden = true
    }

    func setNavigationBarButtons() {
        self.navigationItem.hidesBackButton = true

        accountButton = getAccountButton()
        self.navigationItem.leftBarButtonItem = accountButton
        addPinButton = getAddPinButton()
        self.navigationItem.rightBarButtonItem = addPinButton
    }

    func setUpBarButtons() {
        accountButton = getAccountButton()
        self.navigationItem.leftBarButtonItem = accountButton
        addPinButton = getAddPinButton()
        self.navigationItem.rightBarButtonItem = addPinButton

        setButtonsForLoginStatus()
    }

    func setButtonsForLoginStatus() {
        if UdacityApiClient.currentLogin == nil {
            addPinButton.isEnabled = false
        } else {
            addPinButton.isEnabled = true
        }
    }

    //MARK: Account Button
    func getAccountButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "person")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(accountButtonDidTapped))
        return button
    }

    @objc func accountButtonDidTapped() {
        if UdacityApiClient.currentLogin == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            let destination = storyboard?.instantiateViewController(identifier: "AccountViewController") as! AccountViewController
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    //MARK: Add Pin Button
    func getAddPinButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "mappin.and.ellipse")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addPinButtonDidTapped))
        return button
    }

    @objc func addPinButtonDidTapped() {
        print("Add Pin Tapped")
    }


}
