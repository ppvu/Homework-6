//
//  LoginViewController.swift
//  Homework6
//
//  Created by spezza on 17.02.2021.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var GitHubLoginButton: UIButton!
    let token = KeychainWrapper.standard.string(forKey: "token")
    var authService: AuthService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GitHubLoginButton.layer.cornerRadius = 12
        login()
    }
    @IBAction func GitHubLoginAction(_ sender: Any) {
        authentification()
    }
}

private extension LoginViewController {

    func biometricsLogin() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] success, _ in
                DispatchQueue.main.async {
                    if success {
                        self?.toMain()
                    } else {
                        let alertController = UIAlertController(
                            title: "Authentication failed",
                            message: "You can try again or login with GitHub", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(
                title: "Biometric identification is not available",
                message: "Your device is not configured for Face ID or Touch ID.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    func login() {
        guard let token = token, !token.isEmpty else {
            authentification()
            return
        }
        biometricsLogin()
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: "token")
        authService?.logOut!()
    }
    
    func authentification() {
        let authViewController = AuthentificationViewController()
        authViewController.delegate = self
        
        self.present(UINavigationController(rootViewController: authViewController),
                                            animated: true,
                                            completion: nil)
    }
    
    func toMain() {
        let imagesViewController = ImagesViewController(nibName: "ImagesViewController", bundle: nil)
        let imagesNavigationController = UINavigationController(rootViewController: imagesViewController)

        imagesNavigationController.modalPresentationStyle = .overFullScreen

        present(imagesNavigationController, animated: true)
    }
}

extension LoginViewController: AuthentificationDelegate {
    func handleAccessToken(accessToken: String) {
    }
}

