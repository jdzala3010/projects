//
//  UpcomingVC.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private var movies: [Movie] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = upcomingTable.indexPathForSelectedRow {
            upcomingTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        NetworkManager.instace.upcomingMoies {[weak self] result in
            switch result {
                case .success(let movies):
                    self?.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func configure(with movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        DispatchQueue.main.async {
            self.upcomingTable.reloadData()
        }
    }

}

extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MovieDetailVC(movie: movies[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
