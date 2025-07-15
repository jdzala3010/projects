//
//  GFItemInfoView.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 08/05/25.
//

import UIKit

enum ItemInfoType: String {
    case repos = "folder"
    case gists = "text.alignleft"
    case follower = "heart"
    case following = "person.2"
}

class GFItemInfoView: UIView {

    let imageView = UIImageView()
    let titleLable = GFTitleLabel(alignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(alignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(imageView)
        addSubview(titleLable)
        addSubview(countLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLable.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: ItemInfoType, count: Int) {
        switch itemInfoType {
            case .repos:
                imageView.image = UIImage(systemName: ItemInfoType.repos.rawValue)
                titleLable.text = "Public Repos"
            case .gists:
                imageView.image = UIImage(systemName: ItemInfoType.repos.rawValue)
                titleLable.text = "Public Gists"
            case .follower:
                imageView.image = UIImage(systemName: ItemInfoType.repos.rawValue)
                titleLable.text = "Followers"
            case .following:
                imageView.image = UIImage(systemName: ItemInfoType.repos.rawValue)
                titleLable.text = "Following"
        }
        
        countLabel.text = String(count)
    }
}
