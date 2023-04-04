//
//  User.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let userId: Int?
}

class UserManager {
    struct AuthentificateRequest: Codable {
        let username: String
        let password: String
        var userId: Int? = nil
    }
    struct UserResponse: Codable {
        let userId: Int
    }
}





