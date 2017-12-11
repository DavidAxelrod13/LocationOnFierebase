//
//  ViewController.swift
//  GeoConnect
//
//  Created by David on 08/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase


class LoginController: UIViewController {
    
    lazy var noAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "No Account ? ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Register", attributes: [NSAttributedStringKey.foregroundColor:UIColor.blue, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleRegister() {
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
    }

    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleLogin() {
        
        guard let email = emailTextField.text, email.isEmpty == false else { return }
        guard let password = passwordTextField.text, password.isEmpty == false else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print("Error signing in: ", error)
                return
            }
            
            print("Success login user in: ", user?.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupTabBarViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        setupUI()
    }
    

    private func setupUI() {
        
        view.addSubview(logoContainerView)

        logoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        logoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        logoContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(noAccountButton)
        
        noAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupInputFields()
    }
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    fileprivate func setupInputFields() {
       
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
}















