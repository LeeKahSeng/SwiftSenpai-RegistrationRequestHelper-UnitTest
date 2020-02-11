//
//  RegistrationRequestError.swift
//  SwiftSenpai-UnitTest-HttpRequest
//
//  Created by Lee Kah Seng on 06/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import Foundation

enum RegistrationRequestError: Error, Equatable {
    case usernameAlreadyExists
    case unexpectedResponse
    case requestFailed
}

extension RegistrationRequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .usernameAlreadyExists:
            return NSLocalizedString(
                "Username already exists, please choose another username.",
                comment: ""
            )
        case .unexpectedResponse:
            return NSLocalizedString(
                "The server returned unexpected response, please contact administrator.",
                comment: ""
            )
        case .requestFailed:
            return NSLocalizedString(
                "Something went wrong, please contact administrator.",
                comment: ""
            )
        }
    }
}
