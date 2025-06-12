//
//  InfoVC.swift
//  NetflixClone
//
//  Created by Jaydeep Zala on 11/06/25.
//

import UIKit
import SDWebImage
import WebKit

class MovieDetailVC: UIViewController {
    
    private let movie: Movie
    private let dataManager = CoreDataManager.shared
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let webView: WKWebView = WKWebView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemYellow
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        configure(with: movie)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [webView, titleLabel, releaseDateLabel, ratingLabel, overviewLabel, downloadButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            webView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            overviewLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 24),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func configure(with movie: Movie) {
        titleLabel.text = movie.originalTitle ?? movie.originalName ?? "Unknown Title"
        releaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "N/A")"
        if let vote = movie.voteAverage {
            ratingLabel.text = "⭐️ \(vote)"
        } else {
            ratingLabel.text = "⭐️ N/A"
        }
        overviewLabel.text = movie.overview ?? "No overview available."
        
        guard let movieName = titleLabel.text else { return }
        
        NetworkManager.instace.getVideoID(query: movieName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoID):
                guard let videoURL = NetworkManager.instace.getMovieURL(videoID: videoID) else { return }
                DispatchQueue.main.async {
                    self?.webView.load(URLRequest(url: videoURL))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    @objc private func downloadButtonTapped() {
        var alertTitle = ""
        var alertMessage = ""
        let downloadedMovies = fetchUpcoming()
        if !downloadedMovies.contains(where: { $0 == movie.id}) {
            dataManager.createMovie(movie)
            alertTitle = "Saved"
            alertMessage = "Movie saved for offline!"
        } else {
            alertTitle = "Already downloaded"
            alertMessage = "No need to save"
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func fetchUpcoming() -> [Int] {
        let movieEntities = dataManager.fetchMovies()
        return movieEntities.map { convertMovieEntityToMovie($0) }
    }
    
    private func convertMovieEntityToMovie(_ entity: MovieEntity) -> Int {
        return Int(entity.id)
    }
}
