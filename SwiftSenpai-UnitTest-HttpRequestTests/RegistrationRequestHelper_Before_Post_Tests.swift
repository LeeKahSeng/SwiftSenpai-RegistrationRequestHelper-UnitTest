//
//  RegistrationRequestHelper_Before_Post_Tests.swift
//  SwiftSenpai-UnitTest-HttpRequestTests
//
//  Created by Lee Kah Seng on 07/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import XCTest
@testable import SwiftSenpai_UnitTest_HttpRequest

// MARK:- Test cases
class RegistrationRequestHelper_Before_Post_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Assert configurations and parameters for the post request are correct
    func testBeforePostRequest() {
        
        /* Arrange */
        // Create dependencies
        let username = "swift-senpai"
        let password = "abcd1234"
        let mockNetworkLayer = MockNetworkLayer()
        let mockEncryptionHelper = MockEncryptionHelper()
        
        // Set expectation
        let exp = expectation(description: "Post request completed")
        
        
        /* Act */
        // Perform post request
        let requestHelper = RegistrationRequestHelper(mockNetworkLayer, encryptionHelper: mockEncryptionHelper)
        requestHelper.register(username, password: password) { (result) in
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        
        /* Assert */
        // Assert post url is correct
        let expectedUrl = URL(string: "https://api-call")!
        let actualUrl = mockNetworkLayer.postUrl
        XCTAssertEqual(actualUrl, expectedUrl)
        
        // Assert encrypt is called
        XCTAssertTrue(mockEncryptionHelper.encryptCalled)
        
        // Assert post parameters are correct
        let encryptedPassword = mockEncryptionHelper.encrypt(password)
        var expectedRequestJson = """
                                    {
                                      "username": "\(username)",
                                      "password": "\(encryptedPassword)"
                                    }
                                  """
        expectedRequestJson.trimJSON()
        
        let actualRequestData = mockNetworkLayer.requestData
        let actualRequestJson = String(data: actualRequestData, encoding: .utf8)!
        XCTAssertEqual(expectedRequestJson, actualRequestJson)
    }
}


// MARK:- Test doubles
// Reference: https://swiftsenpai.com/testing/test-doubles-in-swift/
extension RegistrationRequestHelper_Before_Post_Tests {
    
    class MockNetworkLayer: NetworkLayerProtocol {
        
        var postUrl = URL(string: "http://dummy.com")!
        var requestData = Data()
        
        func post(_ url: URL,
                  parameters: Data,
                  completion: (Result<Data, Error>) -> Void) {
            
            // Keep track on the given url and parameters value
            postUrl = url
            requestData = parameters
            
            // Trigger completion with dummy data
            completion(.success(Data()))
        }
    }

    class MockEncryptionHelper: EncryptionHelperProtocol {
        
        var encryptCalled = false
        
        func encrypt(_ value: String) -> String {
            // Set flag to true When encrypt(_:) is called
            encryptCalled = true
            
            // Return a dummy value (this value is not important)
            return "1234567890"
        }
    }
}

// MARK:- Utilities
extension String {
    mutating func trimJSON() {
        self = self.replacingOccurrences(of: "\n", with: "")
        self = self.replacingOccurrences(of: " ", with: "")
    }
}
