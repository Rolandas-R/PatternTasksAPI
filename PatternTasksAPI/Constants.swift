//
//  Constants.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import Foundation

struct Constants {
    static let baseURL = "http://134.122.94.77/api/"
    static let userEndpoint = "User/"
    static let taskEndpoint = "Task/"
    
    enum URLSuffix: String {
        case register = "register/"
        case login = "login/"
        case userTasks = "/api/Task/userTasks"
    }
    
    static func getURL(for endpoint: String, urlSuffix: Constants.URLSuffix? = nil, id: Int? = nil) -> URL? {
        var urlString = Constants.baseURL + endpoint
        if let id = id {
            urlString += String(id)
        } else if let urlSuffix = urlSuffix {
            urlString += urlSuffix.rawValue
        }
        return URL(string: urlString)
    }
    
    static func buildURLWithParams(userId: Int?) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "134.122.94.77"
        components.path = Constants.URLSuffix.userTasks.rawValue
        let userIdQueryItem = URLQueryItem(name: "userId", value: String(userId ?? 0))
        let queryItems = [userIdQueryItem]
        components.queryItems = queryItems
        return components.url
    }
}
