//
//  RegistrationController.swift
//  GeoConnect
//
//  Created by David on 08/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
       
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .whileEditing
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
       
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "Already have an account ? ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAnAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.isEmpty == false else { return }
        guard let password = passwordTextField.text, password.isEmpty == false else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error registering user: ", error)
                return
            }
            
            print("Succes registering user with uid: \(user?.uid ?? "")")
            
            guard let user = user else { return }
            
            let values = ["id" : user.uid, "email" : email]
            self.saveUserDataInFirebaseDatabase(uid: user.uid, values: values as [String : AnyObject])
            
        }
        
        
    }
    
    
    private func saveUserDataInFirebaseDatabase(uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.setValue(values) { (error, ref) in
            if let error = error {
                print("Error saving user info into database: \(error)")
                return
            }
            
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupTabBarViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(alreadyHaveAnAccountButton)
        
        alreadyHaveAnAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        alreadyHaveAnAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alreadyHaveAnAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alreadyHaveAnAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupInputFields()
    }
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false 
        return sv
    }()
    
    func setupInputFields() {
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signUpButton)
        
        view.addSubview(stackView)
        
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}













