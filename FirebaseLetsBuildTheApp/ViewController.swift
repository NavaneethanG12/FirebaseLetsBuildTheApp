//
//  ViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 02/03/22.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let ref = Database.database().reference()
        ref.child("user1").setValue([
            "name":"ravi",
            "age":20
        ])

    }


}

