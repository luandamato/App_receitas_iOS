//
//  ImageViewExtension.swift
//  Recipes
//
//  Created by Luan Damato on 30/10/25.
//

import UIKit

extension UIImageView {
    func setImage(from urlString: String?, placeholder: UIImage? = nil) {
        // Coloca placeholder se houver
        self.image = placeholder
        
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        // Verifica se já está em cache
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // Baixa a imagem
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                let image = UIImage(data: data),
                error == nil
            else { return }
            
            // Salva no cache
            ImageCache.shared.save(image: image, forKey: urlString)
            
            // Atualiza na main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

// Cache simples em memória
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
