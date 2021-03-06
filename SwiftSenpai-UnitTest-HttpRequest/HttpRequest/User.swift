//
//  User.swift
//  SwiftSenpai-UnitTest-HttpRequest
//
//  Created by Lee Kah Seng on 06/02/2020.
//  Copyright © 2020 Lee Kah Seng. All rights reserved.
//

import Foundation

struct User: Decodable {
    let userId: Int
    let username: String
    var email: String? = nil
    var phone: String? = nil
}
