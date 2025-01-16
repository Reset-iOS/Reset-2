//
//  PostDetailViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 07/01/25.
//


import UIKit

class PostDetailViewController: UIViewController {
    
    private let post: Post
    private let postCell = PostCollectionViewCell()
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPostCell()
    }
    
    private func setupPostCell() {
        // Add the PostCollectionViewCell to the view
        postCell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postCell)
        
        // Configure the cell with the selected post
        postCell.configure(with: post)
        
        // Set constraints
        NSLayoutConstraint.activate([
            postCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postCell.heightAnchor.constraint(equalToConstant: 600) // Adjust height as needed
        ])
    }
}

