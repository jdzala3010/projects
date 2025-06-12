//
//  HomeVC.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit

enum Sections: Int {
    case TrendingMovies, Popular, Upcoming, TopRated
}

class HomeVC: UIViewController {
    
    let sectionTitles = ["Trending Movies","Popular", "Upcoming Movies", "Top Rated"]

    private let feedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableCellVC.self, forCellReuseIdentifier: CollectionViewTableCellVC.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        configureNavbar()
        view.addSubview(feedTable)
        
        feedTable.delegate = self
        feedTable.dataSource = self
        
        let headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        headerView.delegate = self
        feedTable.tableHeaderView = headerView
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectMovie(_:)), name: NSNotification.Name("movieSelected"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didSelectMovie(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let movie = userInfo["movie"] as? Movie else { return }
        
        let detailVC = MovieDetailVC(movie: movie)
        present(detailVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        let image = UIImage(named: "nLogo")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)]
        
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableCellVC.identifier, for: indexPath) as? CollectionViewTableCellVC else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                NetworkManager.instace.getTrending() { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.rawValue)
                    }
                }
                
            case Sections.Popular.rawValue:
                NetworkManager.instace.getPopular() { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.rawValue)
                    }
                }
                
            case Sections.Upcoming.rawValue:
                NetworkManager.instace.upcomingMoies() { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.rawValue)
                    }
                }
                
            case Sections.TopRated.rawValue:
                NetworkManager.instace.topRated() { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(with: movies)
                        case .failure(let error):
                            print(error.rawValue)
                    }
                }
                
            default:
                return UITableViewCell()
        }
        return cell
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = .init(x: header.bounds.width + 10, y: header.bounds.height, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
}

extension HomeVC: TableHeaderViewDelegate {
    
    func playMovie(_ view: TableHeaderView, play movie: Movie) {
        let detailVC = MovieDetailVC(movie: movie)
        present(detailVC, animated: true)
    }
    
}
