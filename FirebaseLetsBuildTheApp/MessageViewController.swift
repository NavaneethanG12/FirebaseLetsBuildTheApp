//
//  ViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 02/03/22.
//

import UIKit
import FirebaseDatabase


class MessageViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
       

    }
    
    @objc func handleLogout(){
        let loginVc = LoginViewController()
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: true, completion: nil)
        
    }


}

