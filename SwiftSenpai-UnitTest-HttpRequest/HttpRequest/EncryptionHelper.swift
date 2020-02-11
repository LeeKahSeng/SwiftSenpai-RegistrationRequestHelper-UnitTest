//
//  EncryptionHelper.swift
//  SwiftSenpai-UnitTest-HttpRequest
//
//  Created by Lee Kah Seng on 06/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import Foundation

protocol EncryptionHelperProtocol {
    func encrypt(_ value: String) -> String
}


class EncryptionHelper: EncryptionHelperProtocol {
    func encrypt(_ value: String) -> String {
        
        // Encryption logic here
        // ...
        // ...
        
        return "some encrypted value";
    }
}
