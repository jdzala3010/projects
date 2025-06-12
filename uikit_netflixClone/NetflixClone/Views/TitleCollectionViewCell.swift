//
//  TitleCollectionView.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 03/06/25.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleCollectionView"
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = contentView.bounds
    }
    
    func configure(with path: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else { return
            print("couldn't load")
        }
        posterImage.sd_setImage(with: url, completed: nil)
    }
}
