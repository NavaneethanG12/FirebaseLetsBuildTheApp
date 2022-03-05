//
//  LoginViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 02/03/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
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
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        gesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(gesture)
        return image
    }()
    
    let loginRegisterSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login","Register"])
        segment.tintColor = .white
        segment.selectedSegmentIndex = 1
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.backgroundBlueColor
        
        registerButton.addTarget(self, action: #selector(loginRegisterTapped), for: .touchUpInside)
        loginRegisterSegment.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        
    }
    
    @objc func loginRegisterTapped(){
        if loginRegisterSegment.selectedSegmentIndex == 0{
            loginButtonTapped()
        }else{
            registerButtonTapped()
        }
    }
    
    override func viewWillLayoutSubviews() {
        // adding subviews
        
        view.addSubview(inputsView)
        inputsView.addArrangedSubview(nameTextField)
        inputsView.addArrangedSubview(emailTextField)
        inputsView.addArrangedSubview(passwordTextField)
        view.addSubview(profileImageView)
        view.addSubview(registerButton)
        view.addSubview(loginRegisterSegment)
        
        
        inputsView.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegment.translatesAutoresizingMaskIntoConstraints = false
        
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
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegment.topAnchor, constant: -10),
            profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegment.bottomAnchor.constraint(equalTo: inputsView.topAnchor, constant: -10),
            loginRegisterSegment.heightAnchor.constraint(equalToConstant: 30),
            loginRegisterSegment.widthAnchor.constraint(equalTo: inputsView.widthAnchor)
        ])
    }
    
    func registerButtonTapped(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            // user created successfully
            print("User Created")

            let uid = result!.user.uid
            let storageRef = Storage.storage().reference().child("\(email).png")
            
            if let uploadData = self.profileImageView.image?.pngData(){
                storageRef.putData(uploadData, metadata: nil) { metaData, errorr in
                    
                    if errorr != nil{
                        print(errorr?.localizedDescription)
                        return
                    }
                    
                    do {
                        try storageRef.downloadURL(completion: { url, er in
                            
                            guard let profileUrl = url else { return }
                            
                            let value = ["name": name,"email": email,"profileUrl": profileUrl.absoluteString] as [String: AnyObject] 
                    
                            self.registerUserIntoFirebaseWithUid(uid: uid , value: value)
                    print(metaData?.name)
                            
                        })
                    } catch {
                        print(error)
                    }
                           
                }
            }
        }
    }
    
    
    func registerUserIntoFirebaseWithUid(uid: String, value: [String: AnyObject]){
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).updateChildValues(value) { err, reference in
            
            if err != nil{
                print(err?.localizedDescription)
                return
            }
        // database childvalue updated
            
            print("Value updated")
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func loginButtonTapped(){
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            // logged in
            print("Logged In successfully")
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    @objc func segmentAction(_ sender: UISegmentedControl){
            
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        registerButton.setTitle(title, for: .normal)
        
        nameTextField.isHidden = sender.selectedSegmentIndex == 0 ? true : false
        
        profileImageView.isUserInteractionEnabled = sender.selectedSegmentIndex == 0 ? false : true
        
       
    }
    
    @objc func gestureHandler(){
        // gesture interaction
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
        print("tapped")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Cancelled")
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let editedImage = info[.editedImage] as? UIImage
        self.profileImageView.image = editedImage
        
        picker.dismiss(animated: true, completion: nil)
    }

}
