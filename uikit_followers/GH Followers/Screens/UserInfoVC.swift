//
//  UserInfoVCViewController.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 07/05/25.
//

import UIKit
import SafariServices


protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(user: User)
    func didTapGitFollowers(user: User)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemOneView = UIView()
    let itemTwoView = UIView()
    let dateLabel = GFTitleLabel(alignment: .center, fontSize: 16)
    
    var username: String!
    var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        getUser()
        layoutUI()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    func getUser() {
        NetworkManager.shared.getUser(for: username) {[weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.configureElements(user: user)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMain(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureElements(user: User) {
        
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerVC = GFFollowerVC(user: user)
        followerVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemOneView)
        self.add(childVC: followerVC, to: self.itemTwoView)
        self.setDate(user: user)
    }
    
    func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(itemOneView)
        view.addSubview(itemTwoView)
        view.addSubview(dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemOneView.translatesAutoresizingMaskIntoConstraints = false
        itemTwoView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemOneView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemOneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemOneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemOneView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemTwoView.topAnchor.constraint(equalTo: itemOneView.bottomAnchor, constant: padding),
            itemTwoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemTwoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemTwoView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemTwoView.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)

        ])
    }
    
    func setDate(user: User) {
        dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
        
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
}

extension UserInfoVC: UserInfoVCDelegate {
    
    func didTapGitHubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMain(title: "Something gone wrong", message: "User's url is not correct", buttonTitle: "Ok")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func didTapGitFollowers(user: User) {
        delegate.didRequestFollowers(username: username)
        dismissVC()
    }

}
