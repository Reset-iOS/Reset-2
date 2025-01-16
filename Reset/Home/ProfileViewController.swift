//
//  ProfileViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 07/01/25.
//

//
//  ProfileViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 07/01/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var user: User?
    private var soberStatLabel: UILabel?
    private var resetsStatLabel: UILabel?
    private var longestStreakStatLabel: UILabel?

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.image = UIImage(named: "onboarding1") // Replace with default image
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        /*label.text = "Prasanjit Panda"*/ // Replace with dynamic name
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let gearImage = UIImage(systemName: "gearshape") // Use SF Symbol for gear icon
        button.setImage(gearImage, for: .normal)
        button.tintColor = .label // Match the button color to the current theme
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var collectionView: UICollectionView!
    private var userPosts: [Post] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let statsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
    private func createStatView(title: String, value: String) -> (UIStackView, UILabel) {
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return (stackView, valueLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(settingsButton)
        view.addSubview(statsStackView)
        view.addSubview(activityIndicator)
        
        let (soberStatView, soberLabel) = createStatView(title: "Sober Since", value: "0 Weeks")
        let (resetsStatView, resetsLabel) = createStatView(title: "Resets", value: "0")
        let (longestStreakStatView, longestStreakLabel) = createStatView(title: "Longest Streak", value: "0 Weeks")
        
        soberStatLabel = soberLabel
        resetsStatLabel = resetsLabel
        longestStreakStatLabel = longestStreakLabel
        
        
        let usernameTapGesture = UITapGestureRecognizer(target: self, action: #selector(usernameLabelTapped))
        usernameLabel.addGestureRecognizer(usernameTapGesture)
        
        statsStackView.addArrangedSubview(soberStatView)
        statsStackView.addArrangedSubview(resetsStatView)
        statsStackView.addArrangedSubview(longestStreakStatView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        settingsButton.addTarget(self, action: #selector(openSettingsView), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width - 3) / 3, height: (view.frame.size.width - 3) / 3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfilePostCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePostCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        
        setupConstraints()
        
        // Check if cached profile image exists
        if let cachedImageData = UserDefaults.standard.data(forKey: "profileImage"),
           let cachedImage = UIImage(data: cachedImageData) {
            profileImageView.image = cachedImage
        }
        fetchUser()
        fetchPosts()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func usernameLabelTapped(){
        let changeUsernameVC = ChangeUsernameViewController()
        present(changeUsernameVC, animated: true)
    }
    
    @objc private func openSettingsView(){
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        present(settingsVC,animated: true)
    }
    
    @objc private func profileImageTapped() {
        print("Profile image tapped!")
        let vc = ChangePhotoViewController()
        present(vc, animated: true)
        // Handle the action here, e.g., open an image picker, navigate to another view, etc.
       
    }
    
    private func fetchUser() {
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            var imageURL = user?.imageURL ?? ""
            if let error = error {
                print("Failed to fetch user: \(error.localizedDescription)")
                return
            }
            
            if let user = user {
                self.user = user
                DispatchQueue.main.async {
                    self.usernameLabel.text = user.username
                    
                    // Update stats dynamically
                    self.soberStatLabel?.text = "\(Int(user.soberStreak)) days"
                    self.resetsStatLabel?.text = "\(Int(user.numberOfResets))"
                    self.longestStreakStatLabel?.text = "\(Int(user.soberStreak)) days"
                    
                    // Fetch and set profile image
                    imageURL = user.imageURL
                    self.fetchProfileImage(from: imageURL)
                }
            }
        }
    }

    private func fetchProfileImage(from url: String) {
        if let cachedImageData = UserDefaults.standard.data(forKey: "profileImage"),
           let cachedImage = UIImage(data: cachedImageData) {
            // Use cached image
            self.profileImageView.image = cachedImage
            return
        }
        
        // Fetch image from the URL
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed to fetch profile image: \(error.localizedDescription)")
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                print("Failed to create image from data.")
                return
            }
            
            // Save the image to UserDefaults
            UserDefaults.standard.set(imageData, forKey: "profileImage")
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }
    }
    
    private func fetchPosts() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }

        activityIndicator.startAnimating() // Start the activity indicator
        
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating() // Stop the activity indicator
                    }
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No posts found.")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating() // Stop the activity indicator
                    }
                    return
                }

                var posts: [Post] = []
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    let data = document.data()
                    print("POST DATA: \(data)")
                    
                    guard let postID = data["postID"] as? String,
                          let userID = data["userID"] as? String,
                          let imageURL = data["imageUrl"] as? String,
                          let caption = data["caption"] as? String,
                          let commentsCount = data["comments"] as? Int,
                          let likesCount = data["likes"] as? Int,
                          let timestamp = data["timestamp"] as? Timestamp else {
                              print("Missing or invalid data in document: \(document.documentID)")
                              continue
                          }

                    dispatchGroup.enter()
                    print("Fetching image from URL: \(imageURL)")

                    let storageRef = Storage.storage().reference(forURL: imageURL)
                    storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Error fetching image: \(error.localizedDescription)")
                            dispatchGroup.leave()
                            return
                        }
                        
                        guard let imageData = data, let image = UIImage(data: imageData) else {
                            print("Failed to create image from data.")
                            dispatchGroup.leave()
                            return
                        }
                        
                        print("Image fetched successfully for postID: \(postID).")
                        let post = Post(
                            postID: postID,
                            userID: userID,
                            profileImage: UIImage(named: "onboarding1")!,
                            username:self.user!.username, // Update this field if necessary
                            image: image,
                            likeCount: likesCount, // Replace with actual data if available
                            commentCount: commentsCount, // Replace with actual data if available
                            caption: caption,
                            timestamp: timestamp.dateValue()
                        )
                        posts.append(post)
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.activityIndicator.stopAnimating() // Stop the activity indicator
                    self.userPosts = posts
                    self.collectionView.reloadData()
                    
                    print("Posts fetched and collection view updated.")
                }
            }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePostCollectionViewCell.identifier, for: indexPath) as? ProfilePostCollectionViewCell else {
            return UICollectionViewCell()
        }
        let post = userPosts[indexPath.item]
        cell.configure(with: post.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = userPosts[indexPath.item]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}




