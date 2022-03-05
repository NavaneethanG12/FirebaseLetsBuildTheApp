//
//  NewMessagesViewController.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 03/03/22.
//

import UIKit
import FirebaseDatabase


class NewMessagesViewController: UITableViewController {
    
    let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .tintColor
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    
    private lazy var session: URLSession = {
//        print(URLCache.shared.memoryCapacity)
        URLCache.shared.memoryCapacity = 512*1024*1024
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    private var dataTask: URLSessionDataTask?
    
    let imageCache = NSCache<NSString,AnyObject>()
    
    let cellIdentifier = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(dissmissView))
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        spinner.startAnimating()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUser()
        
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func fetchUser(){
        let ref = Database.database().reference()
        
        ref.child("users").observe(.childAdded) { snapShot in
            
            if let data = snapShot.value as? [String:AnyObject]{
                
                let name = data["name"] as! String
                let email = data["email"] as! String
                let profileUrl = data["profileUrl"] as! String
                
                let user = User(name: name, email: email, profileUrl: profileUrl)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        //        spinner.stopAnimating()
        
    }
    
    @objc func dissmissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.setProfilePic(withUrl: user.profileUrl, session: session)
        spinner.stopAnimating()
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        super.tableView(tableView, heightForRowAt: indexPath)
        
        return view.frame.height * 0.15
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
