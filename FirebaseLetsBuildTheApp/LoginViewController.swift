//
//  LoginViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 02/03/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {

    let inputsView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.distribution = .fillEqually
        view.axis = .vertical
        view.layer.masksToBounds = true
        return view
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.buttonColor
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocapitalizationType = .none
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.textAlignment = .center
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.backgroundBlueColor
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillLayoutSubviews() {
        // adding subviews
        
        view.addSubview(inputsView)
        inputsView.addArrangedSubview(nameTextField)
        inputsView.addArrangedSubview(emailTextField)
        inputsView.addArrangedSubview(passwordTextField)
        view.addSubview(profileImageView)
        
        view.addSubview(registerButton)
        
        
        inputsView.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // adding subviews constraints
        
        NSLayoutConstraint.activate([
            inputsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -24),
            inputsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            
        ])
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: inputsView.bottomAnchor, constant: 10),
            registerButton.widthAnchor.constraint(equalTo: inputsView.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: inputsView.topAnchor, constant: -10),
            profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
    }
    
    @objc func registerButtonTapped(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            // user created successfully
            print("User Created")
            
            let ref = Database.database().reference()
            let value = ["name": name,"email": email]
            ref.child("users").child(result!.user.uid).updateChildValues(value) { err, reference in
                
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
            // database childvalue updated
                
                print("Value updated")
                
            }
            
            
        }
        
    }
    


}
