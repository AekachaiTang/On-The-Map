//
//  UdacityClient.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation

class UdacityClient {
    
    
    static let shared = UdacityClient()
    let responseHeaderLength = 5
    struct Url {
        static let session = "https://onthemap-api.udacity.com/v1/session"
        static let users = "https://onthemap-api.udacity.com/v1/users/"
    }
    struct UdacityResponseKey {
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }

    let session = URLSession.shared
    var udacitySessionID: String? = nil
    var udacityAccountKey: String? = nil
    var udacityFirstName: String? = nil
    var udacityLastName: String? = nil
    
  
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ displayError: String?) -> Void) {
        let requestBody = UdacityLoginRequest.get(email, password)
        let request = getLoginRequest(withBody: requestBody)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            self.handleLoginTaskCompletion(data, response, error, completion)
        }
        task.resume()
    }
    
    
    func logout(completion: @escaping (_ success: Bool, _ displayError: String?) -> Void) {
          
        let request = NSMutableURLRequest(url: URL(string: Url.session)!)
        request.httpMethod = WebMethod.delete
        
        //add anti-XSRF cookie so Udacity server knows this is the client that originally logged in
        if let xsrfCookie = Utilities.getCookie(withKey: Cookie.xsrfToken) {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: RequestKey.xxsrfToken)
        }
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let responseHandler = ResponseHandler(data, response, error)
            
            if let responseError = responseHandler.getResponseError() {
                completion(false, responseError)
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    private func getLoginRequest<T: Encodable>(withBody body: T) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: Url.session)!)
        request.httpMethod = WebMethod.post
        request.addValue(RequestValue.jsonType, forHTTPHeaderField: RequestKey.accept)
        request.addValue(RequestValue.jsonType, forHTTPHeaderField: RequestKey.contentType)
        request.httpBody = JSONParser.stringify(body).data(using: String.Encoding.utf8)
        return request
    }
    
    private func handleLoginTaskCompletion(_ data: Data?,
                                           _ response: URLResponse?,
                                           _ error: Error?,
                                           _ completion: @escaping (_ success: Bool, _ displayError: String?) -> Void) {
        
        let responseHandler = ResponseHandler(data, response, error)
        
        if let responseError = responseHandler.getResponseError() {
            completion(false, responseError)
            return
        }
        
        let subsetResponseData = subsetResponse(data!)
        
        guard let response:UdacityLoginResponse = JSONParser.decode(subsetResponseData) else {
            completion(false, DisplayError.unexpected)
            return
        }
        
        udacityAccountKey = response.account.key
        udacitySessionID = response.session.id
        getUserDetails(completion)
    }
    
    private func getUserDetails(_ completion: @escaping (_ success: Bool, _ displayError: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Url.users + udacityAccountKey!)!)
        print(request)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let responseHandler = ResponseHandler(data, response, error)
           
            if let responseError = responseHandler.getResponseError() {
                completion(false, responseError)
                return
            }
            
            let subsetResponseData = self.subsetResponse(data!)
            
            
            guard let parsedResponse = JSONParser.deserialize(subsetResponseData) else {
                completion(false, DisplayError.unexpected)
                return
            }
            
            guard let responseDictionary = parsedResponse as? [String: AnyObject] else {
                completion(false, DisplayError.unexpected)
                return
            }
            
            guard let user = responseDictionary[UdacityResponseKey.user] as? [String: AnyObject] else {
                completion(false, DisplayError.unexpected)
                return
            }
            
            guard let firstName = user[UdacityResponseKey.firstName] as? String else {
                completion(false, DisplayError.unexpected)
                return
            }
            
            guard let lastName = user[UdacityResponseKey.lastName] as? String else {
                completion(false, DisplayError.unexpected)
                return
            }
            
            self.udacityFirstName = firstName
            self.udacityLastName = lastName
            
            completion(true, nil)
        }
        task.resume()
    }
    
    private func subsetResponse(_ data: Data) -> Data {
        let range = responseHeaderLength..<data.count
        return data.subdata(in: range)
    }
    
    private struct UdacityLoginRequest: Codable {
        private let udacity : Udacity
        
        private struct Udacity : Codable {
            let username: String
            let password: String
        }
        
        static func get(_ username: String, _ password: String) -> UdacityLoginRequest {
            return UdacityLoginRequest(udacity: Udacity(username: username, password: password))
        }
    }
 
    private struct UdacityLoginResponse: Codable {
        
        let account: Account
        let session: Session
        
        struct Account: Codable {
            let registered: Bool
            let key: String
        }
        
        struct Session: Codable {
            let id: String
            let expiration: String
        }
    }
}
