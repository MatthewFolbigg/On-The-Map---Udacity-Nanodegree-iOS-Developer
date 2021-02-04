//
//  ParseApiClient.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation

class ParseApiClient {
    
    static var currentLocations: [StudentLocation]?
    
    //MARK: Endpoints
    enum Endpoints {
        static let baseUrl: String = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let queryOrderUpdateTime: String = "?order=-updatedAt"
        
        case getStudentLocations
        
        var url: URL {
            URL(string: self.urlString)!
        }
        
        //MARK: Endpoint construction 
        var urlString: String {
            switch self {
            case .getStudentLocations:
                return Endpoints.baseUrl + Endpoints.queryOrderUpdateTime
                
            }
        }
    }
    
    //MARK: GET Resquests
    class func getStudentLocations(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let endpoint = Endpoints.getStudentLocations.url
        let task = URLSession.shared.dataTask(with: endpoint) { (data, response, error)
            in
            guard let data = data else {
                //TODO: Handle failure to get response here
                print("failure to get response from getStudentLocations")
                if let error = error { print(error) }
                return
            }
            let decoder = JSONDecoder()
            do {
            let responseObject = try decoder.decode(StudentLocationsResults.self, from: data)
                let studentLocations = responseObject.studentLocations
                DispatchQueue.main.async {
                    self.currentLocations = studentLocations
                    completion(studentLocations, nil)
                }
            } catch {
                //TODO: Handle failure to decode here (Unexpected response object)
                print("failure to decode to StudentLocationsResults")
                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: POST Resquests
    class func postStudentLocation(studentLocation: StudentLocation, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let studentLocationJSON = try encoder.encode(studentLocation)
            request.httpBody = studentLocationJSON
        } catch {
            print(error)
            print("Unable to encode JSON")
            //TODO: Handel this error
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if data == nil {
                //TODO: Handel this error
                print("No data returned")
                return
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
        
        
    }
    

}
