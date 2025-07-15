//
//  GFItemInfoVC.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 08/05/25.
//

import UIKit

class GFItemInfoVC: UIViewController {
    
    let stack = UIStackView()
    let itemOne = GFItemInfoView()
    let itemTwo = GFItemInfoView()
    let button = GfButton()
    
    var user: User!
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStackView()
        configureBackGround()
        layoutUI()
        configureActionButton()
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackGround() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(itemOne)
        stack.addArrangedSubview(itemTwo)
    }
    
    func configureActionButton() {
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    @objc func actionButtonPressed() {  }
    
    func layoutUI() {
        view.addSubview(stack)
        view.addSubview(button)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 18
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stack.heightAnchor.constraint(equalToConstant: 50),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
