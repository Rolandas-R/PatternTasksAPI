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
    @IBOutlet weak var authentificateQuestionLabel: UILabel!
    
    
    
    private let viewModel = AuthenticationViewModel()
    private(set) var user: User?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AuthenticationViewController.labelTap))
        authentificateQuestionLabel.isUserInteractionEnabled = true
        authentificateQuestionLabel.addGestureRecognizer(tap)
        
        authentificateQuestionLabel.text = "Do you have an account? Press here to login"
        authenticateButton.setTitle("Register", for: .normal)
//        authenticateButton.titleLabel?.text = "Register"
        
        viewModel.authenticationStateDidChange = { [weak self] state in
            guard self != nil else { return }
            
            switch state {
            case .authenticated(let user):
                print("User authenticated: \(user)")
                self?.showTasksTableViewController(user: user)
            case .error(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func authenticateButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else
        {
            print("Username or password is empty")
            return
        }

        
//        viewModel.registerUser(username: username, password: password)
        viewModel.loginUser(username: username, password: password)
        
    }
    
    
    @IBAction func labelTap(sender: UITapGestureRecognizer) {
        
        authenticateButton.titleLabel?.text = "LOGIN"
        authentificateQuestionLabel.text = "Have no username? Register!"
    }

    
    private func showTasksTableViewController(user: User) {
        let tabVC = TasksTableViewController()
        tabVC.modalPresentationStyle = .popover
        tabVC.modalTransitionStyle = .coverVertical
        tabVC.user = user
        self.present(tabVC, animated: true)

    }
    
}


