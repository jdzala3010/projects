//
//  FollowerListViewController.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 05/05/25.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(username: String)
}

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureSearchController()
        configureDataSource()
        getFollowers(username: username ,page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addToFavourite))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addToFavourite() {
        showLoadingView()
        
        NetworkManager.shared.getUser(for: username) {result in
            
            self.stopLoadingView()
            
            switch result {
                case .success(let user):
                    let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    
                    PersistenceManager.updateWith(favorite: favourite, actionType: .add) { error in
                        if let error {
                            self.presentGFAlertOnMain(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                        } else {
                            self.presentGFAlertOnMain(title: "Success", message: "Successfully added to the Facorites", buttonTitle: "Ok")
                        }
                    }
                    
                case .failure(let error):
                    self.presentGFAlertOnMain(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
        
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) {[weak self] result in
            
            guard let self else { return }
            self.stopLoadingView()
            
            switch result {
                case .success(let followers):
                    if followers.count < 100 {
                        self.hasMoreFollowers = false
                    }
                    self.followers.append(contentsOf: followers)
                    
                    if followers.isEmpty {
                        let message = "User doesn't have any followers, would you like to be there first one."
                        DispatchQueue.main.async {
                            self.showEmptyState(message: message, in: self.view)
                        }
                        return
                    }
                    self.updateData(on: followers)
                case .failure(let error):
                    self.presentGFAlertOnMain(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(GFFollowerCell.self, forCellWithReuseIdentifier: GFFollowerCell.reuseId)
    }
    
    func collectionFlowLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding: CGFloat = 20
        let spacing : CGFloat = 12
        let availableWidth = width - (padding * 2) - (spacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 25)
        
        return flowLayout
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GFFollowerCell.reuseId, for: indexPath) as! GFFollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
}

// MARK: EXTENSIONS
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            if hasMoreFollowers {
                page += 1
                getFollowers(username: username, page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeCollection = isSearching ? filteredFollowers : followers
        let follower = activeCollection[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(text.lowercased())}
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
}

extension FollowerListVC: FollowerListVCDelegate {
    
    func didRequestFollowers(username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        getFollowers(username: username, page: page)
        collectionView.setContentOffset(.zero, animated: true)
    }
}
