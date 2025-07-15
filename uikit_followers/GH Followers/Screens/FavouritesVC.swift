//
//  FavouritesVC.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 05/05/25.
//

import UIKit

class FavouritesVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureFollowerVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self]result in
            guard let self = self else { return }
            
            switch result {
                case .success(let favorites):
                    
                    if favorites.isEmpty {
                        self.showEmptyState(message: "No Favourites!!!", in: self.view)
                    } else {
                        self.favorites = favorites

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.view.bringSubviewToFront(self.tableView)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func configureFollowerVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GFFavouriteCell.self, forCellReuseIdentifier: GFFavouriteCell.reuseId)
    }
    
}

extension FavouritesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GFFavouriteCell.reuseId) as! GFFavouriteCell
        let favourite = favorites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favorites[indexPath.row]
        let destVc = FollowerListVC()
        destVc.username = favourite.login
        destVc.title = favourite.login
        
        navigationController?.pushViewController(destVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let favourite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        PersistenceManager.updateWith(favorite: favourite, actionType: .remove) {[weak self] error in
            guard let self = self else { return }
            
            if let error {
                self.presentGFAlertOnMain(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
