//
//  SwaggerAPI.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import UIKit
import Foundation


class SwaggerAPI {
    
    enum APIError: Error {
        case badRequest(errorMessage: String?)
        case notFound(errorMessage: String?)
        case fetchFail
        case parsingFail
        case methodNotAllowed(errorMessage: String?)
    }
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - HTTP Methods
    
    private func dataTask(with request: URLRequest, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.fetchFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.fetchFail))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                completionHandler(.success(data))
            case 404:
                completionHandler(.failure(.notFound(errorMessage: String(data: data, encoding: .utf8))))
            case 400:
                completionHandler(.failure(.badRequest(errorMessage: String(data: data, encoding: .utf8))))
            case 405:
                completionHandler(.failure(.methodNotAllowed(errorMessage: String(data: data, encoding: .utf8))))
            default:
                completionHandler(.failure(.fetchFail))
            }
        }.resume()
    }
    
    private func postRequest(url: URL, body: Data?, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        dataTask(with: request, completionHandler: completionHandler)
    }
    
    private func getRequest(url: URL, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        let request = URLRequest(url: url)
        dataTask(with: request, completionHandler: completionHandler)
    }
    
    private func deleteRequest(url: URL, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        dataTask(with: request, completionHandler: completionHandler)
    }
    
    private func putRequest(url: URL, body: Data?, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        dataTask(with: request, completionHandler: completionHandler)
    }
    
    // MARK: - User Management
    
    func loginUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let loginURL = Constants.getURL(for: Constants.userEndpoint, urlSuffix: .login) else { return }
        let loginUserRequest = User(username: user.username, password: user.password, userId: user.userId)
        let loginData = try? JSONEncoder().encode(loginUserRequest)
        
        postRequest(url: loginURL, body: loginData) { response in
            switch response {
            case .success(let responseData):
                guard let loginResponse = try? JSONDecoder().decode(UserManager.UserResponse.self, from: responseData) else {
                    completion(.failure(APIError.parsingFail))
                    return
                }
                let user = User(username: user.username, password: user.password, userId: loginResponse.userId)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteUser(userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = Constants.getURL(for: Constants.userEndpoint, id: userId) else { return }
        
        deleteRequest(url: url) { response in
            switch response {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    //
    //    // MARK: - Helper Methods
    //
    //    private func showErrorMessage(_ message: String) {
    //        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    //        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //        alert.addAction(okAction)
    //        present(alert, animated: true, completion: nil)
    //    }
    //
    //    private func navigateToHome(user: User) {
    //        let homeViewController = HomeViewController(user: user)
    //        navigationController?.pushViewController(homeViewController, animated: true)
    //    }
    
    
    func registerUser(user: UserManager.AuthentificateRequest, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = Constants.getURL(for: Constants.userEndpoint, urlSuffix: .register) else { return }
        let bodyData = try? JSONEncoder().encode(user)
        
        postRequest(url: url, body: bodyData) { response in
            switch response {
            case .success(let responseData):
                guard let userResponse = try? JSONDecoder().decode(UserManager.UserResponse.self, from: responseData) else {
                    completion(.failure(APIError.parsingFail))
                    return
                }
                let user = User(username: user.username, password: user.password, userId: userResponse.userId)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
