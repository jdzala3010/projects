//
//  GFAvatarImage.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 06/05/25.
//

import UIKit

class GFAvatarImage: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeholder = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        
        if let image = cache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resposne, error in
            if let _ = error {
                return
            }
            
            guard let response = resposne as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data else {
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
    }
}
