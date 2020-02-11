//
//  RegistrationRequestHelper_After_Post_Tests.swift
//  SwiftSenpai-UnitTest-HttpRequestTests
//
//  Created by Lee Kah Seng on 07/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import XCTest
@testable import SwiftSenpai_UnitTest_HttpRequest

class RegistrationRequestHelper_After_Post_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Assert that the parsing of User object from JSON is working correctly
    func testParseUserObject() {
        
        /* Arrange */
        // Create dependencies
        let stubNetworkLayer = StubSuccessNetworkLayer()
        let dummyEncryptionHelper = DummyEncryptionHelper()

        // Set expectation
        let exp = expectation(description: "Post request completed")

        
        /* Act */
        // Perform post request
        var postResult: Result<User, RegistrationRequestError>!
        
        let requestHelper = RegistrationRequestHelper(stubNetworkLayer, encryptionHelper: dummyEncryptionHelper)
        requestHelper.register("dummy-username", password: "dummy-password") { (result) in

            // Capture post result
            postResult = result
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        
        /* Assert */
        let actualUser = try? postResult.get()
        let expectedUser = User(userId: 1001, username: "swift-senpai")
        
        // Assert user ID is correct
        XCTAssertEqual(expectedUser.userId, actualUser?.userId)
        
        // Assert username is correct
        XCTAssertEqual(expectedUser.username, actualUser?.username)
        
        // Assert email & phone is nil
        XCTAssertNil(actualUser?.email)
        XCTAssertNil(actualUser?.phone)
    }
    
    /// Assert that the unexpected response error will trigger
    func testUnexpectedResponse() {
        
        /* Arrange */
        // Create dependencies
        let stubNetworkLayer = StubUnexpectedResNetworkLayer()
        let dummyEncryptionHelper = DummyEncryptionHelper()

        // Set expectation
        let exp = expectation(description: "Post request completed")
        
        
        /* Act */
        // Perform post request
        var postResult: Result<User, RegistrationRequestError>!
        
        let requestHelper = RegistrationRequestHelper(stubNetworkLayer, encryptionHelper: dummyEncryptionHelper)
        requestHelper.register("dummy-username", password: "dummy-password") { (result) in
            
            // Capture post result
            postResult = result
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        
        /* Assert */
        var actualError: RegistrationRequestError?
        XCTAssertThrowsError(try postResult.get()) { (error) in
            actualError = error as? RegistrationRequestError
        }
        
        let expectedError = RegistrationRequestError.unexpectedResponse
        XCTAssertEqual(expectedError, actualError)
    }
    
    /// Assert that the username already exists error will trigger
    func testUsernameAlreadyExists() {
        
        /* Arrange */
        // Create dependencies
        let stubNetworkLayer = StubUsernameExistNetworkLayer()
        let dummyEncryptionHelper = DummyEncryptionHelper()

        // Set expectation
        let exp = expectation(description: "Post request completed")
        
        
        /* Act */
        // Perform post request
        var postResult: Result<User, RegistrationRequestError>!
        
        let requestHelper = RegistrationRequestHelper(stubNetworkLayer, encryptionHelper: dummyEncryptionHelper)
        requestHelper.register("dummy-username", password: "dummy-password") { (result) in
            
            // Capture post result
            postResult = result
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        
        /* Assert */
        var actualError: RegistrationRequestError?
        XCTAssertThrowsError(try postResult.get()) { (error) in
            actualError = error as? RegistrationRequestError
        }
        
        let expectedError = RegistrationRequestError.usernameAlreadyExists
        XCTAssertEqual(expectedError, actualError)
    }
    
    /// Assert that the request failed error will trigger
    func testRequestFailed() {
        
        /* Arrange */
        // Create dependencies
        let stubNetworkLayer = StubRequestFailedNetworkLayer()
        let dummyEncryptionHelper = DummyEncryptionHelper()

        // Set expectation
        let exp = expectation(description: "Post request completed")
        
        
        /* Act */
        // Perform post request
        var postResult: Result<User, RegistrationRequestError>!
        
        let requestHelper = RegistrationRequestHelper(stubNetworkLayer, encryptionHelper: dummyEncryptionHelper)
        requestHelper.register("dummy-username", password: "dummy-password") { (result) in
            
            // Capture post result
            postResult = result
            exp.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        
        /* Assert */
        var actualError: RegistrationRequestError?
        XCTAssertThrowsError(try postResult.get()) { (error) in
            actualError = error as? RegistrationRequestError
        }
        
        let expectedError = RegistrationRequestError.requestFailed
        XCTAssertEqual(expectedError, actualError)
    }
}

// MARK:- Test doubles
// Reference: https://swiftsenpai.com/testing/test-doubles-in-swift/
extension RegistrationRequestHelper_After_Post_Tests {

    /// Dummy object that do nothing
    class DummyEncryptionHelper: EncryptionHelperProtocol {
        func encrypt(_ value: String) -> String {
            return value
        }
    }

    /// NetworkLayer stub that return success result
    class StubSuccessNetworkLayer: NetworkLayerProtocol {
        func post(_ url: URL,
                  parameters: Data,
                  completion: (Result<Data, Error>) -> Void) {
            
            let responseJson = """
                                {
                                  "user_id": 1001,
                                  "username": "swift-senpai",
                                  "email": null,
                                  "phone": null
                                }
                                """
            
            // Convert JSON string to JSON data
            let jsonData = Data(responseJson.utf8)
            completion(.success(jsonData))
        }
    }
    
    
    /// NetworkLayer stub that return unexpected result error
    class StubUnexpectedResNetworkLayer: NetworkLayerProtocol {
        func post(_ url: URL,
                  parameters: Data,
                  completion: (Result<Data, Error>) -> Void) {
            let responseJson = "{}"
            let jsonData = Data(responseJson.utf8)
            completion(.success(jsonData))
        }
    }
    
    /// NetworkLayer stub that return "username already exists" error
    class StubUsernameExistNetworkLayer: NetworkLayerProtocol {
        func post(_ url: URL,
                  parameters: Data,
                  completion: (Result<Data, Error>) -> Void) {
            
            let responseJson = """
            {
              "error_code" : "E001",
              "message":"Username already exists"
            }
            """
            
            // Convert JSON string to JSON data
            let jsonData = Data(responseJson.utf8)
            completion(.success(jsonData))
        }
    }
    
    /// NetworkLayer stub that return http request failed error
    class StubRequestFailedNetworkLayer: NetworkLayerProtocol {
        func post(_ url: URL,
                  parameters: Data,
                  completion: (Result<Data, Error>) -> Void) {
            completion(.failure(URLError.init(.timedOut)))
        }
    }
}
