//
//  NetworkLayer.swift
//  SwiftSenpai-UnitTest-HttpRequest
//
//  Created by Lee Kah Seng on 06/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import Foundation

protocol NetworkLayerProtocol {
    func post(_ url: URL, parameters: Data, completion: (Result<Data, Error>) -> Void)
}

class NetworkLayer: NetworkLayerProtocol {
    
    /// Perform POST request
    /// - Parameters:
    ///   - url: Remote API endpoint
    ///   - parameters: JSON data
    ///   - completion: Completion handler that either return JSON data or error
    func post(_ url: URL, parameters: Data, completion: (Result<Data, Error>) -> Void) {
        
        // Create URL session
        // Create session task
        // ...
        // Perform POST request
        // ...
        // ...
        // Trigger completion handler
    }
}
