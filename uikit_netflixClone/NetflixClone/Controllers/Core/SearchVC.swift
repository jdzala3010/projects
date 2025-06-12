//
//  SearchVC.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit

class SearchVC: UIViewController {
    
    private var movies: [Movie] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchBarVC())
        controller.searchBar.placeholder = "Search for a movie..."
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Search"
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        NetworkManager.instace.getDiscoveredMovies {[weak self] result in
            switch result {
                case .success(let movies):
                    self?.movies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self?.discoverTable.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = discoverTable.indexPathForSelectedRow else { return }
        discoverTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }

}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailVC(movie: movies[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchBarVC else {
            return
        }
        
        NetworkManager.instace.getSearchedMovies(name: query) { result in
            switch result {
                case .success(let movies):
                    // REMOVING PREVIOUS SEARCH DATA IF THERE IS
                    resultController.movies.removeAll()
                    
                    let filteredMovies = movies.filter( { $0.posterPath != nil })
                    resultController.movies.append(contentsOf: filteredMovies)
                    
                    DispatchQueue.main.async {
                        resultController.searchResultCollectionView.reloadData()
                    }
                    
                    resultController.movies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        resultController.searchResultCollectionView.reloadData()
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
            }
        }
    }
}
