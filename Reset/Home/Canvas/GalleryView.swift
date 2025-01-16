//
//  GalleryView.swift
//  Reset
//
//  Created by Prasanjit Panda on 08/01/25.
//


import UIKit
import FirebaseStorage

class GalleryView: UIView {
    private let model = Model()
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Main horizontal stack view
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    // Vertical stack view for the two smaller images
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    // Three image views
    private lazy var firstImageView: UIImageView = createImageView()
    private lazy var secondImageView: UIImageView = createImageView()
    private lazy var thirdImageView: UIImageView = createImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
//        backgroundColor = UIColor(red: 0.98, green: 0.94, blue: 0.90, alpha: 1.0)
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        
        // Add vertical stack view images
        verticalStackView.addArrangedSubview(firstImageView)
        verticalStackView.addArrangedSubview(secondImageView)
        
        // Add both stacks to horizontal stack
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(thirdImageView)
        
        // Add horizontal stack to main view
        addSubview(horizontalStackView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        return imageView
    }
    
    func loadImages() {
        model.fetchCanvasItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.displayImages(from: items)
            case .failure(let error):
                print("Error fetching canvas items: \(error)")
            }
        }
    }
    
    private func displayImages(from items: [CanvasItem]) {
        let imageItems = items.compactMap { item -> URL? in
            if case .image(let urlString) = item {
                return URL(string: urlString)
            }
            return nil
        }
        
        guard !imageItems.isEmpty else { return }
        
        // Load images asynchronously
        let imageViews = [firstImageView, secondImageView, thirdImageView]
        
        for (index, imageURL) in imageItems.prefix(3).enumerated() {
            loadImage(from: imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    imageViews[index].image = image
                }
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if image is already cached
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("Cache Hit: Image found in cache for URL: \(url.absoluteString)")
            completion(cachedImage)
            return
        }
        
        // If not cached, load image from URL
        print("Cache Miss: Downloading image for URL: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image for URL: \(url.absoluteString), Error: \(String(describing: error))")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            // Cache the loaded image
            if let image = image {
                self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                print("Image cached successfully for URL: \(url.absoluteString)")
            } else {
                print("Failed to create image from data for URL: \(url.absoluteString)")
            }
            
            completion(image)
        }.resume()
    }
}



