//
//  User.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import Foundation

struct UserAuthRequest: Codable {
    let username: String
    let password: String
}

struct UserAuthResponse: Codable {
    let userId: Int
}

struct User: Codable {
    let userId: Int
    let username: String
}




