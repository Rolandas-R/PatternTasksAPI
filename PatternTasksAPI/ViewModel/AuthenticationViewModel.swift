//
//  AuthenticationViewModel.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-04-02.
//

import Foundation


class AuthenticationViewModel {
    var authenticationStateDidChange: ((AuthenticationState) -> Void)?
    private let api = SwaggerAPI()

    enum AuthenticationState {
        case authenticated(User)
        case error(Error)
    }

    func registerUser(username: String, password: String) {
        let user = User(username: username, password: password, userId: nil)
        api.registerUser(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.authenticationStateDidChange?(.authenticated(user))
                case .failure(let error):
                    self.authenticationStateDidChange?(.error(error))
                }
            }
        }
    }

    func loginUser(username: String, password: String) {
        let user = User(username: username, password: password, userId: nil)
        api.loginUser(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.authenticationStateDidChange?(.authenticated(user))
                case .failure(let error):
                    self.authenticationStateDidChange?(.error(error))
                }
            }
        }
    }
}
