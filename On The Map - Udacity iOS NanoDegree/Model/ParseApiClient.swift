//
//  ParseApiClient.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation

class ParseApiClient {
    
    
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
                return
            }
            let decoder = JSONDecoder()
            do {
            let responseObject = try decoder.decode(StudentLocationsResults.self, from: data)
                let studentLocations = responseObject.studentLocations
                DispatchQueue.main.async {
                    completion(studentLocations, nil)
                }
            } catch {
                print("failure to decode to StudentLocationsResults")
                print(error.localizedDescription)
                //TODO: Handle failure to decode here (Unexpected response object)
            }
        }
        task.resume()
    }
    

}
