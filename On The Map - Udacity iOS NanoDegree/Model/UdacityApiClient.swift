//
//  UdacityApiClient.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation

class UdacityApiClient {
    
    static var currentLogin: udacityLoginResponse? = nil
    
    //MARK: Endpoints
    enum EndPoints {
        
        static let baseUrl: String = "https://onthemap-api.udacity.com/v1"
        static let userSessionUrl: String = "/session"
        
        case login
        
        var url: URL {
            URL(string: self.urlString)!
        }
        
        var urlString: String {
            switch self {
            case .login:
                return "\(EndPoints.baseUrl)\(EndPoints.userSessionUrl)"
            }
        }
    }
    
    //MARK: Login POST Request
    static func login(user: UdacityUserCredentials, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let loginData = UdacityLoginData(udacity: user)
            let data = try encoder.encode(loginData)
            request.httpBody = data
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
            }
            //TODO: Handle error encoding data
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                //TODO: Handle no data returned from request
                DispatchQueue.main.async {
                    completion(false, error)
                }
                print("no data recived back from login put")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let loginResponse = try decoder.decode(udacityLoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.currentLogin = loginResponse
                    completion(true, nil)
                }
            } catch {
                //TODO: Handle not able to decode user response
                DispatchQueue.main.async {
                    completion(false, error)
                }
                print("not able to decode login response")
                return
            }
        }
        task.resume()
    }
    
}
