import UIKit
import SkeletonView
import FirebaseFirestore
import FirebaseStorage

class CommunityPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    
    // MARK: - Properties
    private var posts: [Post] = []
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .gray
        return spinner
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSkeletonView()
        startLoading()
    }
    
    // MARK: - Setup
    private func setupUI() {
    
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        view.backgroundColor = .carrot
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupConstraints()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(postUploaded),
            name: NSNotification.Name("PostUploaded"),
            object: nil)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSkeletonView() {
        collectionView.isSkeletonable = true
        collectionView.showSkeleton(usingColor: .concrete,transition: .crossDissolve(0.25))
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        fetchPosts()
    }
    
    // MARK: - Data Fetching
    @objc func postUploaded() {
        fetchPosts()
    }
    
    func fetchPosts() {
        db.collection("posts").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting posts: \(error.localizedDescription)")
                self.handleLoadingComplete()
                return
            }
            
            self.posts.removeAll()
            
            let dispatchGroup = DispatchGroup()
            
            for document in querySnapshot!.documents {
                let data = document.data()
                
                if let caption = data["caption"] as? String,
                   let comments = data["comments"] as? Int,
                   let imageUrl = data["imageUrl"] as? String,
                   let likes = data["likes"] as? Int,
                   let timestamp = data["timestamp"] as? Timestamp,
                   let userID = data["userID"] as? String,
                   let postID = data["postID"] as? String {
                    
                    var post = Post(
                        postID: postID,
                        userID: userID,
                        profileImage: UIImage(systemName: "person.circle")!, // Placeholder image
                        username: "Unknown User", // Placeholder username
                        image: UIImage(), // Placeholder post image
                        likeCount: likes,
                        commentCount: comments,
                        caption: caption,
                        timestamp: timestamp.dateValue()
                    )
                    
                    // Download post image
                    dispatchGroup.enter()
                    self.downloadImage(from: imageUrl) { image in
                        post.image = image ?? UIImage()
                        dispatchGroup.leave()
                    }
                    
                    // Fetch user profile image and username
                    dispatchGroup.enter()
                    AuthService.shared.fetchUserByID(userID: userID) { user, error in
                        if let user = user {
                            post.username = user.username
                            // Assume you have a method to fetch profile images if required
                            // post.profileImage = user.profileImage
                        }
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        self.posts.append(post)
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.handleLoadingComplete()
            }
        }
    }

    
    private func handleLoadingComplete() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self?.collectionView.reloadData()
        }
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create image from data")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.isEmpty ? 0 : posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)

        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16
        let height: CGFloat = 600
        return CGSize(width: width, height: height)
    }
    
    // MARK: - SkeletonView DataSource
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PostCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
}
