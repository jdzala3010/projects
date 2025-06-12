//
//  DownloadsVC.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private let dataManager = CoreDataManager.shared
    private var movies: [Movie] = []
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = downloadTable.indexPathForSelectedRow {
            downloadTable.deselectRow(at: indexPath, animated: true)
        }
        
        movies.removeAll()
        fetchDownloadedMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    private func fetchDownloadedMovies() {
        let movieEntities = dataManager.fetchMovies()
        let movies = movieEntities.map { convertMovieEntityToMovie($0) }
        configure(with: movies)
    }
    
    private func convertMovieEntityToMovie(_ entity: MovieEntity) -> Movie {
        return Movie(
            id: Int(entity.id),
            mediaType: entity.mediaType,
            originalTitle: entity.originalTitle,
            originalName: entity.originalName,
            overview: entity.overview,
            posterPath: entity.posterPath,
            voteCount: Int(entity.voteCount),
            releaseDate: entity.releaseDate,
            voteAverage: entity.voteAverage
        )
    }
    
    private func configure(with movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        DispatchQueue.main.async {
            self.downloadTable.reloadData()
        }
    }
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            dataManager.deleteMovie(movies[indexPath.row])
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
