//
//  CollectionViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 05/03/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = .blue
        return cell
    }
    
}
