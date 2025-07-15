//
//  GFFollowerVC.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 08/05/25.
//

import UIKit

class GFFollowerVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemOne.set(itemInfoType: .follower, count: user.followers)
        itemTwo.set(itemInfoType: .following, count: user.following)
        button.set(bgColor: .systemGreen, title: "Get Followers")
    }

    override func actionButtonPressed() {
        delegate.didTapGitFollowers(user: user)
    }
    
}
