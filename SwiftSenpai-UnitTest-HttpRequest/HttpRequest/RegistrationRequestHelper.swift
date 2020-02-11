//
//  RegistrationRequestHelper.swift
//  SwiftSenpai-UnitTest-HttpRequest
//
//  Created by Lee Kah Seng on 06/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import Foundation

protocol RegistrationHelperProtocol {
    func register(_ username: String,
                  password: String,
                  completion: (Result<User, RegistrationRequestError>) -> Void)
}

class RegistrationRequestHelper: RegistrationHelperProtocol {
    
    private let networkLayer: NetworkLayerProtocol
    private let encryptionHelper: EncryptionHelperProtocol
    
    // Inject networkLayer and encryptionHelper during initialisation
    init(_ networkLayer: NetworkLayerProtocol, encryptionHelper: EncryptionHelperProtocol) {
        self.networkLayer = networkLayer
        self.encryptionHelper = encryptionHelper
    }
    
    func register(_ username: String,
                  password: String,
                  completion: (Result<User, RegistrationRequestError>) -> Void) {
        
        // Remote API URL
        let url =  URL(string: "https://api-call")!
        
        // Encrypt password using encryptionHelper
        let encryptedPassword = encryptionHelper.encrypt(password)
        
        // Encode post parameters to JSON data
        let parameters = ["username": username, "password": encryptedPassword]
        let encoder = JSONEncoder()
        let requestData = try! encoder.encode(parameters)
    
        // Perform POST request using network layer
        networkLayer.post(url, parameters: requestData) { (result) in
            
            switch result {
            case .success(let jsonData):
                
                // Create JSON decoder to decode response JSON to User object
                let decoder = JSONDecoder()
                
                // Convert JSON key from snake case to camel case
                // Ex: user_id --> userId
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let user = try? decoder.decode(User.self, from: jsonData) {
                    // Parsing JSON to user object successful
                    // Trigger completion handler with user object
                    completion(.success(user))
                    return
                } else if let error = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    // Parsing JSON to get error code
                    if let errorCode = error["error_code"] as? String {
                        // Error code available
                        // Use error code to identify the error
                        switch errorCode {
                        case "E001":
                            completion(.failure(.usernameAlreadyExists))
                            return
                        default:
                            break
                        }
                    }
                }
                
                // Failed to parse response JSON
                // Trigger completion handler with error
                completion(.failure(.unexpectedResponse))
                
            case .failure:
                // HTTP Request failed
                // Trigger completion handler with error
                completion(.failure(.requestFailed))
            }
        }
    }
}
