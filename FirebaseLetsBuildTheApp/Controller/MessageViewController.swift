//
//  ViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 02/03/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class MessageViewController: UIViewController {

    let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .tintColor
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessagesHandler))
        
        spinner.startAnimating()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        checkIfUserLoggedIn()
        
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(spinner)
        
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func checkIfUserLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }else{
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            ref.child("users").child(uid!).observeSingleEvent(of: .value) { dataSnapshot in
                
                if let data = dataSnapshot.value as? [String:AnyObject]{
                    let title = data["name"] as? String
                    
                    self.navigationItem.title = title?.uppercased()
                    self.spinner.stopAnimating()
                    print(data["name"])
                }
            }
        }
    }
    
    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
        let loginVc = LoginViewController()
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: true, completion: nil)
        
    }
    
    

    @objc func newMessagesHandler(){
        let vc = NewMessagesViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.navigationItem.title = "New Messages"
        present(nav, animated: true, completion: nil)
        
    }

}

