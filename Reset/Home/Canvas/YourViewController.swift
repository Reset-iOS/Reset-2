//
//  YourViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 08/01/25.
//

import UIKit

class YourViewController: UIViewController {
    private lazy var galleryView: GalleryView = {
        let view = GalleryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(galleryView)
        
        NSLayoutConstraint.activate([
            galleryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            galleryView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        galleryView.loadImages()
    }
}
