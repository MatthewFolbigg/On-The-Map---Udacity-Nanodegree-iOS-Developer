//
//  LoginViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 01/02/2021.
//  Udacity Logo and Text are not my own and are from Udacity. They are beign used for Educational purposes only

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    //MARK: Varibales
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUI()
    }
    
    //MARK: UI Setup
    func setUI() {
        view.backgroundColor = InterfaceColours.udacityBackground
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = InterfaceColours.udacityBlue
        loginButton.setTitleColor(InterfaceColours.udacityBackground, for: .normal)
        skipButton.setTitleColor(InterfaceColours.udacityBlue, for: .normal)
    }
    
    //MARK: Network Requests
    func login() {
        UdacityApiClient.removeCurrentLoginData()
        let user = createUserFromTextFields()
        UdacityApiClient.login(user: user, completion: handelLoginResponse(loginSuccess: error:))
    }
    
    //MARK: Network Completeion Handelers
    func handelLoginResponse(loginSuccess: Bool, error: Error?) -> Void {
        if UdacityApiClient.currentLogin == nil {
            return //TODO: Handle login failure
        } else {
            guard let userID = UdacityApiClient.currentLogin?.account.key else {
                //TODO: Handel this error
                return
            }
            print(userID)
            UdacityApiClient.getUserData(userID: userID) { (error) in
                self.performLoginSegue()
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func loginButtonDidTapped() {
        resignAllTextFields()
        login()
    }
    
    func performLoginSegue() {
        passwordTextField.text = nil
        let destination = (storyboard?.instantiateViewController(identifier: "mainTabView"))!
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func skipButtonDidTapped() {
        resignAllTextFields()
        UdacityApiClient.removeCurrentLoginData()
        clearTextFields()
        let destination = (storyboard?.instantiateViewController(identifier: "mainTabView"))!
        navigationController?.pushViewController(destination, animated: true)
        //TODO: Add Warning about no login
    }
    
}

//MARK: Text Fields
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
    
    func clearTextFields() {
        usernameTextField.text = nil
        passwordTextField.text = nil
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
