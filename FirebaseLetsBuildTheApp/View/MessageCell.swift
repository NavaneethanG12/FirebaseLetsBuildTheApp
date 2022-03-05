//
//  MessageCell.swift
//  FirebaseLetsBuildTheApp
//
//  Created by navaneeth-pt4855 on 03/03/22.
//

import UIKit

class MessageCell: UITableViewCell {
    
    private var dataTask: URLSessionDataTask?
    
    let userImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
//        iv.image = UIImage(systemName: "house")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addConstraints()
    }
    
    
    func addConstraints(){
        
        textLabel?.frame = CGRect(x: userImage.frame.width + 25, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: userImage.frame.width + 25, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
        contentView.addSubview(userImage)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor)
        ])
        
        userImage.layoutIfNeeded()
        
        userImage.layer.cornerRadius = userImage.frame.height / 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setProfilePic(withUrl urlString: String, session: URLSession){
    
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            if error != nil{
                print(error)
                return
            }
            
            guard let data = data else {
                return
            }

            DispatchQueue.main.async {
                self.userImage.image = UIImage(data: data)
            }
        }
        
        dataTask.resume()
    }
}
