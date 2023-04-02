//
//  UserManager.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import Foundation

class UserManager {
    var userId: Int?
    var username: String?

    
    var user: User? {
        guard let userId = userId, let username = username else { return nil }
        return User(userId: userId, username: username)
    }
}
