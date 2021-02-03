//
//  LoginViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 01/02/2021.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //MARK : Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    //MARK: Varibales
    var userSession: udacityLoginResponse?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
    }
    
    //MARK: Network Requests
    func login() {
        userSession = nil
        let user = createUserFromTextFields()
        UdacityApiClient.login(user: user, completion: handelLoginResponse(loginSuccess: error:))
    }
    
    //MARK: Network Completeion Handelers
    func handelLoginResponse(loginSuccess: Bool, error: Error?) -> Void {
        guard let loginResponse = UdacityApiClient.currentLogin else { return } //TODO: Handle login failure
        self.userSession = loginResponse
        performLoginSegue()
    }
    
    //MARK: Button Actions
    @IBAction func loginButtonDidTapped() {
        resignAllTextFields()
        login()
    }
    
    func performLoginSegue() {
        guard let userSession = userSession else { return }
        if userSession.account.registered {
            let destination = (storyboard?.instantiateViewController(identifier: "mainTabView"))!
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == usernameTextField.tag {
            passwordTextField.becomeFirstResponder()
            return true
        }
        
        if textField.tag == passwordTextField.tag {
            resignAllTextFields()
            return true
        }
        return true
    }
    
    func resignAllTextFields() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func setUpTextFields() {
        //Username
        usernameTextField.textContentType = .username
        usernameTextField.tag = 1
        
        //Password
        passwordTextField.textContentType = .password
        passwordTextField.tag = 2
    }
    
    func createUserFromTextFields() -> UdacityUserCredentials {
        UdacityUserCredentials(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
}
