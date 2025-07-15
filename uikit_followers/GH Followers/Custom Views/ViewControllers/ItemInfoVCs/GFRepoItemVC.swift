//
//  GFRepoItemVC.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 08/05/25.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemTwo.set(itemInfoType: .gists, count: user.publicGists)
        button.set(bgColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonPressed() {
        delegate.didTapGitHubProfile(user: user)
    }
}
