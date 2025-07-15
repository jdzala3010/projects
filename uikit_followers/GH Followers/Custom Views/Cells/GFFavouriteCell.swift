//
//  GFFavouriteCell.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 09/05/25.
//

import UIKit

class GFFavouriteCell: UITableViewCell {
    
    static let reuseId = "FavouriteCell"
    let avatarImageView = GFAvatarImage(frame: .zero)
    let nameLabel = GFTitleLabel(alignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favourite: Follower) {
        nameLabel.text = favourite.login
        avatarImageView.downloadImage(from: favourite.avatarUrl)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

}
