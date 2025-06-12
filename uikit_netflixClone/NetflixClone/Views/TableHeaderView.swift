//
//  TableHeaderView.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit
import SDWebImage

protocol TableHeaderViewDelegate: AnyObject {
    func playMovie(_ view: TableHeaderView, play movie: Movie)
}

class TableHeaderView: UIView {
    
    private let dataManager = CoreDataManager.shared
    var movie: Movie?
    weak var delegate: TableHeaderViewDelegate?
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Download", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Play", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    let headerImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImage)
        configureImage()
        addGradient()
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
        addSubview(downloadButton)
        downloadButton.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = bounds
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor, UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    private func configureImage() {
        NetworkManager.instace.getTrending {[weak self] result in
            switch result {
                case .success(let movies):
                    guard let randomMovie = movies.randomElement(),
                          let path = randomMovie.posterPath else { return }
                    guard let url = URL(string: "https://image.tmdb.org/t/p/original\(path)") else { return
                        print("couldn't load")
                    }
                    
                    self?.movie = randomMovie
                    
                    DispatchQueue.main.async {
                        self?.headerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "poster"))
                        self?.headerImage.contentMode = .scaleAspectFill
                        self?.headerImage.clipsToBounds = true
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
            }
        }
    }
    
    func addConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            downloadButton.widthAnchor.constraint(equalToConstant: 100),
            downloadButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            downloadButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 30)
        ])
    }
    
    @objc func playButtonClicked() {
        print("play")
        guard let movie = self.movie else { return }
        print(movie.originalTitle ?? movie.originalName ?? "No name")
        delegate?.playMovie(self, play: movie)
    }
    
    @objc func downloadButtonClicked() {
        guard let movie else { return }
        let downloadedMovies = fetchUpcoming()
        if !downloadedMovies.contains(where: { $0 == movie.id}) {
            dataManager.createMovie(movie)
        } else {
            print("Already exist")
        }
    }
    
    private func fetchUpcoming() -> [Int] {
        let movieEntities = dataManager.fetchMovies()
        return movieEntities.map { convertMovieEntityToMovie($0) }
    }
    
    private func convertMovieEntityToMovie(_ entity: MovieEntity) -> Int {
        return Int(entity.id)
    }
}
