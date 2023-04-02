//
//  ViewController.swift
//  PatternTasksAPI
//
//  Created by reromac on 2023-03-30.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    
    private let viewModel = AuthenticationViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.authenticationStateDidChange = { [weak self] state in
                   guard let self = self else { return }
                   
                   switch state {
                   case .authenticated(let user):
                       print("User authenticated: \(user)")
                   case .error(let error):
                       print("Error: \(error)")
                   }
               }
    }

    @IBAction func authenticateButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text,
                      let password = passwordTextField.text else {
                    print("Username or password is empty")
                    return
                }
                
                viewModel.registerUser(username: username, password: password)
            }
    
    private func handleAuthenticationState(_ state: AuthenticationViewModel.AuthenticationState) {
           switch state {
           case .authenticated(let user):
               print("Authenticated: \(user)")
               // Navigate to another screen
           case .error(let error):
               print("Error: \(error)")
               // Show error message
           }
       }
    
}


