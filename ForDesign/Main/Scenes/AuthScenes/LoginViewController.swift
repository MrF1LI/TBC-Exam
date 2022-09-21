//
//  LoginViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 19.08.22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: Any) {
        self.showSpinner()
        FirebaseManager.shared.signIn(presenting: self) { [weak self] isRegistered in
            if isRegistered {
                self?.goToMainPage()
            } else {
                self?.goToRegistrationPage()
            }
        }
        
    }
    
    // MARK: - Navigation Functions
    
    private func goToMainPage() {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        guard let navController = navController else { return }

        view.window?.rootViewController = navController
        navigationController?.popViewController(animated: true)
    }
    
    private func goToRegistrationPage() {
        let registrationViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        guard let registrationViewController = registrationViewController else { return }
        
        view.window?.rootViewController = registrationViewController
        navigationController?.popViewController(animated: true)
    }
    
}
